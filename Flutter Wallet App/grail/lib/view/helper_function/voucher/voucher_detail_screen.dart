import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grail/view/helper_function/voucher/redeem_btn_dialogbox.dart';
import 'package:grail/view/helper_function/voucher/transfer_voucher_amount.dart';
import 'package:grail/view/helper_function/voucher/transfer_voucher_ownership_view.dart';
import '../../../controller/home_screen_controller.dart';
import '../../../model/user_model.dart';
import '../../../model/voucher_model.dart';
import '../colors.dart';
import '../custom_snackbar.dart';
import '../qr_code_generator.dart';

class VoucherDetailScreen extends StatelessWidget {
  VoucherDetailScreen(UserModel user, Voucher v, {Key? key}) : super(key: key) {
    voucher = v;
    userModel = user;
  }
  Voucher? voucher;
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    DateTime voucherValidity = DateTime.parse(voucher!.updatedAt!);
    String validityDay = voucherValidity.day.toInt() < 10
        ? "0" + voucherValidity.day.toString()
        : voucherValidity.day.toString();
    String validityMonth = voucherValidity.month.toInt() < 10
        ? "0" + voucherValidity.month.toString()
        : voucherValidity.month.toString();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80.h,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 102.h),
                width: Get.width-4,
                decoration: BoxDecoration(
                    color: MyColors.giftCardDetailsClr,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24)),
                  border: Border.all(color: colorGiftCardDetails, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.only(top: 15.h, left: 20),
                        //   child: Text(
                        //     "balance_code".tr,
                        //     style: TextStyle(
                        //         fontSize: 16.sp,
                        //         fontWeight: FontWeight.w500,
                        //         color: colorGiftCardDetails),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.only(top: 20.h, right: 16, left: 16),
                        //   child: SizedBox(
                        //     width: Get.width,
                        //     child: SelectableText(
                        //       voucher!.idNr!,
                        //       textAlign: TextAlign.right,
                        //       style: TextStyle(
                        //           fontSize: 14.sp,
                        //           fontWeight: FontWeight.w400,
                        //           color: colorGiftCardDetails),
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //       top: 10, right: 16, bottom: 12),
                        //   child: SizedBox(
                        //     width: Get.width,
                        //     child: InkWell(
                        //       onTap: () {
                        //         Clipboard.setData(ClipboardData(text: voucher!.idNr!))
                        //         .then((value) { //only if ->
                        //           customSnackBar("success_text".tr, "settings_copied".tr, Colors.green);
                        //         });
                        //         QRCodeGenerator(context, voucher!.idNr!);
                        //       },
                        //       child: Text(
                        //         "vouch_codeinstr".tr,
                        //         textAlign: TextAlign.right,
                        //         style: TextStyle(
                        //             fontSize: 16.sp,
                        //             fontWeight: FontWeight.w500,
                        //             color: colorGiftCardDetails),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 12, right: 12),
                    //   child: Divider(
                    //     height: 1,
                    //     color: colorGiftCardDetails,
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      width: Get.width,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "credit".tr,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: colorGiftCardDetails),
                          ),
                          Expanded(
                            child: Text(
                              voucher!.currentAmount.toString() + " €",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colorGiftCardDetails),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Divider(
                        height: 1,
                        color: colorGiftCardDetails,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      width: Get.width,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "currency_code".tr,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: colorGiftCardDetails),
                          ),
                          Expanded(
                            child: Text(
                              voucher!.currencyCode!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.sp, color: colorGiftCardDetails
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Divider(
                        height: 1,
                        color: colorGiftCardDetails,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      width: Get.width,
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "updated_date".tr,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: colorGiftCardDetails),
                          ),
                          Expanded(
                            child: Text(
                              "$validityDay.$validityMonth.${voucherValidity.year}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 16.sp, color: colorGiftCardDetails, fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.only(left: 12, right: 12),
                    //   child: Divider(
                    //     height: 1,
                    //     color: colorGiftCardDetails,
                    //   ),
                    // ),
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 15),
                    //   width: Get.width,
                    //   child: Row(
                    //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(
                    //         "vouch_valid".tr,
                    //         style: TextStyle(
                    //             fontSize: 16.sp,
                    //             fontWeight: FontWeight.w500,
                    //             color: colorGiftCardDetails),
                    //       ),
                    //       Expanded(
                    //         child: Text(
                    //           "",
                    //           textAlign: TextAlign.right,
                    //           style: TextStyle(
                    //               fontSize: 16.sp,
                    //               color: colorGiftCardDetails,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Divider(
                        height: 1,
                        color: colorGiftCardDetails,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      width: Get.width,
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "vouch_shopname".tr,
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: colorGiftCardDetails),
                          ),
                          Expanded(
                            child: Text(
                              voucher!.webShopName!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: colorGiftCardDetails,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 160.h,),
                    // Center(
                    //   child: InkWell(
                    //     onTap: () {
                    //       Get.to(TransferVoucherOwnershipView(userModel!, voucher!));
                    //     },
                    //     child: Container(
                    //       height: 50.h,
                    //       width: 300.w,
                    //       decoration: BoxDecoration(
                    //         color: MyColors.transferGiftCardBtnColor,
                    //         borderRadius: BorderRadius.circular(32),
                    //         //border: Border.all(color: colorGiftCardDetails, width: 1),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           "transfer_ownership_text".tr,
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //               fontSize: 16.sp,
                    //               fontWeight: FontWeight.w500,
                    //               color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //SizedBox(height: 10.h,),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.to(TransferVoucherAmountView(userModel!, voucher!));
                        },
                        child: Container(
                          height: 50.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: MyColors.transferPartialAmountBtnClr,
                            borderRadius: BorderRadius.circular(32),
                            //border: Border.all(color: colorGiftCardDetails, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "transfer_voucher_amount_text".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Center(
                      child: InkWell(
                        onTap: () {
                          redeemBtnDialogBox(context, voucher!);
                        },
                        child: Container(
                          height: 50.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: MyColors.redeemGiftCardBtnClr,
                            borderRadius: BorderRadius.circular(32),
                            //border: Border.all(color: colorGiftCardDetails, width: 1),
                          ),
                          child: Center(
                            child: Text(
                              "vouch_redeem".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(
          //   width: Get.width,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
                // InkWell(
                //   onTap: () {
                //     Get.to(TransferVoucherOwnershipView(voucher!));
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
                //         "transfer_ownership_text".tr,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 18.sp,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                // const Divider(
                //   color: Colors.white,
                //   height: 2,
                // ),
                // InkWell(
                //   onTap: () {
                //     Get.to(TransferVoucherAmountView(voucher!));
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
                //         style: TextStyle(
                //             fontSize: 18.sp,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                // const Divider(
                //   color: Colors.white,
                //   height: 2,
                // ),
                // InkWell(
                //   onTap: () {
                //     redeemBtnDialogBox(context, voucher!);
                //   },
                //   child: Container(
                //     height: 55.h,
                //     width: Get.width,
                //     decoration: const BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //         colors: [colorPrimaryDark, colorPrimary],
                //       ),
                //     ),
                //     child: Center(
                //       child: Text(
                //         "vouch_redeem".tr,
                //         textAlign: TextAlign.center,
                //         style: TextStyle(
                //             fontSize: 18.sp,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.white),
                //       ),
                //     ),
                 // ),
                //),
              //],
            //),
          //),
        ],
      ),
    );
  }
}
