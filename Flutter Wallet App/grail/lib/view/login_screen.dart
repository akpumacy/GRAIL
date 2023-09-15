import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grail/view/registration_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/home_screen_controller.dart';
import '../controller/login_controller.dart';
import '../main.dart';
import '../model/user_model.dart';
import '../utils/assets.dart';
import 'forget_password_screen.dart';
import 'helper_function/colors.dart';
import 'helper_function/custom_widgets/custom_field.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import 'helper_function/custom_widgets/custom_text_button.dart';
import 'helper_function/faqs_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  UserModel? userModel;
  bool? hasFingerPrintAuth;
  LoginController controller = Get.put(LoginController());
  TextEditingController password = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  LoginController loginController = Get.put(LoginController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  FocusNode passwordeNode = FocusNode();
  FocusNode phoneNumberFocusNode = FocusNode();
  FocusNode userNameFocusNode = FocusNode();

  TabController? _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  final auth = LocalAuthentication();
  String authorized = " not authorized";
  bool _canCheckBiometric = false;
  late List<BiometricType> _availableBiometric;

  Future<void> _authenticate() async {
    bool authenticated = false;
    final prefs = await SharedPreferences.getInstance();

    try {
      authenticated = await auth.authenticate(
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
      if (authenticated == true) {
        String? clientHash = prefs.getString('clientHash');
        String? clientSalt = prefs.getString('clientSalt');
        if (clientHash != null && clientSalt != null) {
          await loginController
              .saveLocalData(loginController.userModel, shpuldRefreshHash: true)
              .then((value) {
            loginController.saveLocalData(
              homeScreenController.userModel,
            );
            Get.off(() => HomeScreen(loginController.userModel));
          });
        }
      }
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
      print(authorized);
    });
  }

  Future<void> _checkBiometric() async {
    bool canCheckBiometric = false;

    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  Future _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];

    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    setState(() {
      _availableBiometric = availableBiometric;
    });
  }

  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    _controller!.addListener(() {
      if (_controller!.indexIsChanging) {
        setState(() {
          currentIndex = _controller!.previousIndex == 0 ? 1 : 0;
        });
      } else {
        setState(() {
          currentIndex = _controller!.previousIndex == 0 ? 1 : 0;
        });
      }
    });
    hasFingerPrintAuth = sharedPreferences.getBool("fingerprintAuthRegistered");
    if (hasFingerPrintAuth != null && hasFingerPrintAuth == true) {
      loginController.checkBiometric().then((value) {
        setState(() {
          _canCheckBiometric = value;
        });
      });
      // _checkBiometric();
      _getAvailableBiometric();
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    phoneNumberController.dispose();
    password.dispose();
    userNameController.dispose();
    userNameFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    passwordeNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    kPrint("bottom $bottom");
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyColors.newAppPrimaryColor,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   toolbarHeight: 30.h,
        //   elevation: 0,
        //   automaticallyImplyLeading: false,
        //   backgroundColor: MyColors.newAppPrimaryColor,
        // ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              AnimatedCrossFade(
                firstChild: Container(
                    height: 270.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    color: MyColors.newAppPrimaryColor,
                    child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              MyAssets.loginBG2,
                              fit: BoxFit.fill,
                              //height: 200.h,
                              width: double.infinity,
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Text(
                          //     'Welcome'.tr,
                          //     style: TextStyle(
                          //         fontSize: 40.sp,
                          //         color: Colors.white,
                          //         fontWeight: FontWeight.w700),
                          //   ),
                          // ),
                          Align(
                              alignment: Alignment.bottomCenter, child: tabs())
                        ])),
                secondChild: Container(
                    height: 200.h,
                    width: Get.width,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    color: MyColors.newAppPrimaryColor,
                    child: Stack(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Positioned(
                            bottom: 20.h,
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'register_note'.tr,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter, child: tabs())
                        ])),
                crossFadeState: currentIndex == 0
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
              ),
              Expanded(
                  child: Container(
                width: double.infinity,
                // padding: EdgeInsets.fromLTRB(23.w, 40.h, 23.w, 12.h),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: TabBarView(controller: _controller, children: [
                  BuildUserLoginTabView(
                      bottom: bottom,
                      passwordController: password,
                      passwordeNode: passwordeNode,
                      userNameController: userNameController,
                      userNameNode: userNameFocusNode,
                      isFingerPrintSupport: _canCheckBiometric,
                      hasFingerPrintAuth: hasFingerPrintAuth,
                      phoneNumberController: phoneNumberController,
                      autentication: _authenticate,
                      phoneNumberFocusNode: phoneNumberFocusNode),
                  RegistrationScreen()
                ]),
              ))
            ],
          ),
        )

        //  SingleChildScrollView(
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       children: [
        //         Padding(
        //           padding: const EdgeInsets.all(16.0),
        //           child: Row(
        //             children: [
        //               Padding(
        //                 padding: EdgeInsets.only(top: 65.h),
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.start,
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     Text(
        //                       'main_login'.tr,
        //                       overflow: TextOverflow.ellipsis,
        //                       textAlign: TextAlign.left,
        //                       style: const TextStyle(
        //                           fontSize: 46,
        //                           color: purple_700,
        //                           fontWeight: FontWeight.bold),
        //                     ),
        //                     SizedBox(
        //                       height: 4.h,
        //                     ),
        //                     Text(
        //                       "please_sign_in_to_continue".tr,
        //                       overflow: TextOverflow.ellipsis,
        //                       textAlign: TextAlign.left,
        //                       style: TextStyle(
        //                           fontSize: 22.sp,
        //                           color: purple_200,
        //                           fontWeight: FontWeight.bold),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),

        //         SizedBox(
        //           height: 40.h,
        //         ),

        //         ToggleButtons(
        //           children: [
        //             Text(
        //               'phone_text'.tr,
        //               style: TextStyle(fontSize: 16.sp),
        //             ),
        //             Text(
        //               "username_text".tr,
        //               style: TextStyle(fontSize: 16.sp),
        //             ),
        //           ],
        //           isSelected: [
        //             controller.loginWithPhone,
        //             !controller.loginWithPhone
        //           ],
        //           selectedBorderColor: teal_700,
        //           selectedColor: teal_700,
        //           fillColor: toggleButtonFill,
        //           disabledBorderColor: gray_1,
        //           disabledColor: gray_1,
        //           borderRadius: BorderRadius.circular(3),
        //           onPressed: (int index) {
        //             controller.loginWithPhone = index == 0;
        //             controller.update();
        //           },
        //         ),

        //         SizedBox(
        //           height: 18.h,
        //         ),

        //         if (controller.loginWithPhone) _buildPhoneInput(controller),
        //         if (!controller.loginWithPhone) _buildUsernameInput(controller),

        //         //************* PASSWORD TEXT FIELD ************************
        //         Padding(
        //           padding: EdgeInsets.only(top: 18.h),
        //           child: Container(
        //             height: 80.h,
        //             width: 320.w,
        //             decoration: BoxDecoration(
        //               border: Border.all(color: colorPrimary),
        //               borderRadius: const BorderRadius.all(Radius.circular(8)),
        //             ),
        //             child: Center(
        //               child: TextFormField(
        //                 keyboardType: TextInputType.text,
        //                 obscureText: controller.isPasswordShow,
        //                 enabled: true,
        //                 autofocus: false,
        //                 validator: controller.passwordValidator,
        //                 // readOnly: false,
        //                 // initialValue: "0x",
        //                 controller: controller.password,
        //                 onSaved: (password) {
        //                   controller.passwordV = password!;
        //                 },
        //                 style: TextStyle(
        //                   fontSize: 14.sp,
        //                 ),
        //                 decoration: InputDecoration(
        //                   label: Text(
        //                     'password_text'.tr,
        //                     style:
        //                         TextStyle(fontSize: 14.sp, color: darkGray),
        //                   ),
        //                   // hintText: "0x",
        //                   filled: true,
        //                   border: InputBorder.none,
        //                   fillColor: Colors.transparent,
        //                   suffixIcon: InkWell(
        //                     onTap: () {
        //                       controller.isPasswordShow
        //                           ? controller.isPasswordShow = false
        //                           : controller.isPasswordShow = true;
        //                       controller.update();
        //                     },
        //                     child: Icon(
        //                       controller.isPasswordShow
        //                           ? Icons.visibility_off_outlined
        //                           : Icons.visibility_outlined,
        //                       color: darkGray,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),

        //         Padding(
        //           padding: const EdgeInsets.all(10.0),
        //           child: Container(
        //             height: 24.h,
        //             width: 320.w,
        //             child: InkWell(
        //               onTap: () {
        //                 Get.to(() => const ForgetPasswordScreen());
        //               },
        //               child: Text(
        //                 'forget_password_text'.tr,
        //                 textAlign: TextAlign.end,
        //                 style: TextStyle(
        //                     fontSize: 16.sp,
        //                     fontWeight: FontWeight.w500,
        //                     color: Color.fromRGBO(105, 105, 105, 1)),
        //               ),
        //             ),
        //           ),
        //         ),

        //         //************* LOGIN BUTTON ************************
        //         Padding(
        //           padding: EdgeInsets.only(top: 16.h),
        //           child: InkWell(
        //             onTap: () {
        //               if (controller.password.text.isEmpty) {
        //                 customSnackBar('error_text'.tr,
        //                     'fill_field_to_login_text'.tr, Colors.red);
        //               } else {
        //                 controller.userLogin(context);
        //               }
        //             },
        //             child: Container(
        //               height: 50.h,
        //               width: 320.w,
        //               decoration: BoxDecoration(
        //                 color: colorPrimary,
        //                 borderRadius: BorderRadius.circular(6),
        //               ),
        //               child: Center(
        //                 child: Text(
        //                   'sign_in_text'.tr,
        //                   style: TextStyle(
        //                       color: Colors.white, fontSize: 16.sp),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),

        //         //************* PLAIN TEXT ************************

        //         SizedBox(
        //           height: 32.h,
        //         ),

        //         Center(
        //           child: Container(
        //             height: 120.h,
        //             width: Get.width,
        //             child: Center(
        //               child: Column(
        //                 children: [
        //                   Center(
        //                     child: Padding(
        //                       padding: EdgeInsets.only(left: 20.w),
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         children: [
        //                           Text(
        //                             "main_register_note".tr,
        //                             style: TextStyle(
        //                                 color: Colors.black, fontSize: 16.sp),
        //                           ),
        //                           InkWell(
        //                             onTap: () {
        //                               Get.to(const RegistrationScreen());
        //                             },
        //                             child: Text(
        //                               "main_register".tr,
        //                               style: TextStyle(
        //                                   color: purple_700,
        //                                   fontSize: 16.sp,
        //                                   fontWeight: FontWeight.bold),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.all(6.0),
        //                     child: Text(
        //                       "or_text".tr,
        //                       style: TextStyle(
        //                           color: Colors.black,
        //                           fontSize: 24.sp,
        //                           fontWeight: FontWeight.bold),
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: EdgeInsets.all(6.0),
        //                     child: InkWell(
        //                       onTap: () {
        //                         Get.to(HomeScreen(controller.guestUser));
        //                       },
        //                       child: Text(
        //                         'as_guest'.tr,
        //                         style: TextStyle(
        //                             color: purple_200,
        //                             fontSize: 16.sp,
        //                             fontWeight: FontWeight.bold),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),

        //         Padding(
        //           padding: EdgeInsets.only(top: 8.h),
        //           child: Container(
        //             height: 40.h,
        //             width: 360.w,
        //             child: Center(
        //               child: InkWell(
        //                 onTap: () {
        //                   showDialog(
        //                       context: context,
        //                       builder: (BuildContext context) {
        //                         return LanguageSelectionDialog();
        //                       });
        //                 },
        //                 child: Text(
        //                   "Change Language/Sprache ändern",
        //                   maxLines: 2,
        //                   style: TextStyle(
        //                       color: Colors.black,
        //                       fontSize: 18.sp,
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // );

        );
  }

  Widget tabs() {
    return TabBar(
        controller: _controller,
        indicatorSize: TabBarIndicatorSize.label,
        // indicatorWeight: 5,
        indicator: UnderlineTabIndicator(
            borderSide: const BorderSide(
              width: 3,
              color: MyColors.redeemGiftCardBtnClr,
            ),
            borderRadius: BorderRadius.circular(15)),
        indicatorColor: MyColors.redeemGiftCardBtnClr,
        // indicator: const BoxDecoration(
        //   color: MyColors.redeemGiftCardBtnClr,
        // ),
        padding: const EdgeInsets.all(20),
        tabs: [
          Tab(
            child: Text(
              'main_login'.tr,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Tab(
            child: Text(
              'main_register'.tr,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700),
            ),
          )
        ]);
  }
}

Widget _buildPhoneInput(LoginController controller) {
  return Container(
    height: 75.h,
    width: 320.w,
    //margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      border: Border.all(color: colorPrimary),
    ),
    child: Center(
      child: IntlPhoneField(
        decoration: InputDecoration(
          labelText: 'phone_number_text'.tr,
          filled: true,
          border: InputBorder.none,
          fillColor: Colors.transparent,
        ),
        initialCountryCode: 'DE',
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        disableLengthCheck: true,
        onChanged: (phone) {
          controller.fullLoginNumber = phone.completeNumber;
        },
      ),
    ),
  );
}

// Widget _buildUsernameInput(LoginController controller) {
//   return Container(
//     height: 75.h,
//     width: 320.w,
//     //margin: EdgeInsets.all(10),
//     decoration: BoxDecoration(
//       borderRadius: const BorderRadius.all(Radius.circular(8)),
//       border: Border.all(color: colorPrimary),
//     ),
//     child: Center(
//       child: TextFormField(
//         keyboardType: TextInputType.text,
//         obscureText: false,
//         autofocus: false,
//         controller: controller.username,
//         decoration: InputDecoration(
//           hintText: 'enter_username_text'.tr,
//           filled: true,
//           border: InputBorder.none,
//           fillColor: Colors.transparent,
//         ),
//         validator: (value) {
//           if (value!.isEmpty) {
//             return 'Please enter a username';
//           }
//           return null;
//         },
//         //onSaved: (value) => _username = value,
//       ),
//     ),
//   );
// }

class BuildUserLoginTabView extends StatelessWidget {
  double bottom;
  TextEditingController phoneNumberController;
  TextEditingController passwordController;
  TextEditingController userNameController;
  FocusNode passwordeNode;
  FocusNode userNameNode;
  FocusNode phoneNumberFocusNode;
  bool? hasFingerPrintAuth;
  bool isFingerPrintSupport;
  Function autentication;
  BuildUserLoginTabView(
      {required this.passwordeNode,
      required this.phoneNumberFocusNode,
      required this.userNameController,
      required this.userNameNode,
      required this.passwordController,
      required this.phoneNumberController,
      required this.bottom,
      this.hasFingerPrintAuth,
      required this.isFingerPrintSupport,
      required this.autentication,
      super.key});

  LoginController controller = Get.put(LoginController());
  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  void openEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@redimi.net',
      queryParameters: {'subject': 'Help and Support Inquiry'},
    );
    //final String emailUrl = emailUri.toString();

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    kPrint(bottom);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(40.w, 25.h, 40.w, bottom),
        child: Column(
          children: [
            Obx(() {
              return ToggleButtons(
                constraints: BoxConstraints(minWidth: 110.w, minHeight: 30.h),
                children: [
                  Text(
                    'phone_text'.tr,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "username_text".tr,
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
                  ),
                ],
                isSelected: [
                  controller.loginWithPhone.value,
                  !controller.loginWithPhone.value,

                  // controller.loginWithPhone,
                  // !controller.loginWithPhone
                ],
                selectedBorderColor: MyColors.redeemGiftCardBtnClr,
                selectedColor: Colors.white,
                fillColor: MyColors.redeemGiftCardBtnClr,
                disabledBorderColor: MyColors.redeemGiftCardBtnClr,
                disabledColor: gray_1,
                borderColor: MyColors.redeemGiftCardBtnClr,
                borderRadius: BorderRadius.circular(5),
                onPressed: (int index) {
                  controller.loginWithPhone.value = index == 0;
                  //controller.update();
                },
              );
            }),
            SizedBox(
              height: 38.h,
            ),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return AnimatedCrossFade(
                        firstChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'phone_number_text'.tr,
                              style: fieldTitleTextStyle,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: MyColors.giftCardDetailsClr,
                              ),
                              child: IntlPhoneField(
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  labelText: 'phone_number_text'.tr,
                                  filled: true,
                                  border: InputBorder.none,
                                  fillColor: Colors.transparent,
                                ),
                                textInputAction: TextInputAction.next,
                                focusNode: phoneNumberFocusNode,
                                onSubmitted: (_) {
                                  FocusScope.of(context).unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(passwordeNode);
                                },
                                initialCountryCode: 'DE',
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: true, decimal: true),
                                disableLengthCheck: true,
                                dropdownIconPosition: IconPosition.trailing,
                                validator: (phoneNumber) {
                                  if (controller.loginWithPhone.value) {
                                    if (phoneNumber!.number.isEmpty) {
                                      return "Please Enter Phone Number";
                                    }
                                  }
                                  return null;
                                },
                                onChanged: (phone) {
                                  controller.fullLoginNumber =
                                      phone.completeNumber;
                                },
                              ),
                            ),
                          ],
                        ),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'username_text'.tr,
                              style: fieldTitleTextStyle,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            CustomTextField(
                                title: 'enter_username_text'.tr,
                                controller: userNameController,
                                isReadOnly: false,
                                onChange: (newVal) {},
                                focusNode: userNameNode,
                                keyboardType: TextInputType.text,
                                maxLines: 1,
                                nextFocusNode: passwordeNode,
                                onSaved: (password) {
                                  controller.passwordV = password!;
                                },
                                suffixIcon: const SizedBox(),
                                validator: ((value) {
                                  if (!controller.loginWithPhone.value) {
                                    if (value!.isEmpty) {
                                      return "Please Enter User Name";
                                    }
                                  }

                                  return null;
                                })),
                          ],
                        ),
                        crossFadeState: controller.loginWithPhone.value
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300));
                  }),
                  SizedBox(
                    height: 38.h,
                  ),
                  Text('password_text'.tr, style: fieldTitleTextStyle),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            return CustomTextField(
                              title: 'password_text'.tr,
                              controller: passwordController,
                              isReadOnly: false,
                              onChange: (newVal) {},
                              focusNode: passwordeNode,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              nextFocusNode: null,
                              onSaved: (password) {
                                controller.passwordV = password!;
                              },
                              isObscure: controller.isPasswordShow.value,
                              suffixIcon: SufficIcon(
                                  isObscure: controller.isPasswordShow.value,
                                  onTap: () {
                                    if (controller.isPasswordShow.value) {
                                      controller.shouldObscurePassword(false);
                                    } else {
                                      controller.shouldObscurePassword(true);
                                    }
                                  }),
                              validator: controller.passwordValidator,
                            );
                          }),
                        ),
                        if (hasFingerPrintAuth != null &&
                            hasFingerPrintAuth == true &&
                            isFingerPrintSupport)
                          GestureDetector(
                            onTap: () => autentication(),
                            child: Container(
                              margin: EdgeInsets.only(left: 20.w),
                              child: Image.asset(
                                MyAssets.fingerPrint,
                                scale: 3,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 56.h,
            ),
            CustomTextButton(
              buttonColor: MyColors.redeemGiftCardBtnClr,
              butttonTitle: 'sign_in_text'.tr,
              OnTap: () {
                final isValid = _form.currentState!.validate();
                if (!isValid) {
                  return false;
                }
                _form.currentState!.save();
                controller.userLogin(
                    context, passwordController.text, userNameController.text);
              },
            ),
            SizedBox(
              height: 49.h,
            ),
            InkWell(
              onTap: () {
                Get.to(HomeScreen(controller.guestUser));
              },
              child: Text(
                'as_guest'.tr,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 71.h,
            ),
            RichText(
                text: TextSpan(
                    text: 'forget_password_text'.tr,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(() => const ForgetPasswordScreen());
                      },
                    style: TextStyle(
                        color: MyColors.appAmberColor, fontSize: 16.sp),
                    children: [
                  TextSpan(
                    text: 'help'.tr,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        openEmailClient();
                      },
                  ),
                  TextSpan(
                    text: 'faq'.tr,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(FAQsScreen());
                      },
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
