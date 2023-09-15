import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../view/helper_function/colors.dart';
import '../view/helper_function/custom_snackbar.dart';
import '../view/helper_function/custom_widgets/custom_progress_dialog.dart';
import '../view/login_screen.dart';

class ForgetPasswordController extends GetxController {
  //************************ Variables *****************************************
  RxBool isPasswordShow = true.obs;
  RxBool isConfirmPasswordShow = true.obs;
  String fullNumber = "";
  String smsCode = "";


  final FirebaseAuth auth = FirebaseAuth.instance;

  String? passwordText;
  String? verifyId;
  String? otpSms;

  //****************************** URL *****************************************
  var forgetPasswordURL = Uri.parse(
      "https://pumacy-vm2.westeurope.cloudapp.azure.com/api/accounts/forgetPassword");

  //************************ Functions *****************************************

  shouldObscurePassword(bool isObscure) {
    isPasswordShow.value = isObscure;
  }
  shouldObscureConfirmPassword(bool isObscure) {
    isConfirmPasswordShow.value = isObscure;
  }

  //Function to Check Connectivity to Internet
  Future<bool> isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  //Initial Function to get Data to reset password
  Future<void> resetPassword(BuildContext context, String passWord) async {
    passwordText = passWord;
    bool connected = await isNetworkAvailable();
    if (fullNumber == '' || fullNumber == "") {
      customSnackBar(
          "error_text".tr, 'enter_phone_number_text'.tr, colorPrimary);
      return;
    }
    if (!connected) {
      customSnackBar("error_text".tr, 'internet_error_text'.tr, Colors.red);
      return;
    }
    if (passwordText != '' && passwordText!.length >= 8) {
      sendVerificationCodeAndDialogBox(context);
    } else {
      CustomProgressDialog.instance.hideProgressDialog((val) {});
      customSnackBar("error_text".tr, 'something_wrong_text'.tr, Colors.red);
      return;
    }
  }

  //Function to send SMS to given Number
  Future<void> sendVerificationCodeAndDialogBox(BuildContext context) async {
    CustomProgressDialog.instance.showHideProgressDialog(
      context,
      'Verifing...',
      colorPrimary,
    );
    await auth.verifyPhoneNumber(
        phoneNumber: fullNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          await resetCustomerPassword();
          CustomProgressDialog.instance.hideProgressDialog((val) {});
        },
        verificationFailed: (FirebaseAuthException authException) {
          CustomProgressDialog.instance.hideProgressDialog((val) {});
          print(authException.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          verifyId = verificationId;
          CustomProgressDialog.instance.hideProgressDialog((val) {});
          await displayPhoneNumberVerificationDialog(context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Verification Time out");
          print(verificationId);
        });
  }

  //Dialog Box in which User will able to enter SMS Code and get Verified
  displayPhoneNumberVerificationDialog(BuildContext context) async {
    //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    TextEditingController smsCodeController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "enter_phone_verification_code_text".tr,
              style: const TextStyle(fontSize: 16),
            ),
            content: Container(
              height: 75,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: MyColors.giftCardDetailsClr,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        autofocus: false,
                        controller: smsCodeController,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          suffixIconConstraints: BoxConstraints(
                              maxHeight: 15.h
                          ),
                          focusColor: MyColors.greenTealColor,
                          filled: true,
                          border: InputBorder.none,
                          isDense: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 36,
                    width: 80,
                    decoration: BoxDecoration(
                      color: MyColors.redeemGiftCardBtnClr,
                      borderRadius: BorderRadius.circular(15.w),
                    ),
                    child: Center(
                      child: Text(
                        'cancel_text'.tr,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
                    smsCode = smsCodeController.text;
                    otpSms = smsCode;
                    CustomProgressDialog.instance.showHideProgressDialog(
                      context,
                      'Verifing...',
                      colorPrimary,
                    );
                    await resetCustomerPassword();
                    CustomProgressDialog.instance.hideProgressDialog((val) {});
                  },
                  child: Container(
                    height: 36,
                    width: 80,
                    decoration: BoxDecoration(
                      color: MyColors.redeemGiftCardBtnClr,
                      borderRadius: BorderRadius.circular(15.w),
                    ),
                    child: Center(
                      child: Text(
                        'verify_text'.tr,
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> resetCustomerPassword() async {
    String clientSalt = "\$2a${DBCrypt().gensaltWithRounds(10).substring(3)}";
    String clientHash = DBCrypt().hashpw(passwordText!, clientSalt);
    String numVar = fullNumber.replaceAll("+", "00");

    final response = await http.post(
      forgetPasswordURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "phone": numVar,
        "verificationCode": otpSms,
        "encryptionData": {
          "client_salt": clientSalt,
          "client_hash": clientHash,
        },
        "verificationId": verifyId,
      }),
    );

    if (response.statusCode == 200) {
      Get.back();
      Get.back();
      customSnackBar('success_text'.tr, 'password_changed-text'.tr, colorPrimary);
    } else {
      print('Request failed with status: ${response.statusCode}');
      print(response.body);
      customSnackBar("error_text".tr, 'something_wrong_text'.tr, Colors.red);
    }
  }
}
