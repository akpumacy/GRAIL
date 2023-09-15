import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/controller/home_screen_controller.dart';
import '../../../controller/transfer_giftcard_controller.dart';
import '../../../model/user_model.dart';
import '../../../model/voucher_model.dart';
import '../../helper_function/colors.dart';
import '../../helper_function/custom_widgets/custom_field.dart';
import '../../helper_function/qr_code_scanner_view.dart';


class ConvertRewardScreen extends StatelessWidget {

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController shopUsernameTextController = TextEditingController();
  TextEditingController rewardTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //double currentA = userModel?.rewardBalanceAmount != null ? double.parse(userModel!.rewardBalanceAmount!) : 0.0;
    int rewardCount = 0;
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
          "convert_rewards".tr,
          style: TextStyle(
              fontSize: 24.sp,
              color: MyColors.newAppPrimaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: GetBuilder<HomeScreenController>(
          init: HomeScreenController(),
          builder: (controller) {
            return Form(
              key: _form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.transparent,
                      height: 340.h,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                    title: 'shop_username'.tr,
                                    controller: shopUsernameTextController,
                                    isReadOnly: false,
                                    onChange: (newVal) {},
                                    suffixIcon: const SizedBox(),
                                    focusNode: controller.userNameFocusNode,
                                    keyboardType: TextInputType.text,
                                    maxLines: 1,
                                    nextFocusNode: null,
                                    onSaved: () {},
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return "Please Enter Username";
                                      }
                                      return null;
                                    }),
                              ),
                              //const SizedBox(width: 16.0),
                              // CircleAvatar(
                              //   backgroundColor: MyColors.redeemGiftCardBtnClr,
                              //   child: IconButton(
                              //     icon: const Icon(
                              //       Icons.contacts,
                              //       color: Colors.white,
                              //     ),
                              //     onPressed: () {
                              //       // Add your code here for the contacts button
                              //       Get.to(ContactScreen(true));
                              //     },
                              //   ),
                              // ),
                              const SizedBox(
                                width: 4,
                              ),
                              // CircleAvatar(
                              //   backgroundColor: MyColors.redeemGiftCardBtnClr,
                              //   child: IconButton(
                              //     icon: const Icon(
                              //       Icons.camera_alt,
                              //       color: Colors.white,
                              //     ),
                              //     onPressed: () {
                              //       Get.to(QRCodeScannerView(true));
                              //       // Add your code here for the camera button
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                // child: TextField(
                                //   controller: controller.voucherGiftCardAmount,
                                //   decoration: InputDecoration(
                                //     hintText: 'gift_card_amount'.tr,
                                //   ),
                                // ),
                                child: CustomTextField(
                                    title: 'reward_want_to_convert'.tr,
                                    controller: rewardTextController,
                                    isReadOnly: false,
                                    onChange: (newVal) {},
                                    suffixIcon: const SizedBox(),
                                    focusNode: controller.voucherAmount,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    nextFocusNode: null,
                                    onSaved: () {},
                                    validator: (text) {
                                      int enterAmount = int.parse(text ?? '');
                                      rewardCount = enterAmount;
                                      if (text!.isEmpty) {
                                        return "enter_amount".tr;
                                      }
                                      // else if(enterAmount>currentA){
                                      //   return "Amount_Insufficient".tr;
                                      // }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: GestureDetector(
                      onTap: () {
                        final isValid = _form!.currentState!.validate();
                        if (!isValid) {
                          return;
                        }
                        _form.currentState!.save();
                        String shopUsername = shopUsernameTextController.text.toString();
                        String amountInString = rewardTextController.text.toString();
                        int amountInInt = int.parse(amountInString);
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              'convert_rewards'.tr,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            content: Text(
                              'are_you_sure_you_want_to_convert_rewards'.tr,
                              style: const TextStyle(fontSize: 14),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'lcard_no'.tr,
                                  style: const TextStyle(color: teal_700),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //int rewardCount = int.parse(rewardTextController.text);
                                  controller.convertRewardsToBalance(shopUsernameTextController.text, rewardCount);
                                },
                                child: Text(
                                  'lcard_yes'.tr,
                                  style: const TextStyle(color: teal_700),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        // height: 50.h,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        width: 300.w,
                        decoration: BoxDecoration(
                          color: MyColors.redeemGiftCardBtnClr,
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        child: Center(
                          child: Text(
                            "transfer_voucher_amount_text".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
