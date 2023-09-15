import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../model/thired_party_card_model.dart';

class GiftCardCell extends StatelessWidget {
  GiftAndLoyaltyCard giftAndLoyaltyCard;
  String? onChangeColor;
  GiftCardCell(
      {required this.giftAndLoyaltyCard, this.onChangeColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 28.w, right: 28.w),
      height: 160.h,
      decoration: BoxDecoration(
          color: Color(int.parse(onChangeColor ?? giftAndLoyaltyCard.color)),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              giftAndLoyaltyCard.cardName,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 30.sp),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 8.w, 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  giftAndLoyaltyCard.date,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "show".tr,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
