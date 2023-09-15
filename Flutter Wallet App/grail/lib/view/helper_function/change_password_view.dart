import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controller/home_screen_controller.dart';
import 'colors.dart';
import 'custom_widgets/custom_field.dart';
import 'custom_widgets/custom_text_button.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {

  TextEditingController oldPasswordTextController = TextEditingController();
  TextEditingController newPasswordTextController = TextEditingController();
  TextEditingController confirmNewPasswordTextController = TextEditingController();

  FocusNode changeOldPasswordFocusNode = FocusNode();
  FocusNode changeNewPasswordFocusNode = FocusNode();
  FocusNode changeConfirmNewPasswordFocusNode = FocusNode();

  RxBool isChangeOldPasswordShow = true.obs;
  RxBool isChangeNewPasswordShow = true.obs;
  RxBool isChangeConfirmNewPasswordShow = true.obs;

  shouldObscureChangeOldPassword(bool isObscure) {
    isChangeOldPasswordShow.value = isObscure;
  }
  shouldObscureChangeNewPassword(bool isObscure) {
    isChangeNewPasswordShow.value = isObscure;
  }
  shouldObscureChangeConfirmNewPassword(bool isObscure) {
    isChangeConfirmNewPasswordShow.value = isObscure;
  }

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

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
            "pswd_button".tr,
            style: const TextStyle(
                fontSize: 24,
                color: MyColors.newAppPrimaryColor,
                fontWeight: FontWeight.w500),
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
                          padding: EdgeInsets.fromLTRB(40.w, 50.h, 40.w, 20.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Form(
                                key: _form,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('old_password'.tr,
                                        style: fieldTitleTextStyle),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Obx(() {
                                        return CustomTextField(
                                          title: 'old_password'.tr,
                                          controller: oldPasswordTextController,
                                          isReadOnly: false,
                                          onChange: (newVal) {},
                                          focusNode: changeOldPasswordFocusNode,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          nextFocusNode: null,
                                          onSaved: (password) {},
                                          isObscure: isChangeOldPasswordShow.value,
                                          suffixIcon: SufficIcon(
                                              isObscure: isChangeOldPasswordShow.value,
                                              onTap: () {
                                                if (isChangeOldPasswordShow.value) {
                                                  shouldObscureChangeOldPassword(false);
                                                } else {
                                                  shouldObscureChangeOldPassword(true);
                                                }
                                              }),
                                          validator: (val) {},
                                        );
                                      }),
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
                                          title: 'password_text'.tr,
                                          controller: newPasswordTextController,
                                          isReadOnly: false,
                                          onChange: (newVal) {},
                                          focusNode: changeNewPasswordFocusNode,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          nextFocusNode: null,
                                          onSaved: (password) {},
                                          isObscure: isChangeNewPasswordShow.value,
                                          suffixIcon: SufficIcon(
                                              isObscure: isChangeNewPasswordShow.value,
                                              onTap: () {
                                                if (isChangeNewPasswordShow.value) {
                                                  shouldObscureChangeNewPassword(false);
                                                } else {
                                                  shouldObscureChangeNewPassword(true);
                                                }
                                              }),
                                          validator: (text) {
                                            if (text!.isEmpty) {
                                              return "please_enter_password".tr;
                                            }
                                            if(text.length<8){
                                              return "min_8_char_pass_text".tr;
                                            }
                                            return null;
                                          },
                                        );
                                      }),
                                    ),
                                    SizedBox(
                                      height: 18.h,
                                    ),

                                    //************* Confirm New Password Text Field ************************
                                    Text('confirm_new_password'.tr,
                                        style: fieldTitleTextStyle),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5.h),
                                      child: Obx(() {
                                        return CustomTextField(
                                          title: 'confirm_new_password'.tr,
                                          controller: confirmNewPasswordTextController,
                                          isReadOnly: false,
                                          onChange: (newVal) {},
                                          focusNode: changeConfirmNewPasswordFocusNode,
                                          keyboardType: TextInputType.text,
                                          maxLines: 1,
                                          nextFocusNode: null,
                                          onSaved: (password) {},
                                          isObscure: isChangeConfirmNewPasswordShow.value,
                                          suffixIcon: SufficIcon(
                                              isObscure: isChangeConfirmNewPasswordShow.value,
                                              onTap: () {
                                                if (isChangeConfirmNewPasswordShow.value) {
                                                  shouldObscureChangeConfirmNewPassword(false);
                                                } else {
                                                  shouldObscureChangeConfirmNewPassword(true);
                                                }
                                              }),
                                          validator: (text) {
                                            if (text!.isEmpty) {
                                              return "please_enter_password".tr;
                                            }
                                            if(text.length<8){
                                              return "min_8_char_pass_text".tr;
                                            }
                                            return null;
                                          },
                                        );
                                      }),
                                    ),

                                    //************* REGISTER BUTTON ************************
                                  ],
                                ),
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
                                            return;
                                          }
                                          _form.currentState!.save();
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: Text(
                                                    'settings_pswd'.tr,
                                                    style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                  content: Text(
                                                    'settings_pswd'.tr + "?",
                                                    style: const TextStyle(fontSize: 14),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () => Get.back(),
                                                      child: Text(
                                                        'lcard_no'.tr,
                                                        style: const TextStyle(
                                                            color: teal_700),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        await controller.changePassword(context, oldPasswordTextController.text.toString(), newPasswordTextController.text.toString());
                                                      },
                                                      child: Text(
                                                        'lcard_yes'.tr,
                                                        style: const TextStyle(
                                                            color: teal_700),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );
                                        })),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
        ));
  }
}























// showDialog<String>(
// context: context,
// builder: (BuildContext context) =>
// AlertDialog(
// title: Text(
// 'settings_pswd'.tr,
// style: const TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// color: Colors.black),
// ),
// content: Text(
// 'settings_pswd'.tr + "?",
// style: const TextStyle(fontSize: 14),
// ),
// actions: <Widget>[
// TextButton(
// onPressed: () => Get.back(),
// child: Text(
// 'lcard_no'.tr,
// style: const TextStyle(
// color: teal_700),
// ),
// ),
// TextButton(
// onPressed: () async {
// await controller.changePassword();
// },
// child: Text(
// 'lcard_yes'.tr,
// style: const TextStyle(
// color: teal_700),
// ),
// ),
// ],
// ),
// );
