class CouponModel {
  CouponModel({
    this.couponCode,
    this.validity,
    this.redemptionLimit,
    this.redeemPerWallet,
    this.discountValue,
    this.discountType,
    this.minimumOrder,
    this.bulkAmount,
    this.bulkCondition,
    this.title,
    this.blocked,
    this.validtill,
    this.createdAt,
    this.webshopName,
    this.webshopUsername,
    this.webshopSite,
  });

  String? couponCode;
  String? validity;
  String? redemptionLimit;
  String? redeemPerWallet;
  String? discountValue;
  String? discountType;
  String? minimumOrder;
  String? bulkAmount;
  String? bulkCondition;
  String? title;
  bool? blocked;
  String? validtill;
  String? createdAt;
  String? webshopName;
  String? webshopUsername;
  String? webshopSite;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        couponCode: json["couponCode"] ?? "",
        validity: json["validity"] ?? "",
        redemptionLimit: json["redemptionLimit"] ?? "",
        redeemPerWallet: json["redeemPerWallet"] ?? "",
        discountValue: json["discountValue"] ?? "",
        discountType: json["discountType"] ?? "",
        minimumOrder: json["minimumOrder"] ?? "",
        bulkAmount: json["bulkAmount"] ?? "",
        bulkCondition: json["bulkCondition"] ?? "",
        title: json["title"] ?? "",
        blocked: json["blocked"] ?? "",
        validtill: json["validtill"] ?? "",
        createdAt: json["createdAt"] ?? "",
        webshopName: json["webshopName"] ?? "",
        webshopUsername: json["webshopUsername"] ?? "",
        webshopSite: json["webshopSite"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "couponCode": couponCode,
        "validity": validity,
        "redemptionLimit": redemptionLimit,
        "redeemPerWallet": redeemPerWallet,
        "discountValue": discountValue,
        "discountType": discountType,
        "minimumOrder": minimumOrder,
        "bulkAmount": bulkAmount,
        "bulkCondition": bulkCondition,
        "title": title,
        "blocked": blocked,
        "validtill": validtill,
        "createdAt": createdAt,
        "webshopName": webshopName,
        "webshopUsername": webshopUsername,
        "webshopSite": webshopSite,
      };
}
