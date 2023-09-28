import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../model/transaction_model.dart';
import '../colors.dart';
import '../qr_code_generator.dart';

class TransactionDetailsScreen extends StatelessWidget {
  TransactionModel? transactionModel;
  TransactionDetailsScreen(TransactionModel t, {Key? key}) : super(key: key) {
    transactionModel = t;
  }

  @override
  Widget build(BuildContext context) {

    String giftCardText = "";
    if (transactionModel!.orderStatus == "redeem") {
      giftCardText = "prog_Redeemed".tr;
    }
    if (transactionModel!.orderStatus == "outgoingComplete") {
      giftCardText = "prog_OwnershipTransferred".tr;
    }
    if (transactionModel!.orderStatus == "incomingComplete") {
      giftCardText = "prog_OwnershipReceived".tr;
    }
    if (transactionModel!.orderStatus == "outgoingTransfer") {
      giftCardText = "prog_AmountTransferred".tr;
    }
    if (transactionModel!.orderStatus == "incomingTransfer") {
      giftCardText = "prog_AmountReceived".tr;
    }
    if (transactionModel!.orderStatus == "purchase") {
      giftCardText = "prog_purchased".tr;
    }
    if (transactionModel!.orderStatus == "convertRewards") {
      giftCardText = "convert_rewards".tr;
    }

    String giftCardAmountSign = "";
    if(transactionModel!.orderStatus == "redeem" || transactionModel!.orderStatus == "outgoingTransfer"){
      giftCardAmountSign = "-${transactionModel!.amount}";
    }
    if(transactionModel!.orderStatus == "incomingTransfer" || transactionModel!.orderStatus == "purchase" || transactionModel!.orderStatus == "convertRewards"){
      giftCardAmountSign = "+${transactionModel!.amount}";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: Get.height,
        width: Get.width,
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              width: Get.width,
            ),
            //********************Heading & back button*************************
            SizedBox(
              width: Get.width,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "transdata_header".tr,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const SizedBox(
                        width: 24,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //********************Transaction Hash*************************
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 12),
              child: SizedBox(
                width: Get.width,
                child: Text(
                  "transdata_hash".tr,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorPrimaryDark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 12, left: 12),
              child: SizedBox(
                width: Get.width,
                child: SelectableText(
                  transactionModel!.transactionhash,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12, bottom: 12),
              child: SizedBox(
                width: Get.width,
                child: InkWell(
                  onTap: () {
                    QRCodeGenerator(context, transactionModel!.transactionhash);
                  },
                  child: Text(
                    "vouch_codeinstr".tr,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
              ),
            ),
            //*****************Transaction Action******************************
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: SizedBox(
                width: Get.width,
                child: Text(
                  "transdata_action".tr,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorPrimaryDark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12, bottom: 12),
              child: SizedBox(
                width: Get.width,
                child: Text( giftCardText,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: SizedBox(
                width: Get.width,
                child: Text(
                  "transaction_amount".tr,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorPrimaryDark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12, bottom: 12),
              child: SizedBox(
                width: Get.width,
                child: Text( giftCardAmountSign,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),

            const Divider(
              height: 1,
              color: Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: SizedBox(
                width: Get.width,
                child: Text(
                  "transdata_sendwall".tr,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colorPrimaryDark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 12, left: 12),
              child: SizedBox(
                width: Get.width,
                child: SelectableText(
                  transactionModel!.senderUsername,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
            ),

            //***************** Transaction Recipient ******************************
            if(transactionModel?.orderStatus != "create" && transactionModel?.orderStatus != "redeem")
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: SizedBox(
                      width: Get.width,
                      child: Text(
                        "transdata_rcvwall".tr,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: colorPrimaryDark),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 6, right: 12, left: 12, bottom: 12),
                    child: SizedBox(
                      width: Get.width,
                      child: SelectableText(
                        transactionModel!.recvUsername,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6, left: 12),
            //   child: SizedBox(
            //     width: Get.width,
            //     child: Text(
            //       "transdata_sendwall".tr,
            //       textAlign: TextAlign.left,
            //       style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: colorPrimaryDark),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6, right: 12, left: 12),
            //   child: SizedBox(
            //     width: Get.width,
            //     child: SelectableText(
            //       transactionModel!.senderUsername,
            //       textAlign: TextAlign.right,
            //       style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6, left: 12),
            //   child: SizedBox(
            //     width: Get.width,
            //     child: Text(
            //       "transdata_rcvwall".tr,
            //       textAlign: TextAlign.left,
            //       style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: colorPrimaryDark),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       top: 6, right: 12, left: 12, bottom: 12),
            //   child: SizedBox(
            //     width: Get.width,
            //     child: SelectableText(
            //       transactionModel!.recvUsername,
            //       textAlign: TextAlign.right,
            //       style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black),
            //     ),
            //   ),
            // ),
            //
            // const Divider(
            //   height: 1,
            //   color: Colors.grey,
            // ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 6, left: 12),
            //   child: SizedBox(
            //     width: Get.width,
            //     child: Text(
            //       "transdata_idfrom".tr,
            //       textAlign: TextAlign.left,
            //       style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: colorPrimaryDark),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       top: 6, right: 12, left: 12, bottom: 12),
            //   child: SizedBox(
            //     width: Get.width,
            //     child: SelectableText(
            //       transactionModel!.voucherCodeFrom,
            //       textAlign: TextAlign.right,
            //       style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w500,
            //           color: Colors.black),
            //     ),
            //   ),
            // ),
            //if(transactionModel?.orderStatus == "incomingPartial" || transactionModel?.orderStatus == "outgoingPartial")
            //   Column(
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.only(top: 6, left: 12),
            //         child: SizedBox(
            //           width: Get.width,
            //           child: Text(
            //             "transdata_idto".tr,
            //             textAlign: TextAlign.left,
            //             style: const TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //                 color: colorPrimaryDark),
            //           ),
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.only(
            //             top: 6, right: 12, left: 12, bottom: 12),
            //         child: SizedBox(
            //           width: Get.width,
            //           child: SelectableText(
            //             transactionModel!.voucherCodeTo,
            //             textAlign: TextAlign.right,
            //             style: const TextStyle(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w500,
            //                 color: Colors.black),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),

            // const Divider(
            //   height: 1,
            //   color: Colors.grey,
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 12),
                  child: SizedBox(
                    child: Text(
                      "date_text".tr,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorPrimaryDark),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12, right: 12, left: 12, bottom: 12),
                  child: SizedBox(
                    child: Text(
                      transactionModel!.createdAt,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
