import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextButton extends StatelessWidget {
  Color buttonColor;
  String butttonTitle;
  Function OnTap;
  double buttonWidth;

  CustomTextButton(
      {required this.buttonColor,
      required this.butttonTitle,
      required this.OnTap,
      this.buttonWidth = 196,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OnTap(),
      child: Container(
        // height: 50.h,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        width: buttonWidth.w,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30.w),
        ),
        child: Center(
          child: Text(
            butttonTitle,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20.sp),
          ),
        ),
      ),
    );
  }
}
