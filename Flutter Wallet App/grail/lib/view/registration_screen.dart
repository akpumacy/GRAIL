import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:get/get.dart';
import '../controller/registration_controller.dart';
import 'helper_function/colors.dart';
import 'helper_function/custom_snackbar.dart';
import 'helper_function/custom_widgets/custom_field.dart';
import 'helper_function/custom_widgets/custom_text_button.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return GetBuilder<RegistrationController>(
        init: RegistrationController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  40.w, 25.h, 40.w, bottom > 0 ? bottom : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('username_min_char'.tr,
                            style: fieldTitleTextStyle),
                        SizedBox(
                          height: 5.h,
                        ),
                        CustomTextField(
                            title: 'username_example_text'.tr,
                            controller: controller.username,
                            isReadOnly: false,
                            onChange: (newVal) {},
                            suffixIcon: const SizedBox(),
                            focusNode: controller.userNameFocusNode,
                            keyboardType: TextInputType.text,
                            maxLines: 1,
                            nextFocusNode: controller.phoneNumberFocusNode,
                            onSaved: () {},
                            validator: (text) {
                              if (text!.isEmpty) {
                                return "Please Enter Username";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 18.h,
                        ),
                        Text('phone_number_text'.tr,
                            style: fieldTitleTextStyle),
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
                            controller: controller.phoneNumber,
                            focusNode: controller.phoneNumberFocusNode,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                              FocusScope.of(context)
                                  .requestFocus(controller.passwordFocusNode);
                            },
                            decoration: InputDecoration(
                              labelText: 'phone_number_text'.tr,
                              filled: true,
                              border: InputBorder.none,
                              fillColor: Colors.transparent,
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                color: darkGray,
                              ),
                            ),
                            dropdownIconPosition: IconPosition.trailing,
                            initialCountryCode: 'DE',
                            disableLengthCheck: true,
                            onChanged: (phone) {
                              controller.fullNumber = phone.completeNumber;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        Text('password_text'.tr, style: fieldTitleTextStyle),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(() {
                          return CustomTextField(
                              title: 'password_text'.tr,
                              controller: controller.password,
                              isReadOnly: false,
                              isObscure: controller.isPasswordShow.value,
                              onChange: (newVal) {},
                              focusNode: controller.passwordFocusNode,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              nextFocusNode:
                                  controller.confirmPasswordFocusNode,
                              onSaved: () {},
                              suffixIcon: SufficIcon(
                                  isObscure: controller.isPasswordShow.value,
                                  onTap: () {
                                    if (controller.isPasswordShow.value) {
                                      controller.shouldObscurePassword(false);
                                    } else {
                                      controller.shouldObscurePassword(true);
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
                              });
                        }),
                        SizedBox(
                          height: 18.h,
                        ),
                        Text('register_confirmPassword'.tr,
                            style: fieldTitleTextStyle),
                        SizedBox(
                          height: 5.h,
                        ),
                        Obx(() {
                          return CustomTextField(
                              title: 'register_confirmPassword'.tr,
                              controller: controller.confirmPassword,
                              isReadOnly: false,
                              onChange: (newVal) {},
                              focusNode: controller.confirmPasswordFocusNode,
                              keyboardType: TextInputType.text,
                              maxLines: 1,
                              isObscure: controller.isConfirmPasswordShow.value,
                              suffixIcon: SufficIcon(
                                  isObscure:
                                      controller.isConfirmPasswordShow.value,
                                  onTap: () {
                                    if (controller
                                        .isConfirmPasswordShow.value) {
                                      controller
                                          .shouldObscureConfirmPassword(false);
                                    } else {
                                      controller
                                          .shouldObscureConfirmPassword(true);
                                    }
                                  }),
                              nextFocusNode: null,
                              onSaved: () {},
                              validator: (text) {
                                if (text!.isEmpty) {
                                  return "please_enter_confirm_password".tr;
                                } if (text != controller.password.text) {
                                  return "password_not_match_text".tr;
                                }
                                if(text.length < 8){
                                  return "min_8_char_pass_text".tr;
                                }
                                return null;
                              });
                        }),
                        SizedBox(
                          height: 44.h,
                        ),

                        //************* FIRST TERM AND CONDITION ************************
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                    (states) => MyColors.redeemGiftCardBtnClr),
                                value: controller.isCheckedFirst,
                                onChanged: (bool? value) {
                                  controller.isCheckedFirst = value!;
                                  controller.update();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              // height: 84.h,
                              // width: 280.w,
                              child: Text(
                                "first_term_and_condition".tr,
                                maxLines: 4,
                                style: const TextStyle(
                                    color: MyColors.newAppPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 32.h,
                        ),

                        //************* SECOND TERM AND CONDITION ************************
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                              child: Checkbox(
                                fillColor: MaterialStateProperty.resolveWith(
                                    (states) => MyColors.redeemGiftCardBtnClr),
                                value: controller.isCheckedSecond,
                                onChanged: (bool? value) {
                                  controller.isCheckedSecond = value!;
                                  controller.update();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 1,
                            ),
                            Expanded(
                              child: Text(
                                "second_term_and_condition".tr,
                                maxLines: 5,
                                style: const TextStyle(
                                    color: MyColors.newAppPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 28.h,
                        ),
                      ],
                    ),
                  ),
                  // //************* REGISTER BUTTON ************************
                  CustomTextButton(
                    buttonColor: MyColors.redeemGiftCardBtnClr,
                    butttonTitle: 'main_register'.tr,
                    OnTap: () {
                      final isValid = _form.currentState!.validate();
                      if (!isValid) {
                        return false;
                      }
                      _form.currentState!.save();
                      if (controller.isCheckedFirst) {
                        controller.register(context);
                      }
                      else {
                        customSnackBar("error_text".tr, 'please_accept_terms'.tr, colorPrimary);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
