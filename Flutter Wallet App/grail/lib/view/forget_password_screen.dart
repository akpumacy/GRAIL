import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


import '../controller/forget_password_controller.dart';
import 'helper_function/colors.dart';
import 'helper_function/custom_widgets/custom_field.dart';
import 'helper_function/custom_widgets/custom_text_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController passordController = TextEditingController();
  TextEditingController confirmPassordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPassordFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();


  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void dispose() {
    passordController.dispose();
    confirmPassordController.dispose();
    phoneController.dispose();
    passwordFocusNode.dispose();
    confirmPassordFocusNode.dispose();
    phoneFocusNode.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
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
          "password_text".tr,
          style: const TextStyle(
              fontSize: 24,
              color: MyColors.newAppPrimaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return GetBuilder<ForgetPasswordController>(
            init: ForgetPasswordController(),
            builder: (controller) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: constraints.copyWith(
                    minHeight: constraints.maxHeight - keyboardHeight,
                    maxHeight: double.infinity,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(40.w, 50.h, 40.w, 20.h),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Padding(
                                //   padding: EdgeInsets.only(top: 24.h),
                                //   child: Container(
                                //     height: 75.h,
                                //     width: 320.w,
                                //     //margin: EdgeInsets.all(10),
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.all(Radius.circular(8)),
                                //       border: Border.all(color: colorPrimary),
                                //     ),
                                //     child: Center(
                                //       child: IntlPhoneField(
                                //         decoration: InputDecoration(
                                //           labelText: 'phone_number_text'.tr,
                                //           filled: true,
                                //           border: InputBorder.none,
                                //           fillColor: Colors.transparent,
                                //           labelStyle: const TextStyle(
                                //             fontSize: 14,
                                //             color: darkGray,
                                //           ),
                                //         ),
                                //         initialCountryCode: 'DE',
                                //         disableLengthCheck: true,
                                //         onChanged: (phone) {
                                //           print(phone.completeNumber);
                                //           controller.fullNumber = phone.completeNumber;
                                //         },
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                Text('phone_number_text'.tr,
                                    style: fieldTitleTextStyle),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  margin: EdgeInsets.only(
                                    top: 5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: MyColors.giftCardDetailsClr,
                                  ),
                                  child: IntlPhoneField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      labelText: 'phone_number_text'.tr,
                                      filled: true,
                                      border: InputBorder.none,
                                      fillColor: Colors.transparent,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    focusNode: phoneFocusNode,
                                    onSubmitted: (_) {
                                      FocusScope.of(context).unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(passwordFocusNode);
                                    },
                                    initialCountryCode: 'DE',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    disableLengthCheck: true,
                                    dropdownIconPosition: IconPosition.trailing,
                                    onChanged: (phone) {
                                      controller.fullNumber =
                                          phone.completeNumber;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),

                                //************* PASSWORD TEXT FIELD ************************
                                Text('new_password'.tr,
                                    style: fieldTitleTextStyle),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Obx(() {
                                    return CustomTextField(
                                      title: 'new_password'.tr,
                                      controller: passordController,
                                      isReadOnly: false,
                                      onChange: (newVal) {},
                                      focusNode: passwordFocusNode,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      nextFocusNode: confirmPassordFocusNode,
                                      onSaved: (password) {},
                                      isObscure: controller.isPasswordShow.value,
                                      suffixIcon: SufficIcon(
                                          isObscure:
                                              controller.isPasswordShow.value,
                                          onTap: () {
                                            if (controller.isPasswordShow.value) {
                                              controller
                                                  .shouldObscurePassword(false);
                                            } else {
                                              controller
                                                  .shouldObscurePassword(true);
                                            }
                                          }),
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "please_enter_password".tr;
                                        }
                                        if(text.length < 8){
                                          return "min_8_char_pass_text".tr;
                                        }
                                        return null;
                                      },
                                    );
                                  }),

                                  // Container(
                                  //   height: 80.h,
                                  //   width: 320.w,
                                  //   decoration: BoxDecoration(
                                  //     border: Border.all(color: colorPrimary),
                                  //     borderRadius: BorderRadius.circular(8),
                                  //   ),
                                  //   child: Center(
                                  //     child: TextFormField(
                                  //       keyboardType: TextInputType.text,
                                  //       obscureText: controller.isPasswordShow,
                                  //       enabled: true,
                                  //       autofocus: false,
                                  //       // readOnly: false,
                                  //       // initialValue: "0x",
                                  //       controller: controller.passwordTextController,
                                  //       style: const TextStyle(
                                  //         fontSize: 14,
                                  //       ),
                                  //       decoration: InputDecoration(
                                  //         label: Text(
                                  //           "register_password".tr,
                                  //           style: const TextStyle(
                                  //               fontSize: 14, color: darkGray),
                                  //         ),
                                  //         // hintText: "0x",
                                  //         filled: true,
                                  //         border: InputBorder.none,
                                  //         fillColor: Colors.transparent,
                                  //         suffixIcon: InkWell(
                                  //           onTap: () {
                                  //             controller.isPasswordShow
                                  //                 ? controller.isPasswordShow = false
                                  //                 : controller.isPasswordShow = true;
                                  //             controller.update();
                                  //           },
                                  //           child: Icon(
                                  //             controller.isPasswordShow
                                  //                 ? Icons.visibility_off_outlined
                                  //                 : Icons.visibility_outlined,
                                  //             color: darkGray,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),

                                Text('confirm_new_password'.tr,
                                    style: fieldTitleTextStyle),
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Obx(() {
                                    return CustomTextField(
                                      title: 'confirm_new_password'.tr,
                                      controller: confirmPassordController,
                                      isReadOnly: false,
                                      onChange: (newVal) {},
                                      focusNode: confirmPassordFocusNode,
                                      keyboardType: TextInputType.text,
                                      maxLines: 1,
                                      nextFocusNode: null,
                                      onSaved: (password) {},
                                      isObscure:
                                          controller.isConfirmPasswordShow.value,
                                      suffixIcon: SufficIcon(
                                          isObscure: controller
                                              .isConfirmPasswordShow.value,
                                          onTap: () {
                                            if (controller
                                                .isConfirmPasswordShow.value) {
                                              controller
                                                  .shouldObscureConfirmPassword(
                                                      false);
                                            } else {
                                              controller
                                                  .shouldObscureConfirmPassword(
                                                      true);
                                            }
                                          }),
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "please_enter_confirm_password".tr;
                                        } if (text != passordController.text) {
                                          return "password_not_match_text".tr;
                                        }
                                        if(text.length < 8){
                                          return "min_8_char_pass_text".tr;
                                        }
                                        return null;
                                      },
                                    );
                                  }),
                                ),

                                //************* CONFIRM PASSWORD TEXT FIELD ************************
                                // Padding(
                                //   padding: EdgeInsets.only(top: 24.h),
                                //   child: Container(
                                //     height: 80.h,
                                //     width: 320.w,
                                //     decoration: BoxDecoration(
                                //       border: Border.all(color: colorPrimary),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Center(
                                //       child: TextFormField(
                                //         keyboardType: TextInputType.text,
                                //         obscureText: controller.isConfirmPasswordShow,
                                //         enabled: true,
                                //         autofocus: false,
                                //         // readOnly: false,
                                //         // initialValue: "0x",
                                //         controller:
                                //             controller.confirmPasswordTextController,
                                //         style: const TextStyle(
                                //           fontSize: 14,
                                //         ),
                                //         decoration: InputDecoration(
                                //           label: Text(
                                //             "register_confirmPassword".tr,
                                //             style: const TextStyle(
                                //                 fontSize: 14, color: darkGray),
                                //           ),
                                //           // hintText: "0x",
                                //           filled: true,
                                //           border: InputBorder.none,
                                //           fillColor: Colors.transparent,
                                //           suffixIcon: InkWell(
                                //             onTap: () {
                                //               controller.isConfirmPasswordShow
                                //                   ? controller.isConfirmPasswordShow = false
                                //                   : controller.isConfirmPasswordShow = true;
                                //               controller.update();
                                //             },
                                //             child: Icon(
                                //               controller.isConfirmPasswordShow
                                //                   ? Icons.visibility_off_outlined
                                //                   : Icons.visibility_outlined,
                                //               color: darkGray,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                //************* REGISTER BUTTON ************************
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 30.h),
                                  child: CustomTextButton(
                                      buttonColor: MyColors.redeemGiftCardBtnClr,
                                      buttonWidth: double.infinity,
                                      butttonTitle: "reset_password_text".tr,
                                      OnTap: () {
                                        final isValid = _form.currentState!.validate();
                                        if (!isValid) {
                                          return false;
                                        }
                                        _form.currentState!.save();
                                        controller.resetPassword(context, passordController.text);
                                      })),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}
