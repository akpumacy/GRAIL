
class StoreModel {
  int? id;
  String? username;
  String? name;
  String? email;
  String? accountType;
  bool? deactivated;
  String? cover;
  String? address;
  String? website;

  StoreModel({
    this.id,
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
    id: json["id"] ?? "",
    username: json["username"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    accountType: json["accountType"] ?? "",
    deactivated: json["deactivated"] ?? "",
    cover: json["cover"] ?? "",
    address: json["address"] ?? "",
    website: json["website"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "name": name,
    "email": email,
    "accountType": accountType,
    "deactivated": deactivated,
    "cover": cover,
    "address": address,
    "website": website,
  };
}
