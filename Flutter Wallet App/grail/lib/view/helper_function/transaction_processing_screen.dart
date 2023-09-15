import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/transfer_giftcard_controller.dart';
class TransactionProcessing extends StatelessWidget {
  bool? transactionDone;

  TransactionProcessing(bool tDone, {Key? key}) : super(key: key) {
    transactionDone = tDone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: GetBuilder<TransferGiftCardController>(
          init: TransferGiftCardController(),
          builder: (controller) {
            return Center(
              child: InkWell(
                onTap: () {
                  if (transactionDone == true) {
                    Get.back();
                    Get.back();
                    Get.back();
                    Get.back();
                  }
                },
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/tickmark2.png',
                            height: 250.0,
                            width: 250.0,
                          ),
                          const SizedBox(
                            height: 180.0,
                            width: 180.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 8,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        'message_processing'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                      // const SizedBox(height: 80.0),
                      // Text(
                      //   'message_clickanywhere'.tr,
                      //   style: const TextStyle(
                      //     fontSize: 17.0,
                      //     fontWeight: FontWeight.bold,
                      //     fontFamily: 'serif-monospace',
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
