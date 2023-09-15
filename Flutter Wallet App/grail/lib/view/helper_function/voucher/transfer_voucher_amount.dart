import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/transfer_giftcard_controller.dart';
import '../../../model/user_model.dart';
import '../../../model/voucher_model.dart';
import '../colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../contacts_screen.dart';
import '../custom_widgets/custom_field.dart';
import '../qr_code_scanner_view.dart';

class TransferVoucherAmountView extends StatelessWidget {
  Voucher? v;
  UserModel? userModel;

  TransferVoucherAmountView(UserModel user, Voucher voucher, {Key? key}) : super(key: key) {
    v = voucher;
    userModel = user;
  }

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double currentA = v?.currentAmount.toDouble();
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
          "transam_header".tr,
          style: TextStyle(
              fontSize: 24.sp,
              color: MyColors.newAppPrimaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: GetBuilder<TransferGiftCardController>(
          init: TransferGiftCardController(),
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
                                // child: TextField(
                                //   controller: controller
                                //       .voucherOwnershipTransferTextController,
                                //   decoration: InputDecoration(
                                //     hintText: 'username_example_text'.tr,
                                //   ),
                                // ),
                                child: CustomTextField(
                                    title: 'username_example_text'.tr,
                                    controller: controller.voucherOwnershipTransferTextController,
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
                              const SizedBox(width: 16.0),
                              CircleAvatar(
                                backgroundColor: MyColors.redeemGiftCardBtnClr,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.contacts,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Add your code here for the contacts button
                                    Get.to(ContactScreen(true));
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              CircleAvatar(
                                backgroundColor: MyColors.redeemGiftCardBtnClr,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Get.to(QRCodeScannerView(true));
                                    // Add your code here for the camera button
                                  },
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 16,
                          // ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       // child: TextField(
                          //       //   controller: controller.voucherRecipientCode,
                          //       //   decoration: InputDecoration(
                          //       //     hintText: 'Recipient_Gift_Card_Code'.tr,
                          //       //   ),
                          //       // ),
                          //       child: CustomTextField(
                          //           title: 'Recipient_Gift_Card_Code'.tr,
                          //           controller: controller.voucherRecipientCode,
                          //           isReadOnly: false,
                          //           onChange: (newVal) {},
                          //           suffixIcon: const SizedBox(),
                          //           focusNode: controller.receiverVoucherCodeFocusNode,
                          //           keyboardType: TextInputType.text,
                          //           maxLines: 1,
                          //           nextFocusNode: null,
                          //           onSaved: () {},
                          //           validator: (text) {
                          //             return null;
                          //           }),
                          //     ),
                          //     const SizedBox(width: 16.0),
                          //     CircleAvatar(
                          //       backgroundColor: MyColors.redeemGiftCardBtnClr,
                          //       child: IconButton(
                          //         icon: const Icon(
                          //           Icons.camera_alt,
                          //           color: Colors.white,
                          //         ),
                          //         onPressed: () {
                          //           Get.to(const QRCodeScannerViewVoucher());
                          //           // Add your code here for the camera button
                          //         },
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
                                    title: 'gift_card_amount'.tr,
                                    controller: controller.voucherGiftCardAmount,
                                    isReadOnly: false,
                                    onChange: (newVal) {},
                                    suffixIcon: const SizedBox(),
                                    focusNode: controller.voucherAmount,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    maxLines: 1,
                                    nextFocusNode: null,
                                    onSaved: () {},
                                    validator: (text) {
                                      double enterAmount = double.parse(text ?? '');
                                      if (text!.isEmpty) {
                                        return "enter_amount".tr;
                                      }
                                      else if(enterAmount>currentA){
                                        return "Amount_Insufficient".tr;
                                      }
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
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              'transfer_gift_card_amount'.tr,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            content: Text(
                              'do_you_wish_to_transfer'.tr,
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
                                  //await controller.transferGiftCardAmount(userModel!, v!.voucherCode!);
                                  String amount = controller.voucherGiftCardAmount.text;
                                  await controller.transferVoucherOwnership(userModel!, v!.idNr!, v!.currencyCode!);
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
                  // InkWell(
                  //   onTap: () {
                  //     // final isValid = _form.currentState!.validate();
                  //     // if (!isValid) {
                  //     //   return false;
                  //     // }
                  //     showDialog<String>(
                  //       context: context,
                  //       builder: (BuildContext context) => AlertDialog(
                  //         title: Text(
                  //           'transfer_gift_card_amount'.tr,
                  //           style: const TextStyle(
                  //               fontSize: 18,
                  //               fontWeight: FontWeight.bold,
                  //               color: Colors.black),
                  //         ),
                  //         content: Text(
                  //           'do_you_wish_to_transfer'.tr,
                  //           style: const TextStyle(fontSize: 14),
                  //         ),
                  //         actions: <Widget>[
                  //           TextButton(
                  //             onPressed: () => Get.back(),
                  //             child: Text(
                  //               'lcard_no'.tr,
                  //               style: const TextStyle(color: teal_700),
                  //             ),
                  //           ),
                  //           TextButton(
                  //             onPressed: () async {
                  //               await controller
                  //                   .transferGiftCardAmount(userModel!, v!.voucherCode!);
                  //             },
                  //             child: Text(
                  //               'lcard_yes'.tr,
                  //               style: const TextStyle(color: teal_700),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //     //Get.to(TransactionProcessing());
                  //   },
                  //   child: Container(
                  //     width: Get.width,
                  //     height: 55.h,
                  //     decoration: const BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.centerLeft,
                  //         end: Alignment.centerRight,
                  //         colors: [colorPrimaryDark, colorPrimary],
                  //       ),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         "transfer_voucher_amount_text".tr,
                  //         textAlign: TextAlign.center,
                  //         style: const TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.white),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          }),
    );
  }
}
