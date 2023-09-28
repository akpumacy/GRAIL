import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/view/helper_function/voucher/redeem_btn_dialogbox.dart';
import '../../../model/voucher_model.dart';
import '../colors.dart';
import '../custom_widgets/custom_image.dart';

class VoucherCard extends StatelessWidget {
  Voucher voucher;
  VoucherCard({required this.voucher, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime voucherValidity = DateTime.parse(voucher.updatedAt!);
    String validityDay = voucherValidity.day.toInt() < 10
        ? "0" + voucherValidity.day.toString()
        : voucherValidity.day.toString();
    String validityMonth = voucherValidity.month.toInt() < 10
        ? "0" + voucherValidity.month.toString()
        : voucherValidity.month.toString();
    return Container(
      height: 160.h,
      // width: 360,

      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 5.0,
                spreadRadius: 1.0,
                offset: Offset(0, 3))
          ]
          //color: Colors.greenAccent,
          ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 98.h,
              width: 180.w,
              padding: EdgeInsets.only(left: 18.w, top: 16.h),
              child: ClipRRect(
                // borderRadius: const BorderRadius.only(
                //     topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: CommonProfileImage(
                  imageUrl: voucher.webShopLogo!,
                ),
              ),
            ),
          ),

          //*********************** Price Cell ***********************

          Positioned(
            top: 10.h,
            right: 0,
            left: 0,
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 226, 222, 222),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )),
                child: Text(
                  containsDecimal("${voucher.currentAmount}") ?
                  voucher.currentAmount.toStringAsFixed(2) + " €" :
                  "${voucher.currentAmount} €",
                  style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            right: 10.w,
            left: 0,
            bottom: 30.h,
            child: Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  redeemBtnDialogBox(context, voucher);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                  decoration: BoxDecoration(
                      color: MyColors.newAppPrimaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "vouch_redeemshort".tr,
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),

          //*********************** First Container ***********************
          // if(voucher.webShopLogo != "")
          //   Positioned(
          //     top: 0,
          //     right: 0,
          //     left: 20.h,
          //     bottom: 20.h,
          //     child: Align(
          //       alignment: Alignment.bottomLeft,
          //       child: SizedBox(
          //         height: 32.h,
          //         width: 80.w,
          //         child: FittedBox(
          //           fit: BoxFit.fill,
          //           child:
          //           // Image.asset(
          //           //   "assets/grail_logo.png",
          //           // ),
          //           CommonProfileImage(
          //             imageUrl: voucher.webShopLogo!,
          //             needPlaceH: false,
          //           ),
          //         ),
          //         //  Image.asset(
          //         //   "assets/redimi_logo_v3.png",
          //         // ),
          //       ),
          //     ),
          //   ),
          // if(voucher.webShopLogo == "")
          //   Positioned(
          //     top: 0,
          //     right: 0,
          //     left: 20.h,
          //     bottom: 20.h,
          //     child: Align(
          //       alignment: Alignment.bottomLeft,
          //       child: SizedBox(
          //         height: 32.h,
          //         width: 80.w,
          //         child: FittedBox(
          //           fit: BoxFit.fill,
          //           child:
          //           Image.asset(
          //             "assets/grail_logo.png",
          //           ),
          //           // CommonProfileImage(
          //           //   imageUrl: voucher.webShopLogo!,
          //           //   needPlaceH: false,
          //           // ),
          //         ),
          //         //  Image.asset(
          //         //   "assets/redimi_logo_v3.png",
          //         // ),
          //       ),
          //     ),
          //   ),
          Positioned(
            top: 0,
            right: 0,
            left: 20.h,
            bottom: 20.h,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                height: 28.h,
                width: 74.w,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child:
                  Image.asset(
                    "assets/grail_logo.png",
                  ),
                  // CommonProfileImage(
                  //   imageUrl: voucher.webShopLogo!,
                  //   needPlaceH: false,
                  // ),
                ),
                //  Image.asset(
                //   "assets/redimi_logo_v3.png",
                // ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 10.h,
            left: 0,
            bottom: 5.h,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "${"updated_date".tr} $validityDay.$validityMonth.${voucherValidity.year}",
                style: TextStyle(
                    fontSize: 11.sp,
                    color: gray_1,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
