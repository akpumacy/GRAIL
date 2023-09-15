import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';

import '../../controller/home_screen_controller.dart';
import 'colors.dart';

usernameQRCode(BuildContext context) {
  String qrMessage;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<HomeScreenController>(
            init: HomeScreenController(),
            builder: (homeScreenController) {
              qrMessage = homeScreenController.usernameQRCodeFunction();
              return AlertDialog(
                content: Container(
                  height: 240,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: QrImageView(
                          data: qrMessage,
                          version: QrVersions.auto,
                          size: 240.0,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 36,
                        width: 80,
                        decoration: BoxDecoration(
                          color: MyColors.redeemGiftCardBtnClr,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            "back_text".tr,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      });
}
