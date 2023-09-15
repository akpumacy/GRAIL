import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/view/helper_function/coupon/redeem_coupon_qr_code.dart';

import '../../../model/coupon_model.dart';
import '../../../model/voucher_model.dart';
import '../colors.dart';

Widget couponCard(CouponModel couponModel, BuildContext context) {
  DateTime couponValidity = DateTime.parse(couponModel.validtill!);
  String validityDay = couponValidity.day.toInt() < 10 ? "0"+couponValidity.day.toString() : couponValidity.day.toString();
  String validityMonth = couponValidity.month.toInt() < 10 ? "0"+couponValidity.month.toString() : couponValidity.month.toString();
  return Container(
    margin: EdgeInsets.only(bottom: 20.h),
    height: 152.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      // color: Colors.greenAccent,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 4,
          blurRadius: 6,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      children: [
        //*********************** First Container ***********************
        Container(
          width: 80,
          height: 152.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              bottomLeft: Radius.circular(6),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset("assets/redimi_logo_v3.png"),
          ),
        ),

        //*********************** Second Container ***********************
        Container(
          width: 6,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colorPrimaryDark, colorPrimary],
            ),
          ),
        ),

        //*********************** Third Container ***********************
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
                height: 30.h,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [colorPrimaryDark, colorPrimary],
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      couponModel.webshopName!,
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                height: 122.h,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(6),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      child: Center(
                        child: Text(
                          couponModel.discountValue! +
                              "% " +
                              "discount_message".tr +
                              " " +
                              couponModel.minimumOrder! +
                              " EUR " +
                              "discount_purchase".tr,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 140.w),
                      child: Text(
                        "vouch_validuntil".tr + " " +
                            validityDay + "." +
                            validityMonth + "." +
                            couponValidity.year.toString(),
                        style: const TextStyle(
                            fontSize: 8,
                            color: gray_1,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6, right: 6, top: 6.h, bottom: 4.h),
                      child: InkWell(
                        onTap: () {
                          redeemCouponQrCode(context, couponModel);
                        },
                        child: Container(
                          height: 30.h,
                          width: 180.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: teal_700,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Center(
                              child: Text(
                                "vouch_redeemshort".tr,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
