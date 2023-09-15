import 'dart:convert';

RegisterUserWallet registerUserWalletFromJson(String str) =>
    RegisterUserWallet.fromJson(json.decode(str));

String registerUserWalletToJson(RegisterUserWallet data) =>
    json.encode(data.toJson());

class RegisterUserWallet {
  RegisterUserWallet({
    required this.sender,
    required this.senderEncrypted,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.customerType,
  });

  String sender = '00';
  String senderEncrypted = '00';
  String firstname = '00';
  String lastname = '00';
  String email = '00';
  String phone = '00';
  String customerType = 'Private';

  factory RegisterUserWallet.fromJson(Map<String, dynamic> json) =>
      RegisterUserWallet(
        sender: json["sender"],
        senderEncrypted: json["senderEncrypted"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        phone: json["phone"],
        customerType: json["customerType"],
      );

  Map<String, dynamic> toJson() => {
        "sender": sender,
        "senderEncrypted": senderEncrypted,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "customerType": customerType,
      };
}
