import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/view/update_user_profile.dart';
import 'package:local_auth/local_auth.dart';
import '../controller/home_screen_controller.dart';
import '../controller/login_controller.dart';
import '../main.dart';
import '../utils/assets.dart';
import 'change_language_dialog.dart';
import 'helper_function/authentication_faceId.dart';
import 'helper_function/change_password_view.dart';
import 'helper_function/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'helper_function/custom_widgets/custom_field.dart';
import 'helper_function/faqs_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _canCheckFingerPrint = false;
  bool authenticated = false;
  bool _isChecked = false;
  final auth = LocalAuthentication();
  String authorized = " not authorized";

  void launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@redimi.net',
      queryParameters: {'subject': 'Help and Support Inquiry'},
    );
    final String emailUrl = emailUri.toString();

    await launch(emailUrl);
  }
  _loadCheckboxValue() {
    setState(() {
      _isChecked = sharedPreferences.getBool(uName!) ?? false;
    });
    print(_isChecked);
  }
  _saveCheckboxValue(bool value) {
    setState(() {
      _isChecked = value;
      sharedPreferences.setBool(uName!, value);
    });
  }

  LoginController loginController = Get.put(LoginController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  String? uName;

  @override
  void initState() {
    bool? checkFingerPrintInLocal = sharedPreferences.getBool("fingerprintAuthRegistered");
    uName = homeScreenController.userModel.username!;
    homeScreenController.setFingerPrint(checkFingerPrintInLocal ?? false);
    loginController.checkBiometric().then((value) {
      setState(() {
        _canCheckFingerPrint = value;
      });
    });
    _loadCheckboxValue();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            ),
          ),
          title: Text(
            "settings_header".tr,
            style: TextStyle(
                fontSize: 32.sp,
                color: MyColors.newAppPrimaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: GetBuilder<HomeScreenController>(builder: (controller) {
          String originalStringPhone = controller.userModel.phone!;
          String newStringPhone = originalStringPhone.substring(3);
          controller.updateUserPhoneNumber.text = newStringPhone;
          String firstNameUser = controller.userModel.firstName!;
          controller.updateUserFirstname.text =
              firstNameUser != "" ? controller.userModel.firstName! : "";
          String secondNameUser = controller.userModel.firstName!;
          controller.updateUserLastname.text =
              secondNameUser != "" ? controller.userModel.lastName! : "";
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const UpdateUserProfile());
                    },
                    child: Text(
                      "Account".tr,
                      style: TextStyle(
                          color: MyColors.newAppPrimaryColor,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: const Divider(
                        height: 1,
                        color: MyColors.newAppPrimaryColor,
                      )),
                  actionTile(
                      onTap: () {
                        Get.to(() => const ChangePasswordView());
                      },
                      leading: MyAssets.password,
                      title: "reset_password_text".tr,
                      trailTitle: "",
                      trailing: Icons.arrow_forward_ios_rounded),
                  actionTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const LanguageSelectionDialog();
                            });
                      },
                      leading: MyAssets.language,
                      title: "language".tr,
                      trailTitle: "language_selected".tr,
                      trailing: Icons.arrow_forward_ios_rounded
                  ),
                  if(Platform.isAndroid)
                    fingurePrintTile(
                        leading: MyAssets.fingerPrint,
                        title: 'finger_print'.tr,
                        controller: controller),
                  if(Platform.isIOS)
                    faceIdTile(
                        leading: MyAssets.faceIdAuth,
                        title: 'face_id_auth'.tr,
                        controller: controller),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "others".tr,
                    style: fieldTitleTextStyle.copyWith(fontSize: 17.sp),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 2.h, bottom: 10.h),
                      child: const Divider(
                        height: 1,
                        color: MyColors.newAppPrimaryColor,
                      )),

                  actionTile(
                      onTap: () async {
                        final Uri _url =
                            Uri.parse('https://redimi.net/about-us-app/');
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      leading: MyAssets.aboutUs,
                      title: "settings_aboutus".tr,
                      trailTitle: "",
                      trailing: Icons.arrow_forward_ios_rounded),
                  // actionTile(
                  //     onTap: () {
                  //       Get.to(FAQsScreen());
                  //     },
                  //     leading: MyAssets.faqs,
                  //     title: "faqs_text".tr,
                  //     trailTitle: "",
                  //     trailing: Icons.arrow_forward_ios_rounded),
                  actionTile(
                      onTap: () {
                        launchEmail();
                        // openMailbox();
                      },
                      leading: MyAssets.help,
                      title: "help_text".tr,
                      trailTitle: "info@redimi.net",
                      showTrail: false,
                      trailing: Icons.arrow_forward_ios_rounded),
                  actionTile(
                      onTap: () async {
                        final Uri _url =
                            Uri.parse('https://redimi.net/privacy-policy-app/');
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      leading: MyAssets.privacy,
                      title: "privacy_text".tr,
                      trailTitle: "",
                      trailing: Icons.arrow_forward_ios_rounded),
                  actionTile(
                      onTap: () async {
                        final Uri _url = Uri.parse(
                            'https://redimi.net/terms-and-conditions/');
                        if (!await launchUrl(_url)) {
                          throw Exception('Could not launch $_url');
                        }
                      },
                      leading: MyAssets.termsCondition,
                      title: "terms_and_conditions".tr,
                      trailTitle: "",
                      trailing: Icons.arrow_forward_ios_rounded),

                  Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: Container(
                      //height: 70,
                      width: Get.width,
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15.h,
                            width: 15.w,
                            child:
                            // Obx(() {
                            //   return
                                Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                    (states) => MyColors.redeemGiftCardBtnClr),
                                value: _isChecked,
                                onChanged: (bool? value) {
                                  //controller.setAgreement(value!);
                                  _saveCheckboxValue(value!);
                                  controller.updateUserChecked(value);
                                  // controller.update();
                                },
                              ),
                            //}),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            child: Text(
                              "second_term_and_condition".tr,
                              maxLines: 5,
                              style: TextStyle(
                                  color: MyColors.newAppPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 25.w),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(
                                      'delete_account'.tr,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    content: Text(
                                      'delete_account_info'.tr,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text(
                                          'lcard_no'.tr,
                                          style:
                                              const TextStyle(color: teal_700),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          controller.update();
                                          loginController.update();
                                          loginController.signOut('');
                                          await controller.deleteAccount();
                                        },
                                        child: Text(
                                          'lcard_yes'.tr,
                                          style:
                                              const TextStyle(color: teal_700),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text(
                                "delete_account".tr,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
  }

  Widget actionTile({
    required String title,
    required String trailTitle,
    required String leading,
    required IconData trailing,
    bool showTrail = true,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      onTap: () => onTap(),
      title: Text(title, style: fieldTitleTextStyle.copyWith(fontSize: 14.sp)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Image.asset(
        leading,
        scale: 4,
      ),
      minLeadingWidth: 20.w,
      trailing: SizedBox(
        width: 150.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              trailTitle,
              style: showTrail
                  ? const TextStyle()
                  : TextStyle(
                      color: MyColors.redeemGiftCardBtnClr, fontSize: 16.sp),
            ),
            if (showTrail)
              Icon(
                trailing,
                color: MyColors.newAppPrimaryColor,
              )
          ],
        ),
      ),
    );
  }

  Widget fingurePrintTile(
      {required String title,
      required String leading,
      required HomeScreenController controller}) {
    return ListTile(
      title: Text(
        title,
        style: fieldTitleTextStyle.copyWith(fontSize: 14.sp),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Image.asset(
        leading,
        scale: 4,
      ),
      minLeadingWidth: 20.w,
      trailing: Obx(() {
        return CupertinoSwitch(
          activeColor: CupertinoColors.activeGreen,
          trackColor: CupertinoColors.inactiveGray,
          thumbColor: CupertinoColors.white,
          value: controller.isAvailFingerPrint.value,
          onChanged: (value) async {
            await _autheticateFingerPrint(value);
          },
        );
      }),
    );
  }

  Future<void> _autheticateFingerPrint(bool value) async {
    if (value && _canCheckFingerPrint) {
      await _authenticate();

      if (authenticated) {
        homeScreenController.setFingerPrint(value);
        if (homeScreenController.isAvailFingerPrint.value) {
          sharedPreferences.setBool("fingerprintAuthRegistered", true);
        }
      } else {
        sharedPreferences.setBool("fingerprintAuthRegistered", false);
      }
    } else {
      homeScreenController.setFingerPrint(value);
      sharedPreferences.setBool("fingerprintAuthRegistered", false);
    }
  }

  Future<void> _authenticate() async {
    bool authenticate = false;

    try {
      authenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to apply more features',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
          authMessages: const <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Oops! Biometric authentication required!',
              cancelButton: 'No thanks',
            ),
            IOSAuthMessages(
              cancelButton: 'No thanks',
            ),
          ]);
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.lockedOut ||
          e.code == auth_error.permanentlyLockedOut) {
        // ...
      } else {
        // ...
      }
    }

    setState(() {
      authorized =
          authenticated ? "Authorized success" : "Failed to authenticate";
      authenticated = authenticate;
      print(authorized);
    });
  }
}
