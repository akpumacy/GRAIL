import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../model/user_model.dart';
import '../view/helper_function/colors.dart';
import '../view/helper_function/custom_snackbar.dart';
import '../view/helper_function/transaction_processing_screen.dart';

class TransferGiftCardController extends GetxController {
  var transferVoucherOwnershipURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/balances/transferBalance");
  var transferVoucherAmountURL = Uri.parse(
      "https://pumacy-vm2.westeurope.cloudapp.azure.com/api/vouchers/transferVoucherAmount20");
  var transferVoucherAmountWithoutIDURL = Uri.parse(
      "https://pumacy-vm2.westeurope.cloudapp.azure.com/api/vouchers/transferVoucherAmountWithoutId");
  var refreshHashURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/changePassword");

  TextEditingController voucherOwnershipTransferTextController = TextEditingController();
  TextEditingController voucherRecipientCode = TextEditingController();
  TextEditingController voucherGiftCardAmount = TextEditingController();

  FocusNode userNameFocusNode = FocusNode();
  FocusNode receiverVoucherCodeFocusNode = FocusNode();
  FocusNode voucherAmount = FocusNode();

  bool transactionDone = false;

  //bool voucherRecipientScan = false;

  late SharedPreferences prefs;

  Future<void> transferGiftCardAmount(UserModel userModel, String voucherCode) async {
    Get.to(TransactionProcessing(transactionDone));
    await refreshHash(userModel);
    String senderUsername = userModel.username!;
    String uHash = userModel.clientHash!;
    String recUsername = voucherOwnershipTransferTextController.text;
    String recVoucherCode = voucherRecipientCode.text;
    String voucherAmount = voucherGiftCardAmount.text;

    if (recVoucherCode != "") {
      final response = await http.post(
        transferVoucherAmountURL,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(
          {
            "sender_username": senderUsername,
            "recv_username": recUsername,
            "mode": "username",
            "sender_hash": uHash,
            "sender_voucherCode": voucherCode,
            "recv_voucherCode": recVoucherCode,
            "amount": voucherAmount,
          },
        ),
      );
      if (response.statusCode == 200) {
        //Have to put some condition
        transactionDone = true;
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        kPrint("Transfer Ownership successful");

        customSnackBar("success_text".tr, "giftCard_Amount_transfer_success".tr,
            colorPrimary);
      } else {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
        kPrint("Transfer Ownership Error");
        kPrint(response.body);
      }
    } else {
      final response = await http.post(
        transferVoucherAmountWithoutIDURL,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(
          {
            "sender_username": senderUsername,
            "recv_username": recUsername,
            "mode": "username",
            "sender_hash": uHash,
            "sender_voucherCode": voucherCode,
            "amount": voucherAmount,
          },
        ),
      );
      if (response.statusCode == 200) {
        //Get.to(const TransactionProcessing());
        transactionDone = true;
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        kPrint("Transfer Amount successful");
        PartialTransfer ownerShip = PartialTransfer(
            amount: double.parse(voucherAmount), voucherCode: voucherCode);
        eventBus.fire(ownerShip);
        customSnackBar("success_text".tr, "giftCard_Amount_transfer_success".tr,
            greenProcessing);
      } else {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
        kPrint("Transfer Amount Error");
        kPrint(response.body);
      }
    }
  }

  Future<void> transferVoucherOwnership(UserModel userModel,String balanceId,  String currencyCode) async {
    Get.to(TransactionProcessing(transactionDone));
    await refreshHash(userModel);
    String senderUsername = userModel.username!;
    String uHash = userModel.clientHash!;
    String recUsername = voucherOwnershipTransferTextController.text;
    String amountBalance = voucherGiftCardAmount.text.toString();

    double amount = double.parse(amountBalance);

    final response = await http.post(
      transferVoucherOwnershipURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "sender_username": senderUsername,
          "sender_hash": uHash,
          "receiver_username": recUsername,
          "token": currencyCode,
          "amount": amount
        },
      ),
    );
    if (response.statusCode == 200) {
      // OwnershipTransfer ownerShip = OwnershipTransfer(amount: amount, voucherCode: balanceId);
      // eventBus.fire(ownerShip);
      PartialTransfer ownerShip = PartialTransfer(amount: amount, voucherCode: balanceId);
      eventBus.fire(ownerShip);
      transactionDone = true;
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      kPrint("Transfer Ownership successful");
      customSnackBar("success_text".tr,
          "giftCard_Ownership_transfer_success".tr, greenProcessing);
    } else {
      Get.back();
      Get.back();
      Get.back();
      Get.back();
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
      print("Transfer Ownership Error");
      print(response.body);
    }
  }

  Future<void> refreshHash(UserModel userModel) async {
    prefs = await SharedPreferences.getInstance();
    String oldClientHash = userModel.clientHash!;
    //String refreshClientSalt = DBCrypt().gensaltWithRounds(10);
    String refreshClientSalt =
        "\$2a" + DBCrypt().gensaltWithRounds(10).substring(3);
    String refreshClientHash =
        DBCrypt().hashpw(userModel.password!, refreshClientSalt);
    final response = await http.post(
      refreshHashURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "username": userModel.username,
          "old_client_hash": oldClientHash,
          "new_client_salt": refreshClientSalt,
          "new_client_hash": refreshClientHash
        },
      ),
    );

    if (response.statusCode == 200) {
      userModel.clientSalt = refreshClientSalt;
      userModel.clientHash = refreshClientHash;
      prefs.setString('clientHash', refreshClientSalt);
      prefs.setString('clientSalt', refreshClientHash);
      //goto_vouchers();
      kPrint("Refresh Hash and Salt successfully");
      kPrint(userModel.clientHash);
    } else {
      kPrint("Refreshing Hashed Failed");
    }
  }
}

class OwnershipTransfer {
  double amount;
  String voucherCode;
  OwnershipTransfer({required this.amount, required this.voucherCode});
}

class PartialTransfer {
  double amount;
  String voucherCode;
  PartialTransfer({required this.amount, required this.voucherCode});
}

enum TransactionEvents { ownershipTransfer }
