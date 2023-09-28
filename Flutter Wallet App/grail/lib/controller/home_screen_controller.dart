import 'dart:convert';
import 'package:collection/collection.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../model/contact_model.dart';
import '../model/coupon_model.dart';
import '../model/coupon_response_model.dart';
import '../model/store_model.dart';
import '../model/transaction_model.dart';
import '../model/user_model.dart';
import '../model/voucherResponse_model.dart';
import '../model/voucher_model.dart';
import '../view/helper_function/colors.dart';
import '../view/helper_function/custom_snackbar.dart';
import '../view/helper_function/custom_widgets/custom_progress_dialog.dart';
import '../view/helper_function/transaction_processing_screen.dart';
import '../view/home_screen_nav/coupons_screens/coupons_screen.dart';
import '../view/home_screen_nav/gift_cards/gift_cards_screen.dart';
import '../view/home_screen_nav/overview_screen.dart';
import '../view/home_screen_nav/transactions_screen.dart';
import '../view/login_screen.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get to => Get.put(HomeScreenController());

  final currentIndex = 0.obs;

  //****************************** URL *****************************************
  var getVoucherURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/balances/getBalances");
  var getTransactionURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/transactions/getTransactions");
  var updateProfileURL = Uri.parse(
      "https://pumacy-vm2.westeurope.cloudapp.azure.com/api/accounts/updateCustomerInfo");
  var refreshHashURL = Uri.parse(
      "https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/changePassword");

  // var getCouponsURL = Uri.parse("https://pumacy-vm2.westeurope.cloudapp.azure.com/api/coupons/getCoupons20");

  var getContactsURL = Uri.parse("https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/getUsernameFromPhone");
  var deleteAccountURL = Uri.parse("https://pumacy-vm2.westeurope.cloudapp.azure.com/api/accounts/deleteAccount");
  var changePasswordURL = Uri.parse("https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/accounts/changePassword");
  var convertRewardURL = Uri.parse("https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/balances/convertRewards");
  var getStoresURL = Uri.parse("https://pumacy-vm4.germanywestcentral.cloudapp.azure.com/api/stores/getStores");

  UserModel userModel = UserModel();
  VoucherResponse voucherResponse = VoucherResponse();
  RxList<Voucher> giftCardsList = <Voucher>[].obs;
  RxList<Voucher> filterGiftCardsList = <Voucher>[].obs;
  RxList<TransactionModel> transactionList = <TransactionModel>[].obs;
  String amountToRedeem = "";
  bool isSwitched = false;
  Set seenValuesTransaction = {};
  List<String> seenTransactionDate = [];
  RxMap<String, dynamic> groupedTransactions = <String, dynamic>{}.obs;
  CouponResponseModel couponResponse = CouponResponseModel();
  RxList<CouponModel> couponList = <CouponModel>[].obs;
  RxList<CouponModel> filterCouponList = <CouponModel>[].obs;
  RxString totaGiftCardAmount = ''.obs;

  List<String> phoneNumbers = [];
  List<ContactModel> contactsList = [];
  List<dynamic> contList = [];
  RxBool isAvailFingerPrint = false.obs;
  RxBool isAgreement = false.obs;
  bool loaderCircle = false;
  List<StoreModel> storeList = [];

  late SharedPreferences prefs;
  TextEditingController updateUserFirstname = TextEditingController();
  TextEditingController updateUserLastname = TextEditingController();
  TextEditingController updateUserAddress = TextEditingController();
  TextEditingController updateUserPhoneNumber = TextEditingController();

  String updateUserFullNumber = "";

  final RxMap<String, bool> _selectedFilter = <String, bool>{}.obs;
  final RxMap<String, bool> _selectedGiftCardFilter = <String, bool>{}.obs;


  FocusNode userNameFocusNode = FocusNode();
  FocusNode receiverVoucherCodeFocusNode = FocusNode();
  FocusNode voucherAmount = FocusNode();

  bool transactionDone = false;


  Map<String, bool> get getSelectedGiftCardFilter {
    return _selectedGiftCardFilter;
  }

  Map<String, bool> get getSelectedFilter {
    return _selectedFilter;
  }

  setFingerPrint(bool newVal) {
    isAvailFingerPrint.value = newVal;
  }

  setAgreement(bool newVal) async {
    isAgreement.value = newVal;
  }

  setSelectedFilter(
      bool newSelectedFilter, String newSelectedFilterName, bool isCoupon) {
    if (isCoupon) {
      _selectedFilter[newSelectedFilterName] = newSelectedFilter;
    } else {
      _selectedGiftCardFilter[newSelectedFilterName] = newSelectedFilter;
    }
  }

  removeFilter(String filterName, bool isCoupon) {
    if (isCoupon) {
      _selectedFilter.remove(filterName);
    } else {
      _selectedGiftCardFilter.remove(filterName);
    }
  }

  List<Widget> pages = [
    const OverviewScreen(),
    const GiftCardScreen(),
    //const CouponsScreen(),
    const TransactionsScreen(),
  ];

  List<String> pagesName = [
    "overview_heading".tr,
    "vouch_heading".tr,
    "coupon_header".tr,
    "trans_header".tr,
  ];

  get currentPage => pages[currentIndex.value];

  void changePage(int _index) {
    currentIndex.value = _index;
  }

  Future<void> getVoucher({bool shouldClear = true}) async {
    if (shouldClear) {
      _selectedGiftCardFilter.clear();
      giftCardsList.clear();
    }
    // if (!shouldClear) {
    //   await refreshHash();
    // }

    prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    //final clientHash = prefs.getString('clientHash') ?? '';
    String clientHashString = userModel.clientHash!;
    kPrint("clientHashString $clientHashString");

    final jsonBody = {'username': username, 'client_hash': clientHashString};

    try {
      final response = await http.post(getVoucherURL, body: jsonBody);
      kPrint("new data are ${response.statusCode}");
      if (response.statusCode == 200) {
        final voucherObject = json.decode(response.body);
        //giftCardsList.clear();
        var jsonArray = voucherObject['balances'];
        for (var json in jsonArray) {
          Voucher v = Voucher.fromJson(json);
          bool isAlreadyPresent = giftCardsList.value
              .any((element) => element.idNr == v.idNr);
          if (!isAlreadyPresent) {
            giftCardsList.value.insert(0, v);
          } else {
            int index = giftCardsList.value.indexOf(v);
            if (index != -1) {
              giftCardsList.value[index] = v;
            }
          }
          //kPrint("not present its new ${giftCardsList.length}");
        }

        voucherResponse.vouchers = giftCardsList.value;
        totaGiftCardAmount.value = voucherResponse.totalVoucherBalance ?? '';
        giftCardsList.refresh();
        kPrint("You get Vouchers Successfully");
        update();
      } else {
        customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
        kPrint(response.body);
      }
    } catch (e) {
      throw Exception('Failed to load Vouchers');
    }
  }

  String generateVoucherRedeemQRCode(Voucher v) {
    String qrClientHash = userModel.clientHash!;
    String qrUsername = userModel.username!;
    String qrType = "voucher";
    String qrCurrentAmount = amountToRedeem;
    String qrMessage;
    String qrVoucherCode = v.idNr!;
    String currencyCode = v.currencyCode!;
    var time_secs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    qrMessage = "$qrUsername&$currencyCode&$qrCurrentAmount&$qrClientHash";

    return qrMessage;
  }

  String generateCouponRedeemQRCode(CouponModel c) {
    String qrClientHash = userModel.clientHash!;
    String qrUsername = userModel.username!;
    String qrType = "coupon";
    String qrCurrentAmount = c.discountValue!;
    String qrMessage;
    String qrVoucherCode = c.couponCode!;
    var timeSecs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    qrMessage = "https://redimi.net/redeem/?type=$qrType&amount=null&customer_hash=$qrClientHash&customer_username=$qrUsername&timestamp=$timeSecs&voucherCode=$qrVoucherCode";

    return qrMessage;
  }

  String usernameQRCodeFunction() {
    String qrMessage = userModel.username!;
    return qrMessage;
  }

  Future<void> getTransactions({bool shouldClear = true}) async {
    //if (shouldClear) {
    transactionList.clear();

    //}

    // if (!shouldClear) {
    //   await refreshHash();
    // }
    prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username') ?? '';
    String clientHashString = userModel.clientHash!;
    final jsonBody = {'username': username, 'client_hash': clientHashString};

    final response = await http.post(getTransactionURL, body: jsonBody);
    if (response.statusCode == 200) {
      final transactionObject = json.decode(response.body);

      //transactionList = transactionObject.map((i) => Transaction.fromJson(i)).toList();

      for (var json in transactionObject) {
        TransactionModel t = TransactionModel.fromJson(json);
        transactionList.value.add(t);
      }

      transactionList.refresh();

      for (int i = 0; i < transactionList.value.length; i++) {
        DateTime dateTime = DateTime.parse(transactionList.value[i].createdAt);
        String transactionDay = dateTime.day.toInt() < 10
            ? "0${dateTime.day}"
            : dateTime.day.toString();
        String transactionMonth = dateTime.month.toInt() < 10
            ? "0${dateTime.month}"
            : dateTime.month.toString();
        String monthChar = getMonthName(transactionMonth);
        String transactionHour = dateTime.hour.toInt() <10 ? "0${dateTime.hour}" : dateTime.hour.toString();
        String transactionMin = dateTime.minute.toInt() <10 ? "0${dateTime.minute}" : dateTime.minute.toString();
        // String stringDate = "$transactionDay.$transactionMonth.${dateTime.year}";
        String stringDate = "$transactionDay $monthChar ${dateTime.year}";
        String createdAtDate = "$transactionDay.$transactionMonth.${dateTime.year}  $transactionHour:$transactionMin";
        transactionList.value[i].createdDate = stringDate;
        //*********************** THIS NEED TO BE CHANGED *******************************
        //transactionList.value[i].createdAt = stringDate;
        transactionList.value[i].createdAt = createdAtDate;
      }

      groupedTransactions.value = groupBy(transactionList.value, (TransactionModel t) => t.createdDate);
      //*********************** THIS NEED TO BE CHANGED *******************************
      //groupedTransactions.value = groupBy(transactionList.value, (TransactionModel t) => t.createdAt);

      groupedTransactions.value.forEach((date, transactions) {
        print('Date: $date');
        print('Transactions:');
        transactions.forEach((t) => print('${t.amount}'));
        print('---');
      });
      // groupedTransactions.refresh();

      //update();
      print("You get Transactions Successfully");
    } else {
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
      print("Failed to load transactions");
      print(response.body);
    }
  }

  String getMonthName(String numericMonth) {
    switch (numericMonth) {
      case '01':
        return 'January';
      case '02':
        return 'February';
      case '03':
        return 'March';
      case '04':
        return 'April';
      case '05':
        return 'May';
      case '06':
        return 'June';
      case '07':
        return 'July';
      case '08':
        return 'August';
      case '09':
        return 'September';
      case '10':
        return 'October';
      case '11':
        return 'November';
      case '12':
        return 'December';
      default:
        return 'Invalid Month';
    }
  }

  Future<void> refreshHash() async {
    prefs = await SharedPreferences.getInstance();
    String oldClientHash = userModel.clientHash!;
    //String refreshClientSalt = DBCrypt().gensaltWithRounds(10);
    String refreshClientSalt = "\$2a${DBCrypt().gensaltWithRounds(10).substring(3)}";
    String refreshClientHash =
        DBCrypt().hashpw(userModel.password!, refreshClientSalt);
    final response = await http.post(
      refreshHashURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "username": userModel.username,
          "old_client_hash": oldClientHash,
          "new_client_salt": refreshClientSalt,
          "new_client_hash": refreshClientHash
        },
      ),
    );
    prefs.setString('clientHash', refreshClientHash);
    prefs.setString('clientSalt', refreshClientSalt);
    kPrint("${response.statusCode}");

    if (response.statusCode == 200) {
      userModel.clientSalt = refreshClientSalt;
      userModel.clientHash = refreshClientHash;
      prefs.setString('clientHash', refreshClientHash);
      prefs.setString('clientSalt', refreshClientSalt);
      //goto_vouchers();
      kPrint("Refresh Hash and Salt successfully");
      kPrint(userModel.clientHash);
    } else {
      print("Refreshing Hashed Failed");
    }
  }

  Future<void> updateUser() async {
    await refreshHash();
    String userFirst = updateUserFirstname.text;
    String userLast = updateUserLastname.text;
    String userEmail = updateUserAddress.text;
    final response = await http.post(
      updateProfileURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "username": userModel.username,
          "client_hash": userModel.clientHash,
          "updated": {
            "info": {
              "firstName": userFirst,
              "lastName": userLast,
            }
          }
        },
      ),
    );
    if (response.statusCode == 200) {
      userModel.firstName = updateUserFirstname.text;
      userModel.lastName = updateUserLastname.text;
      userModel.emailAddress = updateUserAddress.text;
      customSnackBar("success_text".tr, "user_updated_successfully_text".tr,
          colorPumacyGreen);
    } else {
      updateUserLastname.text = "";
      updateUserFirstname.text = "";
      updateUserAddress.text = "";
      kPrint('Request failed with status: ${response.statusCode}');
      kPrint(response.body);
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
    }
    update();
  }

  Future<void> updateUserChecked(bool value) async {
    //await refreshHash();
    String uName = userModel.username!;
    final response = await http.post(
      updateProfileURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "username": userModel.username,
          "client_hash": userModel.clientHash,
          "updated": {
            "info": {
              "optInDashboard": value
            }
          }
        },
      ),
    );
    if (response.statusCode == 200) {
      // prefs = await SharedPreferences.getInstance();
      //sharedPreferences.setBool(uName, value);
      kPrint("Good to Go");
    } else {
      kPrint('Request failed with status: ${response.statusCode}');
      kPrint(response.body);
    }
  }

  applyFilteredList() {
    filterCouponList.clear();
    List<CouponModel> filterList = [];

    getSelectedFilter.entries.forEach((element) {
      List<CouponModel> eachFilter = couponList.value
          .where((coupon) => coupon.webshopName!
              .toLowerCase()
              .contains(element.key.toLowerCase()))
          .toList();
      filterList.addAll(eachFilter);
    });

    filterCouponList.value = filterList;
    filterCouponList.refresh();
  }

  applyGiftCardsFilteredList() {
    filterGiftCardsList.clear();
    List<Voucher> filterList = [];

    getSelectedGiftCardFilter.entries.forEach((element) {
      List<Voucher> eachFilter = giftCardsList
          .where((giftCard) => giftCard.webShopName!
              .toLowerCase()
              .contains(element.key.toLowerCase()))
          .toList();
      filterList.addAll(eachFilter);
    });

    filterGiftCardsList.value = filterList;
    filterGiftCardsList.refresh();
  }

  clearGiftCardFilter() {
    filterGiftCardsList.clear();
    _selectedGiftCardFilter.clear();
    filterGiftCardsList.refresh();
  }

  clearCouponsFilter() {
    filterCouponList.clear();
    _selectedFilter.clear();
    filterCouponList.refresh();
  }

  // Future<void> getCoupons({bool shouldClear = true}) async {
  //   //await refreshHash();
  //   if (shouldClear) {
  //     _selectedFilter.clear();
  //     couponList.clear();
  //   }
  //   if (!shouldClear) {
  //     await refreshHash();
  //   }
  //
  //   prefs = await SharedPreferences.getInstance();
  //   final username = prefs.getString('username') ?? '';
  //   final clientHash = prefs.getString('clientHash') ?? '';
  //   String clientHashString = userModel.clientHash!;
  //   final jsonBody = {'username': username, 'client_hash': clientHashString};
  //
  //   try {
  //     final response = await http.post(getCouponsURL, body: jsonBody);
  //     if (response.statusCode == 200) {
  //       final couponObject = json.decode(response.body);
  //       couponResponse.totalCoupons = '${couponObject['totalCoupons']}';
  //
  //       var jsonArray = couponObject['coupons'];
  //       for (var json in jsonArray) {
  //         CouponModel c = CouponModel.fromJson(json);
  //
  //         bool isAlreadyPresent = couponList.value
  //             .any((element) => element.couponCode == c.couponCode);
  //         if (!isAlreadyPresent) {
  //           couponList.value.insert(0, c);
  //         } else {
  //           int index = couponList.value.indexOf(c);
  //
  //           if (index != -1) {
  //             couponList.value[index] = c;
  //           }
  //         }
  //       }
  //
  //       couponResponse.coupons = couponList.value;
  //       couponList.refresh();
  //     } else {
  //       customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load coupons');
  //   }
  // }

  //**************** Function to Get Contacts from server **********************
  Future<void> getContactsFromServer() async {
    await refreshHash();
    List<Contact> contacts = await FastContacts.getAllContacts();
    phoneNumbers = contacts
        .where((contact) => contact.phones.isNotEmpty)
        .expand((contact) => contact.phones
            .map((phone) => phone.number.replaceAll(RegExp(r'[^\w\s]+'), '00')))
        .toList();

    String uName = userModel.username!;
    String uHash = userModel.clientHash!;
    print(phoneNumbers);
    final response = await http.post(
      getContactsURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "username": uName,
          "client_hash": uHash,
          "contacts_list": phoneNumbers,
        },
      ),
    );
    if (response.statusCode == 200) {
      final contactsObject = json.decode(response.body);
      var jsonArray = contactsObject['message'];
      contactsList.clear();
      //contactsList = jsonArray.values.map((json) => ContactModel.fromJson(json)).toList();
      for (var json in jsonArray.values) {
        final c = ContactModel.fromJson(json);
        contactsList.add(c);
      }
      print(contactsList.length);
      print("You get Contacts Successfully");
      update();
    } else {
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
      print("Cant get contacts");
      print(response.body);
    }
  }

  Future<void> deleteAccount() async {
    await refreshHash();
    String senderUsername = userModel.username!;
    String uHash = userModel.clientHash!;

    final response = await http.post(
      deleteAccountURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          "username": senderUsername,
          "client_hash": uHash,
        },
      ),
    );
    if (response.statusCode == 200) {
      Get.to(LoginScreen());
      print("Account Deleted");
    } else {
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
      print("********* Account deletion Error **********");
    }
  }

  Future<void> changePassword(
      BuildContext context, String oldPassword, String newPassword) async {
    Get.back();
    if (oldPassword != userModel.password) {
      customSnackBar("error_text".tr, "password_not_matched".tr, red);
    } else {
      CustomProgressDialog.instance.showHideProgressDialog(
        context,
        'changing_password'.tr,
        colorPrimary,
      );
      await refreshHash();
      String clientHashOldPassword = userModel.clientHash!;
      String refreshClientSaltNewPassword =
          "\$2a" + DBCrypt().gensaltWithRounds(10).substring(3);
      String refreshClientHashNewPassword =
          DBCrypt().hashpw(newPassword, refreshClientSaltNewPassword);
      String? userN = userModel.username;
      final response = await http.post(
        changePasswordURL,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: json.encode(
          {
            "username": userN,
            "old_client_hash": clientHashOldPassword,
            "new_client_salt": refreshClientSaltNewPassword,
            "new_client_hash": refreshClientHashNewPassword
          },
        ),
      );
      if (response.statusCode == 200) {
        CustomProgressDialog.instance.hideProgressDialog(() {});
        userModel.password = newPassword;
        userModel.clientHash = refreshClientHashNewPassword;
        userModel.clientSalt = refreshClientSaltNewPassword;
        prefs.setString('clientHash', refreshClientHashNewPassword);
        prefs.setString('clientSalt', refreshClientSaltNewPassword);
        Get.back();
        customSnackBar("success_text".tr, "Your password has been changed".tr, colorPrimary);
        print("Password Changed");
      } else {
        CustomProgressDialog.instance.hideProgressDialog(() {});
        customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
      }
    }
  }


  Future<void> convertRewardsToBalance(String shopName, int rewardCount) async {
    Get.off(TransactionProcessing(transactionDone));
    await refreshHash();
    String? userN = userModel.username;
    String? userHash = userModel.clientHash;
    // final jsonBody = {
    //   'mall_username': shopName,
    //   'customer_username': userN,
    //   'customer_hash': userHash,
    //   'reward_amount': rewardCount
    // };
    // final response = await http.post(convertRewardURL, body: jsonBody);
    print("It is Going to Convert");
    final response = await http.post(
      convertRewardURL,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode(
        {
          'mall_username': shopName,
          'customer_username': userN,
          'customer_hash': userHash,
          'reward_amount': rewardCount
        },
      ),
    );
    if (response.statusCode == 200) {
      //CustomProgressDialog.instance.hideProgressDialog(() {});
      print("200 convert");
      double userReward = double.parse(userModel.rewardBalanceAmount!);
      userReward = userReward - rewardCount;
      userModel.rewardBalanceAmount = userReward.toString();
      double balanceCount = rewardCount * 0.01;
      double userBalanceCount = double.parse(userModel.balanceAmount!);
      userBalanceCount = userBalanceCount + balanceCount;
      userModel.balanceAmount = userBalanceCount.toString();
      Get.back();
      Get.back();
      Get.back();
      saveUserData();
      update();
      customSnackBar("success_text".tr, "transaction_done".tr, colorPrimary);
      print("Password Changed");
    } else {
      //CustomProgressDialog.instance.hideProgressDialog(() {});
      Get.back();
      Get.back();
      Get.back();
      print(response.body);
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
    }
  }

  signOut() {
    userModel.clientHash = null;
    userModel.clientSalt = null;
    userModel.countryCode = null;
    userModel.couponsLength = "0";
    userModel.emailAddress = null;
    userModel.firstName = null;
    userModel.id = null;
    userModel.lastName = null;
    userModel.oldClientHash = null;
    userModel.password = null;
    userModel.phone = null;
    userModel.username = null;
    //userModel.vouchersAmount = "0";
    userModel.vouchersLength = null;
  }

  Future<void> getStores() async {
    await refreshHash();
    final username = userModel.username;
    String clientHashString = userModel.clientHash!;
    final jsonBody = {'username': username, 'client_hash': clientHashString};

    final response = await http.post(getStoresURL, body: jsonBody);
    if (response.statusCode == 200) {
      final storesObject = json.decode(response.body);
      storeList.clear();

      for (var json in storesObject) {
        StoreModel s = StoreModel.fromJson(json);
        storeList.add(s);
      }
      kPrint("You get Stores Successfully");
    } else {
      customSnackBar("error_text".tr, "something_went_wrong_text".tr, red);
      kPrint("Failed to load Stores");
      kPrint(response.body);
    }
  }

  void saveUserData(){
    prefs.setString("balanceLength", userModel.balanceLength!);
    prefs.setString("balanceAmount", userModel.balanceAmount!);
    prefs.setString("rewardBalanceAmount", userModel.rewardBalanceAmount!);
  }
}
