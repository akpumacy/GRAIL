
class StoreModel {
  String? username;
  String? name;
  String? email;
  String? accountType;
  bool? deactivated;
  String? cover;
  String? address;
  String? website;

  StoreModel({
    this.username,
    this.name,
    this.email,
    this.accountType,
    this.deactivated,
    this.cover,
    this.address,
    this.website,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    username: json["username"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    accountType: json["accountType"] ?? "",
    deactivated: json["deactivated"] ?? false,
    cover: json["cover"] ?? "",
    address: json["address"] ?? "",
    website: json["website"] ?? "",
  );
}
