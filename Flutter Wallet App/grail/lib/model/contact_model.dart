class ContactModel {
  ContactModel({
    this.phone,
    this.username,
    this.name,
  });

  String? phone;
  String? username;
  String? name;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        phone: json["phone"] ?? "",
        username: json["username"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "username": username,
        "name": name,
      };
}
