import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../controller/home_screen_controller.dart';
import 'helper_function/colors.dart';
import 'helper_function/custom_widgets/custom_field.dart';
import 'helper_function/custom_widgets/custom_text_button.dart';

class UpdateUserProfile extends StatefulWidget {
  const UpdateUserProfile({Key? key}) : super(key: key);

  @override
  State<UpdateUserProfile> createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  FocusNode firstNameNode = FocusNode();
  FocusNode lastNameNode = FocusNode();
  FocusNode userEmailNode = FocusNode();
  FocusNode phoneNumberNode = FocusNode();

  @override
  void dispose() {
    firstNameNode.dispose();
    lastNameNode.dispose();
    userEmailNode.dispose();
    phoneNumberNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          ),
          title: Text(
            "navmenu_profile".tr,
            style: TextStyle(
                fontSize: 32.sp,
                color: MyColors.newAppPrimaryColor,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return GetBuilder<HomeScreenController>(
              init: HomeScreenController(),
              builder: (controller) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                      minHeight: constraints.maxHeight - keyboardHeight,
                      maxHeight: double.infinity,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 40.h, horizontal: 40.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "firstName".tr,
                                  style: TextStyle(
                                      color: MyColors.newAppPrimaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                CustomTextField(
                                    title: "firstName".tr,
                                    controller: controller.updateUserFirstname,
                                    suffixIcon: const SizedBox(),
                                    focusNode: firstNameNode,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    isReadOnly: false,
                                    nextFocusNode: lastNameNode,
                                    onChange: (newVal) {},
                                    onSaved: () {},
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Please Enter First Name";
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 18.h,
                                ),

                                Text(
                                  "secondName".tr,
                                  style: TextStyle(
                                      color: MyColors.newAppPrimaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                CustomTextField(
                                    title: "secondName".tr,
                                    controller: controller.updateUserLastname,
                                    suffixIcon: const SizedBox(),
                                    focusNode: lastNameNode,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    isReadOnly: false,
                                    nextFocusNode: userEmailNode,
                                    onChange: (newVal) {},
                                    onSaved: () {},
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Please Enter Last Name";
                                      }
                                      return null;
                                    }),

                                SizedBox(
                                  height: 18.h,
                                ),

                                Text(
                                  "Email".tr,
                                  style: TextStyle(
                                      color: MyColors.newAppPrimaryColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                CustomTextField(
                                    title: "Email".tr,
                                    controller: controller.updateUserAddress,
                                    suffixIcon: const SizedBox(),
                                    focusNode: userEmailNode,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    isReadOnly: false,
                                    nextFocusNode: phoneNumberNode,
                                    onChange: (newVal) {},
                                    onSaved: () {},
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Please Enter Email";
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 18.h,
                                ),

                                Text(
                                  'phone_number_text'.tr,
                                  style: fieldTitleTextStyle,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 5.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: MyColors.giftCardDetailsClr,
                                  ),
                                  child: IntlPhoneField(
                                    controller:
                                        controller.updateUserPhoneNumber,
                                    decoration: InputDecoration(
                                      hintText: 'phone_number_text'.tr,
                                      filled: true,
                                      border: InputBorder.none,
                                      fillColor: Colors.transparent,
                                    ),
                                    textInputAction: TextInputAction.done,
                                    focusNode: phoneNumberNode,
                                    onSubmitted: (_) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    initialCountryCode: 'DE',
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true, decimal: true),
                                    disableLengthCheck: true,
                                    dropdownIconPosition: IconPosition.trailing,
                                    // validator: (phoneNumber) {
                                    //   if (controller.loginWithPhone.value) {
                                    //     if (phoneNumber!.number.isEmpty) {
                                    //       return "Please Enter Phone Number";
                                    //     }
                                    //   }
                                    //   return null;
                                    // },
                                    onChanged: (phone) {
                                      controller.updateUserFullNumber =
                                          phone.completeNumber;
                                    },
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.only(top: 56.h),
                                //   child: Container(
                                //     height: 52,
                                //     width: 280,
                                //     decoration: BoxDecoration(
                                //       border: Border.all(color: colorPrimary),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Center(
                                //       child: TextFormField(
                                //         keyboardType: TextInputType.text,
                                //         obscureText: false,
                                //         autofocus: false,
                                //         // readOnly: false,
                                //         // initialValue: "0x",
                                //         controller: controller.updateUserFirstname,
                                //         style: const TextStyle(
                                //           fontSize: 14,
                                //         ),
                                //         decoration: InputDecoration(
                                //           label: Text(
                                //             "firstName".tr,
                                //             style: const TextStyle(
                                //               fontSize: 14,
                                //               color: darkGray,
                                //             ),
                                //           ),
                                //           filled: true,
                                //           border: InputBorder.none,
                                //           fillColor: Colors.transparent,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 16),
                                //   child: Container(
                                //     height: 52,
                                //     width: 280,
                                //     decoration: BoxDecoration(
                                //       border: Border.all(color: colorPrimary),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Center(
                                //       child: TextFormField(
                                //         keyboardType: TextInputType.text,
                                //         obscureText: false,
                                //         autofocus: false,
                                //         // readOnly: false,
                                //         // initialValue: "0x",
                                //         controller: controller.updateUserLastname,
                                //         style: const TextStyle(
                                //           fontSize: 14,
                                //         ),
                                //         decoration: InputDecoration(
                                //           label: Text(
                                //             "secondName".tr,
                                //             style: const TextStyle(
                                //               fontSize: 14,
                                //               color: darkGray,
                                //             ),
                                //           ),
                                //           filled: true,
                                //           border: InputBorder.none,
                                //           fillColor: Colors.transparent,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 16),
                                //   child: Container(
                                //     height: 52,
                                //     width: 280,
                                //     decoration: BoxDecoration(
                                //       border: Border.all(color: colorPrimary),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Center(
                                //       child: TextFormField(
                                //         keyboardType: TextInputType.text,
                                //         obscureText: false,
                                //         autofocus: false,
                                //         // readOnly: false,
                                //         // initialValue: "0x",
                                //         controller: controller.updateUserAddress,
                                //         style: const TextStyle(
                                //           fontSize: 14,
                                //         ),
                                //         decoration: const InputDecoration(
                                //           label: Text(
                                //             "Email",
                                //             style: TextStyle(
                                //               fontSize: 14,
                                //               color: darkGray,
                                //             ),
                                //           ),
                                //           filled: true,
                                //           border: InputBorder.none,
                                //           fillColor: Colors.transparent,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(top: 16),
                                //   child: Container(
                                //     height: 52,
                                //     width: 280,
                                //     //margin: EdgeInsets.all(10),
                                //     decoration: BoxDecoration(
                                //       borderRadius:
                                //           const BorderRadius.all(Radius.circular(8)),
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
                                //           controller.updateUserFullNumber =
                                //               phone.completeNumber;
                                //         },
                                //         controller: controller.updateUserPhoneNumber,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                // Padding(
                                //   padding: const EdgeInsets.only(top: 24),
                                //   child: InkWell(
                                //     onTap: () {
                                //       //controller.register(context);
                                //       controller.updateUser();
                                //     },
                                //     child: Container(
                                //       height: 42,
                                //       width: 200,
                                //       decoration: BoxDecoration(
                                //         color: colorPrimary,
                                //         borderRadius: BorderRadius.circular(6),
                                //       ),
                                //       child: Center(
                                //         child: Text(
                                //           "update_profile_text".tr,
                                //           style: const TextStyle(
                                //               color: Colors.white, fontSize: 16),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20.0.h),
                                child: CustomTextButton(
                                  OnTap: () {
                                    controller.updateUser();
                                  },
                                  buttonColor: MyColors.redeemGiftCardBtnClr,
                                  butttonTitle: "update_profile_text".tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        }));
  }
}
