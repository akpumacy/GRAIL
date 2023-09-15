

import 'package:grail/model/voucher_model.dart';

class VoucherResponse {
  int? statusCode;
  List<Voucher>? vouchers;
  String? totalVoucherBalance;
  String? totalVouchers;

  VoucherResponse({
    this.statusCode,
    this.vouchers,
    this.totalVoucherBalance,
    this.totalVouchers,
  });

  factory VoucherResponse.fromJson(Map<String, dynamic> json) {
    var list = json['vouchers'] as List;
    List<Voucher> vouchersList = list.map((i) => Voucher.fromJson(i)).toList();

    return VoucherResponse(
      statusCode: json['statusCode'] ?? "",
      vouchers: vouchersList,
      totalVoucherBalance: json['totalVoucherBalance'] ?? "",
      totalVouchers: json['totalVouchers'] ?? "",
    );
  }
}
