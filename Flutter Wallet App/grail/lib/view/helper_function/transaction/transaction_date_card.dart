import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../controller/home_screen_controller.dart';
import '../colors.dart';

Widget transactionDateCard(String date){
  return GetBuilder(
    init: HomeScreenController(),
    builder: (controller) {
      return Container(
        height: 50,
        color: Colors.transparent,
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(date, style: TextStyle(
              color: MyColors.newAppPrimaryColor, fontWeight: FontWeight.w600, fontSize: 16.sp
            ),),

            // Text("EUR", style: TextStyle(
            //     color: colorGiftCardDetails, fontWeight: FontWeight.w600, fontSize: 22.sp
            // ),),
          ],
        ),
      );
    }
  );
}