

import 'coupon_model.dart';

class CouponResponseModel {
  CouponResponseModel({this.statusCode, this.totalCoupons, this.coupons});

  int? statusCode;
  String? totalCoupons;
  List<CouponModel>? coupons;

  factory CouponResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['coupons'] as List;
    List<CouponModel> couponsList =
        list.map((i) => CouponModel.fromJson(i)).toList();

    return CouponResponseModel(
        statusCode: json["statusCode"],
        totalCoupons: json["totalCoupons"],
        coupons: couponsList);
  }

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "totalCoupons": totalCoupons,
      };
}
