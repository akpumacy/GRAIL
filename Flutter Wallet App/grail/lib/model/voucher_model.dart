class Voucher {
  String? idNr;
  String? currencyCode;
  dynamic currentAmount;
  String? updatedAt;
  String? webShopName;
  String? webShopUsername;
  String? webShopSite;
  String? webShopLogo;

  Voucher({
    this.currentAmount,
    this.webShopName,
    this.webShopUsername,
    this.webShopSite,
    this.idNr,
    this.currencyCode,
    this.updatedAt,
    this.webShopLogo
  });

  factory Voucher.fromJson(json) {
    return Voucher(
      currentAmount: json['amount'] ?? "",
      webShopName: json['webshopName'] ?? "",
      webShopUsername: json['webshopUsername'] ?? "",
      webShopSite: json['webshopSite'] ?? "",
      idNr: json['idNr'] ?? "",
      currencyCode: json["currencyCode"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      webShopLogo: json["webshopLogo"] ?? ""
    );
  }
}
