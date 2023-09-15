class UserModel {
  UserModel({
    this.message,
    this.id,
    this.phone,
    this.username,
    //this.walletAddress,
    this.countryCode,
    this.firstName,
    this.lastName,
    this.password,
    this.status,
    this.vouchersLength,
  });

  String? message;
  String? id;
  String? phone;
  String? username;
  //String? walletAddress;
  String? countryCode;
  String? firstName;
  String? lastName;
  String? password;
  String? status;
  String? vouchersLength = "0";
  //String vouchersAmount = "0";
  String couponsLength = "0";
  String? clientSalt;
  String? clientHash;
  String? emailAddress;
  String? oldClientHash;
  bool? otpInDashboard;
  String? balanceLength;
  String? balanceAmount;
  String? rewardBalanceAmount;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        message: json["message"] ?? "",
        id: json["id"] ?? "",
        phone: json["phone"] ?? "",
        username: json["username"] ?? "",
        //walletAddress: json["walletAddress"] ?? "",
        countryCode: json["countryCode"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        password: json["password"] ?? "",
        status: json["status"] ?? "",
        vouchersLength: json["vouchers_length"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "id": id,
        "phone": phone,
        "username": username,
        //"walletAddress": walletAddress,
        "countryCode": countryCode,
        "firstName": firstName,
        "lastName": lastName,
        "password": password,
        "status": status,
        "vouchers_length": vouchersLength,
        //"vouchers_amount": vouchersAmount,
        "coupons_length": couponsLength,
      };
}
