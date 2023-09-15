import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/home_screen_controller.dart';
import 'custom_widgets/custom_field.dart';

Widget faceIdTile(
    {required String title,
      required String leading,
      required HomeScreenController controller}) {
  return ListTile(
    title: Text(
      title,
      style: fieldTitleTextStyle.copyWith(fontSize: 14.sp),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    leading: Image.asset(
      leading,
      scale: 4,
    ),
    minLeadingWidth: 20.w,
    trailing: Obx(() {
      return CupertinoSwitch(
        activeColor: CupertinoColors.activeGreen,
        trackColor: CupertinoColors.inactiveGray,
        thumbColor: CupertinoColors.white,
        value: controller.isAvailFingerPrint.value,
        onChanged: (value) async {

        },
      );
    }),
  );
}