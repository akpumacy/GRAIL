import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/contact_model.dart';
import 'colors.dart';

Widget contactCard(ContactModel contactModel, BuildContext context) {
  return Container(
    height: 85.h,
    width: 360.w,
    decoration: BoxDecoration(
      color: purple_200,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Container(
            width: 340.w,
            child: Text(
              contactModel.name!,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24.sp, color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contactModel.username!,
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
              Text(
                contactModel.phone!,
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
