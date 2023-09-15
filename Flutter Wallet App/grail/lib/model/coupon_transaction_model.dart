class CouponTransactionModel {
  int id;
  String couponCode;
  String couponId;
  String validity;
  String redemptionLimit;
  String redeemPerWallet;
  String discountValue;
  String discountType;
  String minimumOrder;
  String title;
  bool blocked;
  String walletAddresses;
  String walletsLimitReached;
  String validtill;
  String createdAt;
  String updatedAt;
  String info;

  CouponTransactionModel({
    required this.id,
    required this.couponCode,
    required this.couponId,
    required this.validity,
    required this.redemptionLimit,
    required this.redeemPerWallet,
    required this.discountValue,
    required this.discountType,
    required this.minimumOrder,
    required this.title,
    required this.blocked,
    required this.walletAddresses,
    required this.walletsLimitReached,
    required this.validtill,
    required this.createdAt,
    required this.updatedAt,
    required this.info,
  });

  factory CouponTransactionModel.fromJson(Map<String, dynamic> json) => CouponTransactionModel(
    id: json["id"] ?? "",
    couponCode: json["couponCode"] ?? "",
    couponId: json["couponId"] ?? "",
    validity: json["validity"] ?? "",
    redemptionLimit: json["redemptionLimit"] ?? "",
    redeemPerWallet: json["redeemPerWallet"] ?? "",
    discountValue: json["discountValue"] ?? "",
    discountType: json["discountType"] ?? "",
    minimumOrder: json["minimumOrder"] ?? "",
    title: json["title"] ?? "",
    blocked: json["blocked"] ?? "",
    walletAddresses: json["walletAddresses"] ?? "",
    walletsLimitReached: json["walletsLimitReached"] ?? "",
    validtill: json["validtill"] ?? "",
    createdAt: json["createdAt"] ?? "",
    updatedAt: json["updatedAt"] ?? "",
    info: json["info"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "couponCode": couponCode,
    "couponId": couponId,
    "validity": validity,
    "redemptionLimit": redemptionLimit,
    "redeemPerWallet": redeemPerWallet,
    "discountValue": discountValue,
    "discountType": discountType,
    "minimumOrder": minimumOrder,
    "title": title,
    "blocked": blocked,
    "walletAddresses": walletAddresses,
    "walletsLimitReached": walletsLimitReached,
    "validtill": validtill,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "info": info,
  };
}