import 'dart:convert';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../model/user_model.dart';
import '../view/change_language_dialog.dart';
import '../view/helper_function/colors.dart';
import '../view/helper_function/custom_snackbar.dart';
import '../view/helper_function/custom_widgets/custom_progress_dialog.dart';
import '../view/home_screen.dart';

class LoginController extends GetxController {
  //************** Text Editing Controller *************************************
  TextEditingController walletAddress = TextEditingController();
  //TextEditingController password = TextEditingController();

  // TextEditingController phoneNumberController = TextEditingController();

  // FocusNode passwordeNode = FocusNode();
  // FocusNode phoneNumberFocusNode = FocusNode();

  UserModel userModel = UserModel();

  //************************ Variables *****************************************

  String fullLoginNumber = "";
  String getSaltData = "";

  RxBool isPasswordShow = true.obs;
  String addressV = '', passwordV = '';
  RxBool loginWithPhone = true.obs;
  bool loginWithUsername = false;

  updateLoginType(bool isUserName) {
    loginWithPhone.value = isUserName;
  }

  shouldObscurePassword(bool isObscure) {
    isPasswordShow.value = isObscure;
  }

  late SharedPreferences prefs;

  //****************************** URL *****************************************
  var getSaltURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/getClientSalt");
  var loginCustomerURL = Uri.parse(
      'https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/loginCustomer');
  var refreshHashURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/changePassword");

  String addressValidator(String? address) {
    if (address == '' || address!.isEmpty) {
      return 'Please enter text';
    } else if (address == '') {
      return 'Please enter your email';
    } else {
      return '';
    }
  }

  String? passwordValidator(String? password) {
    if (password == '' || password!.isEmpty) {
      return 'Please enter password';
    } else if (password == '') {
      return 'Please enter your password';
    } else if (password.length < 8) {
      return 'Your password should be more than 8 characters';
    } else if (password.contains(' ')) {
      return 'Your password should not contain spaces';
    }
    return null;
  }

  //**************************** USER LOGIN ************************************

  Future<bool> userLogin(
    BuildContext context,
    String password,
    String userName,
  ) async {
    prefs = await SharedPreferences.getInstance();
    String usernameText = userName;
    String num = fullLoginNumber.replaceAll("+", "00");
    // ignore: use_build_context_synchronously
    CustomProgressDialog.instance.showHideProgressDialog(
      context,
      'Signing-In...',
      colorPrimary,
    );
    if (loginWithPhone.value) {
      try {
        final response =
            await http.post(getSaltURL, body: {"phone": num, "mode": "phone"});
        final resultJson = jsonDecode(response.body);
        if (resultJson['message'] == "success") {
          getSaltData = resultJson['data'];
          prefs.setString("clientSalt", getSaltData);
          userModel.clientSalt = getSaltData;
          kPrint(getSaltData);
        }
      } catch (error) {
        CustomProgressDialog.instance.hideProgressDialog(() {});
        update();
        return false;
      }
    } else {
      try {
        final response = await http.post(getSaltURL,
            body: {"username": usernameText, "mode": "username"});
        final resultJson = jsonDecode(response.body);
        if (resultJson['message'] == "success") {
          getSaltData = resultJson['data'];
          kPrint(getSaltData);
        }
      } catch (error) {
        CustomProgressDialog.instance.hideProgressDialog(() {});
        update();
        return false;
      }
    }
    kPrint("Get Salt Function Completed");
    bool isLoginSuccessful = await loginCustomer(usernameText, num, password);

    kPrint("isLoginSuccessful $isLoginSuccessful");
    return isLoginSuccessful;
  }

  Future<bool> loginCustomer(
      String usernameText, String phoneNumberText, String password) async {
    final jsonBody = {};
    String passwordText = password;

    if (loginWithPhone.value) {
      jsonBody['mode'] = 'phone';
      jsonBody['phone'] = phoneNumberText;
    } else {
      jsonBody['mode'] = 'username';
      jsonBody['username'] = usernameText;
    }
    try {
      final clientHash = DBCrypt().hashpw(passwordText, getSaltData);
      jsonBody['client_hash'] = clientHash;

      final response = await http.post(loginCustomerURL, body: jsonBody);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String num = data['data']['phone'];
        String phoneNum = num.replaceAll("00", "+");
        prefs = await SharedPreferences.getInstance();
        prefs.setString('phone', phoneNum);

        prefs.setString('username', '${data['data']['username']}');
        prefs.setString('countryCode', '${data['data']['accountInfo']['countryCode']}');
        prefs.setString('clientHash', clientHash).then((value) {
          kPrint("is save value $value");
        });
        prefs.setString('clientSalt', getSaltData);
        prefs.setString('password', passwordText);

        final firstnameServer = data['data']['accountInfo'].containsKey('firstName') ? data['data']['accountInfo']['firstName'] : "";
        prefs.setString('firstname', firstnameServer);
        final lastnameServer = data['data']['accountInfo'].containsKey('lastName')? data['data']['accountInfo']['lastName'] : "";
        prefs.setString('lastname', lastnameServer);

        userModel.username = '${data['data']['username']}';
        userModel.firstName = firstnameServer;
        userModel.lastName = lastnameServer;
        userModel.phone = phoneNum;
        userModel.password = passwordText;
        userModel.id = '${data['data']['id']}'.toString();
        userModel.countryCode = '${data['data']['accountInfo']['countryCode']}';
        userModel.clientHash = clientHash;
        userModel.clientSalt = getSaltData;
        userModel.balanceLength = '${data['data']['balances_length']}';
        userModel.balanceAmount = '${data['data']['balances_amount']}';
        userModel.rewardBalanceAmount = '${data['data']['rewardBalance_amount']}';
        prefs.setString("balanceLength", userModel.balanceLength!);
        prefs.setString("balanceAmount", userModel.balanceAmount!);
        prefs.setString("rewardBalanceAmount", userModel.rewardBalanceAmount!);
        prefs.setString("phoneNum", phoneNum);
        prefs.setString("clientHash", clientHash);
        prefs.setString("username", userModel.username!);
        prefs.setString("password", passwordText);


        kPrint("Login Success");

        await refreshHash();
        CustomProgressDialog.instance.hideProgressDialog((val) {});
        Get.off(() => HomeScreen(userModel));
        return true;
      } else {
        kPrint("Error $response");
        CustomProgressDialog.instance.hideProgressDialog((val) {});
        update();
        customSnackBar("error_text".tr, "incorrect_username".tr, red);
        return false;
      }
    } catch (error) {
      CustomProgressDialog.instance.hideProgressDialog((val) {});
      update();
      customSnackBar("error_text".tr, "incorrect_username".tr, red);
      return false;
    }
  }

  Future<void> saveLocalData(UserModel userModel,
      {bool shpuldRefreshHash = false}) async {
    final prefs = await SharedPreferences.getInstance();

    userModel.password = prefs.getString('password');
    userModel.username = prefs.getString('username');

    userModel.phone = prefs.getString('phone');
    //userModel.vouchersAmount = prefs.getString('totalVoucherBalance')!;
    //userModel.vouchersLength = prefs.getString('totalVouchers');
    //userModel.couponsLength = prefs.getString('totalCoupons');
    //userModel.walletAddress = prefs.getString('walletAddress');
    userModel.balanceLength = prefs.getString("balanceLength");
    userModel.balanceAmount = prefs.getString("balanceAmount");
    userModel.rewardBalanceAmount = prefs.getString("rewardBalanceAmount");
    userModel.phone = prefs.getString("phoneNum");

    userModel.countryCode = prefs.getString('countryCode');
    userModel.clientHash = prefs.getString('clientHash');
    userModel.clientSalt = prefs.getString('clientSalt');

    userModel.firstName = prefs.getString('firstname');
    userModel.lastName = prefs.getString('lastname');

    if (shpuldRefreshHash) {
      await refreshHash();
      kPrint(
          "clientHash ${userModel.clientHash} oldClientHash ${userModel.oldClientHash} clientSalt ${userModel.clientSalt} username ${userModel.username} phone ${userModel.phone} password ${userModel.password} countryCode ${userModel.countryCode} firstName ${userModel.firstName} lastName ${userModel.lastName}");
    }
  }

  Future<void> signOut(String keyToKeep) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = sharedPreferences.getKeys();
    prefs.clear();

    // for (String key in keys) {
    //   if (key != keyToKeep) {
    //     await sharedPreferences.remove(key);
    //   }
    // }
  }

  Future<void> refreshHash() async {
    try {
      prefs = await SharedPreferences.getInstance();
      String oldClientHash = prefs.getString("clientHash")!;

      String refreshClientSalt = "\$2a${DBCrypt().gensaltWithRounds(10).substring(3)}";
      String refreshClientHash =
          DBCrypt().hashpw(userModel.password!, refreshClientSalt);

      kPrint("password ${userModel.password}");
      kPrint("username ${userModel.username}");
      kPrint("oldClientHash ${userModel.clientHash}");
      kPrint("refreshClientSalt $refreshClientSalt");
      kPrint("refreshClientHash $refreshClientHash");
      final response = await http.post(
        refreshHashURL,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(
          {
            "username": userModel.username,
            "old_client_hash": oldClientHash,
            "new_client_salt": refreshClientSalt,
            "new_client_hash": refreshClientHash
          },
        ),
      );
      // $2a$10$/9WBCDLI8uXJR3BCmvuQqumVzCxZ3azNOlwqDCQHG0UYV2Uz6xANK

      prefs.setString('clientHash', refreshClientHash);
      prefs.setString('clientSalt', refreshClientSalt);

      if (response.statusCode == 200) {
        userModel.clientSalt = refreshClientSalt;
        userModel.clientHash = refreshClientHash;
        prefs.setString('clientHash', refreshClientHash);
        prefs.setString('clientSalt', refreshClientSalt);
        //goto_vouchers();
        kPrint("Refresh Hash and Salt successfully");
        kPrint(userModel.clientHash);
      } else {
        kPrint("Refreshing Hashed Failed");
        kPrint("My Body is ${response.body}");
      }
    } catch (error) {
      kPrint(error);
    }
  }

  // Login as Guest
  UserModel guestUser = UserModel(
    firstName: "Guest",
    lastName: "User",
    vouchersLength: "0",
  );

  Future<bool> checkBiometric() async {
    final auth = LocalAuthentication();
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
      return canCheckBiometric;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }

  // String _selectedLanguage = 'English';
  // Map<String, String> words;
  //
  // Future<void> loadWords(String languageCode) async {
  //   String jsonString = await rootBundle.loadString('assets/$languageCode.json');
  //   Map<String, dynamic> jsonMap = json.decode(jsonString);
  //   words = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  //   update();
  // }
  //
  // Future<void> selectLanguage(BuildContext context) async {
  //   prefs = await SharedPreferences.getInstance();
  //   String selectedLanguage = await showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return LanguageSelectionDialog(selectedLanguage: _selectedLanguage);
  //       });
  //   if (selectedLanguage != null) {
  //     _selectedLanguage = selectedLanguage;
  //     loadWords(_selectedLanguage == 'English' ? 'en' : 'de');
  //     prefs.setString('language', _selectedLanguage == 'English' ? 'en' : 'de');
  //   }
  // }
  //
  //
  // Future<String> getLanguage() async {
  //   prefs = await SharedPreferences.getInstance();
  //   String lang = "en";
  //   lang = prefs.getString('language');
  //   return lang;
  // }
}
