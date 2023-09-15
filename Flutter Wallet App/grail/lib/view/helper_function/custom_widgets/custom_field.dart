import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class CustomTextField extends StatelessWidget {
  String title;
  Function onSaved;
  FocusNode focusNode;
  FocusNode? nextFocusNode;
  bool isReadOnly;
  final bool isObscure;
  TextInputType keyboardType;
  FormFieldValidator<String> validator;
  Function(String newVal) onChange;
  TextEditingController controller;
  Widget suffixIcon;
  int? maxLines;
  CustomTextField(
      {required this.title,
      required this.controller,
      required this.focusNode,
      required this.keyboardType,
      this.maxLines,
      this.isObscure = false,
      required this.isReadOnly,
      required this.onChange,
      required this.nextFocusNode,
      required this.onSaved,
      required this.validator,
      required this.suffixIcon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: MyColors.giftCardDetailsClr,
      ),
      child: TextFormField(
        maxLines: maxLines ?? null,
        minLines: 1,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        cursorColor: MyColors.greenTealColor,
        obscureText: isObscure,
        //textAlign: TextAlign.center,
        readOnly: isReadOnly,
        // style: TextStyle(
        //     fontFamily: 'Avenir',
        //     color: Colors.black,
        //     fontSize: 20.sp,
        //     fontWeight: FontWeight.bold),

        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            suffixIconConstraints: BoxConstraints(
              maxHeight: 15.h,
            ),
            focusColor: MyColors.greenTealColor,
            hintText: title,
            // fillColor: MyColors.giftCardDetailsClr,
            isDense: true,
            // filled: true,
            // hintStyle: TextStyle(
            //   fontFamily: 'Avenir',
            //   color: MyColors.newAppPrimaryColor,
            //   fontWeight: FontWeight.normal,
            //   fontSize: 20.sp,
            // ),
            border: InputBorder.none),
        textInputAction:
            nextFocusNode == null ? TextInputAction.done : TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).unfocus();
          nextFocusNode == null
              ? FocusScope.of(context).unfocus()
              : FocusScope.of(context).requestFocus(nextFocusNode);
        },
        validator: (value) => validator(value),
        onSaved: (value) {},
        onChanged: (value) {
          onChange(value);
        },
      ),
    );
  }
}

class SufficIcon extends StatelessWidget {
  bool isObscure;
  GestureTapCallback onTap;
  SufficIcon({required this.isObscure, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Container(
          margin: EdgeInsets.only(left: 20.w),
          child: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 20,
            color: MyColors.redeemGiftCardBtnClr,
          ),
        ));
  }
}

TextStyle fieldTitleTextStyle = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: MyColors.newAppPrimaryColor);
