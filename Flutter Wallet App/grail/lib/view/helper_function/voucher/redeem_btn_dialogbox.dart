import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/view/helper_function/voucher/redeem_voucher_qrCode.dart';

import '../../../controller/home_screen_controller.dart';
import '../../../model/voucher_model.dart';
import '../colors.dart';


redeemBtnDialogBox(BuildContext context, Voucher v) {
  TextEditingController redeemMoneyController = TextEditingController();
  //var currentA = int.parse(v.currentAmount);
  double currentA = v.currentAmount.toDouble();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  return showDialog(context: context, builder: (BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (homeScreenController) {
        return AlertDialog(
          title: Text(
            "max_amount_to_redeem_text".tr + v.currentAmount.toString()+ " EUR",
            style: const TextStyle(fontSize: 16),
          ),
          content: Container(
            height: 75,
            width: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Form(
              key: _form,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: MyColors.giftCardDetailsClr,
                      ),
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        obscureText: false,
                        autofocus: false,
                        controller: redeemMoneyController,
                        cursorColor: MyColors.greenTealColor,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'(^\d*[\.\,]?\d{0,2})')),
                        ],
                        validator: (text) {
                          double enterAmount = double.parse(text ?? '');
                          if (text!.isEmpty) {
                            return "enter_amount".tr;
                          }
                          else if(enterAmount>currentA){
                            return "Amount_Insufficient".tr;
                          }
                          else if(enterAmount==0){
                            return "invalid_amount".tr;
                          }
                          return null;
                        },
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                            suffixIconConstraints: BoxConstraints(
                              maxHeight: 15.h,
                            ),
                            focusColor: MyColors.greenTealColor,
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 36,
                  width: 80,
                  decoration: BoxDecoration(
                    color: MyColors.redeemGiftCardBtnClr,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Center(
                    child: Text(
                      "Cancel".tr,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  final isValid = _form!.currentState!.validate();
                  if (!isValid) {
                    return;
                  }
                  _form.currentState!.save();
                  homeScreenController.amountToRedeem = redeemMoneyController.text;
                  redeemVoucherQrCode(context, v);
                },
                child: Container(
                  height: 36,
                  width: 80,
                  decoration: BoxDecoration(
                    color: MyColors.redeemGiftCardBtnClr,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Center(
                    child: Text(
                      "vouch_redeemshort".tr,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    );
  });
}