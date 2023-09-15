import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dbcrypt/dbcrypt.dart';

import '../view/helper_function/colors.dart';
import '../view/helper_function/custom_snackbar.dart';
import '../view/helper_function/custom_widgets/custom_progress_dialog.dart';
import '../view/login_screen.dart';

class RegistrationController extends GetxController {
  //************** Text Editing Controller *************************************
  TextEditingController username = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  //************************ Variables *****************************************
  RxBool isPasswordShow = true.obs;
  RxBool isConfirmPasswordShow = true.obs;
  String smsCode = "";
  String fullNumber = "";
  bool isCheckedFirst = false;
  bool isCheckedSecond = false;

  String? usernameText;
  String? phoneNumberText;
  String? passwordText;

  String? otpCode;
  String? verifyId;


  final FirebaseAuth auth = FirebaseAuth.instance;

  //****************************** URL *****************************************
  var registerCustomerURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/registerCustomer");
  var usernameVerificationURL = Uri.parse(
      '');

  //************************ Functions *****************************************


  shouldObscurePassword(bool isObscure) {
    isPasswordShow.value = isObscure;
  }
  shouldObscureConfirmPassword(bool isObscure) {
    isConfirmPasswordShow.value = isObscure;
  }


  //Function to Verify Username
  Future<bool> usernameVerification(String username) async {
    String feedback = "";
    final response =
        await http.post(usernameVerificationURL, body: {"username": username});
    final jsonBody = jsonEncode({"username": username});
    if (response.statusCode == 200) {
      return true;
    } else {
      final resultJson = jsonDecode(response.body);
      if (resultJson['message'] == 'username already exists') {
        feedback = 'user_name_already_exists'.tr;
      } else if (resultJson['message'] == 'special characters not allowed') {
        feedback = 'special_char_text'.tr;
      } else {
        feedback = 'invalid_username_text'.tr;
      }
      customSnackBar("error_text".tr, feedback, Colors.red);
      return false;
    }
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

  //Register Function, which will check initial things of registration
  Future<void> register(BuildContext context) async {
    usernameText = username.text;
    phoneNumberText = fullNumber;
    passwordText = password.text;
    String confirmPasswordText = confirmPassword.text;
    // CustomProgressDialog.instance.showHideProgressDialog(
    //   context,
    //   'sign_up'.tr,
    //   colorPrimary,
    // );
    bool connected = await isNetworkAvailable();
    //bool usernameCheck = await usernameVerification(usernameText!);
    if (!connected) {
      CustomProgressDialog.instance.hideProgressDialog((val) {});
      customSnackBar("error_text".tr, 'internet_error_text'.tr, Colors.red);
      update();
      return;
    }
    // if(!usernameCheck){
    //   CustomProgressDialog.instance.hideProgressDialog((val) {});
    //   customSnackBar("error_text".tr, 'user_name_already_exists'.tr, Colors.red);
    //   update();
    //   return;
    // }
    if (usernameText != "" && usernameText!.length > 4) {
      CustomProgressDialog.instance.showHideProgressDialog(context, 'sign_up'.tr, colorPrimary,);
      await sendVerificationCodeAndDialogBox(context);
    } else {
      CustomProgressDialog.instance.hideProgressDialog((val) {});
      customSnackBar("error_text".tr, 'something_wrong_text'.tr, Colors.red);
      update();
      return;
    }
  }

  //SMS Verification Firebase
  Future<void> sendVerificationCodeAndDialogBox(BuildContext context) async {
    await auth.verifyPhoneNumber(
        phoneNumber: phoneNumberText,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          // await auth.signInWithCredential(credential);
          await registerCustomer();
          CustomProgressDialog.instance.hideProgressDialog((val) {});
        },
        verificationFailed: (FirebaseAuthException authException) {
          CustomProgressDialog.instance.hideProgressDialog((val) {});
          customSnackBar("error_text".tr, 'invalid_number'.tr, Colors.red);
          update();
        },
        codeSent: (String verificationId, int? resendToken) async {
          CustomProgressDialog.instance.hideProgressDialog((val) {});
          verifyId = verificationId;
          await displayPhoneNumberVerificationDialog(verificationId, context);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Verification Time out");
          print(verificationId);
        });
  }

  //Dialog Box in which User will able to enter SMS Code and get Verified
  displayPhoneNumberVerificationDialog(verificationId, BuildContext context) async {
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
                        "cancel_text".tr,
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
                    smsCode = smsCodeController.text.toString();
                    otpCode = smsCode;
                    CustomProgressDialog.instance.showHideProgressDialog(context, 'Verifying...', colorPrimary);
                    await registerCustomer();
                    // try {
                    //   final AuthCredential authCred = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
                    //   await auth.signInWithCredential(authCred);
                    //   await registerCustomer();
                    // } catch (e) {
                    //   customSnackBar("error_text".tr, 'Error Occurred During OTP Verification'.tr, red);
                    // }
                    CustomProgressDialog.instance.hideProgressDialog((val) {});
                    update();
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

  Future<void> registerCustomer() async {
    String clientSalt = "\$2a${DBCrypt().gensaltWithRounds(10).substring(3)}";
    String clientHash = DBCrypt().hashpw(passwordText!, clientSalt);
    String userName = username.text;
    String numVar = phoneNumberText!.replaceAll("+", "00");

    final response = await http.post(
      registerCustomerURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        "phone": numVar,
        "username": userName,
        "encryptionData": {
          "client_salt": clientSalt,
          "client_hash": clientHash,
        },
        "info": {
          "countryCode": "DE",
          "optInDashboard": isCheckedSecond
        },
        "accountType": "customer",
        "verificationId": verifyId,
        "verificationCode": otpCode,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      Get.back();
      Get.off(LoginScreen());
      customSnackBar('success_text'.tr, 'registered'.tr, colorPrimary);
    } else {
      //user.delete();
      customSnackBar("error_text".tr, "something_wrong_text".tr, Colors.red);
    }
  }
}
