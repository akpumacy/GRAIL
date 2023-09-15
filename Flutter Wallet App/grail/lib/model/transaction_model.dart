

import 'coupon_transaction_model.dart';

class TransactionModel {

  TransactionModel({
    this.id = 0,
    this.transactionhash = '',
    this.actionName = '',
    this.amount = '',
    this.createdAt = '',
    this.senderUsername = '',
    this.recvUsername = '',
    this.webshopName = '',
    this.webshopUsername = '',
    this.orderStatus = "",
    //required this.info
  });

  late int id;
  late String transactionhash;
  late String actionName;
  //String type;
  //String couponCode;
  //String voucherCodeFrom;
  //String voucherCodeTo;
  String amount;
  late String createdAt;
  //String updatedAt;
  //CouponTransactionModel? coupon;
  //String createdBy;
  //String updatedBy;
  String senderUsername;
  String recvUsername;
  String webshopName;
  String webshopUsername;
  //String webShopeSite;
  late String createdDate;
  String orderStatus;
  //TransactionInfo info;


  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"] ?? "",
        transactionhash: json["transactionhash"] ?? "",
        actionName: json["actionName"] ?? "",
        amount: json["amount"] == null ? "" : json["amount"].toString(),
        createdAt: json["createdAt"] ?? "",
        //info: json["transactionInfo"] ?? "",
        // updatedAt: json["updatedAt"],
        //coupon: json["coupon"] != null ? CouponTransactionModel.fromJson(json["coupon"]) : null,
        senderUsername: json["sender_username"] ?? "",
        recvUsername: json["recv_username"] ?? "",
        webshopName: json["webshopName"] ?? "",
        webshopUsername: json["webshopUsername"] ?? "",
        orderStatus : json["orderStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionhash": transactionhash,
        "actionName": actionName,
        "amount": amount,
        "createdAt": createdAt,
        "sender_username": senderUsername,
        "recv_username": recvUsername,
        "webshopName": webshopName,
        "webshopUsername": webshopUsername,
      };
}

class TransactionInfo {
  double reward;

  TransactionInfo({
    required this.reward,
  });

  factory TransactionInfo.fromJson(Map<String, dynamic> json) => TransactionInfo(
    reward: json["reward"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "reward": reward,
  };
}
