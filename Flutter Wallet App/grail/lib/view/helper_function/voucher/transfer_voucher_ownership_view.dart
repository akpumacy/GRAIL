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

class TransferVoucherOwnershipView extends StatelessWidget {
  Voucher? v;
  UserModel? userModel;

  TransferVoucherOwnershipView(UserModel user, Voucher voucher, {Key? key})
      : super(key: key) {
    v = voucher;
    userModel = user;
  }

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
          "transown_header".tr,
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
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
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
                        )),
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
                                  //await controller.transferVoucherOwnership(userModel!, v!.idNr!, v!.currencyCode!);
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
                            "transfer_ownership_text".tr,
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
