// import 'dart:convert';
//
// import 'package:dbcrypt/dbcrypt.dart';
// import 'package:get/get.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:http/http.dart' as http;
// import 'package:redimi/model/user_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../main.dart';
// import '../model/contact_model.dart';
// import '../view/helper_function/colors.dart';
// import '../view/helper_function/custom_snackbar.dart';
//
// class ContactsController extends GetxController {
//
//   List<String> phoneNumbers = [];
//   List<ContactModel> contactsList = [];
//   List<dynamic> contList = [];
//   late SharedPreferences prefs;
//   var getContactsURL = Uri.parse("https://pumacy-vm2.westeurope.cloudapp.azure.com/api/accounts/getUsernameFromPhone");
//   var refreshHashURL = Uri.parse("https://pumacy-vm2.westeurope.cloudapp.azure.com/api/accounts/changePassword");
//
//   //**************** Function to Get Contacts from server **********************
//   Future<void> getContactsFromServer(UserModel userModel) async {
//     await refreshHash(userModel);
//     List<Contact> contacts =
//     await ContactsService.getContacts(withThumbnails: false);
//     phoneNumbers = contacts
//         .where((contact) => contact.phones!.isNotEmpty)
//         .map((contact) =>
//         contact.phones!.first.value!.replaceAll(RegExp(r'[^\w\s]+'), '00'))
//         .toList();
//
//     String uName = userModel.username!;
//     String uHash = userModel.clientHash!;
//     kPrint(phoneNumbers);
//     final response = await http.post(
//       getContactsURL,
//       headers: <String, String>{'Content-Type': 'application/json'},
//       body: json.encode(
//         {
//           "username": uName,
//           "client_hash": uHash,
//           "contacts_list": phoneNumbers,
//         },
//       ),
//     );
//     if (response.statusCode == 200) {
//       final contactsObject = json.decode(response.body);
//       var jsonArray = contactsObject['message'];
//       contactsList.clear();
//       for (var json in jsonArray.values) {
//         final c = ContactModel.fromJson(json);
//         contactsList.add(c);
//       }
//       kPrint(contactsList.length);
//       kPrint("You get Contacts Successfully");
//       //update();
//     } else {
//       customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
//       kPrint("Cant get contacts");
//       kPrint(response.body);
//     }
//   }
//
//
//   Future<void> refreshHash(UserModel userModel) async {
//     prefs = await SharedPreferences.getInstance();
//     String oldClientHash = userModel.clientHash!;
//     String refreshClientSalt =
//         "\$2a" + DBCrypt().gensaltWithRounds(10).substring(3);
//     String refreshClientHash =
//     DBCrypt().hashpw(userModel.password!, refreshClientSalt);
//     final response = await http.post(
//       refreshHashURL,
//       headers: <String, String>{'Content-Type': 'application/json'},
//       body: json.encode(
//         {
//           "username": userModel.username,
//           "old_client_hash": oldClientHash,
//           "new_client_salt": refreshClientSalt,
//           "new_client_hash": refreshClientHash
//         },
//       ),
//     );
//     prefs.setString('clientHash', refreshClientSalt);
//     prefs.setString('clientSalt', refreshClientHash);
//     kPrint("${response.statusCode}");
//
//     if (response.statusCode == 200) {
//       userModel.clientSalt = refreshClientSalt;
//       userModel.clientHash = refreshClientHash;
//       prefs.setString('clientHash', refreshClientSalt);
//       prefs.setString('clientSalt', refreshClientHash);
//       //goto_vouchers();
//       kPrint("Refresh Hash and Salt successfully");
//       kPrint(userModel.clientHash);
//     } else {
//       kPrint("Refreshing Hashed Failed");
//     }
//   }
// }
