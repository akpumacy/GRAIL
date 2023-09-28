import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import '../../../controller/home_screen_controller.dart';
import '../../../model/voucher_model.dart';
import '../colors.dart';

redeemVoucherQrCode(BuildContext context, Voucher v) {
  String qrMessage;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<HomeScreenController>(
            init: HomeScreenController(),
            builder: (homeScreenController) {
              qrMessage = homeScreenController.generateVoucherRedeemQRCode(v);
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
                        height: 20,
                        width: 60,
                        color: Colors.transparent,
                        child: Text(
                          "back_text".tr,
                          style: const TextStyle(
                              fontSize: 14, color: colorPrimary),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      });
}