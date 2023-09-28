import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/home_screen_controller.dart';
import '../controller/thired_party_card_controller.dart';
import '../controller/transfer_giftcard_controller.dart';
import '../main.dart';
import '../model/user_model.dart';
import '../model/voucher_model.dart';
import 'helper_function/colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  UserModel? user;
  HomeScreen(UserModel userModel, {Key? key}) : super(key: key) {
    user = userModel;
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  ThiredPartyCardController thiredPartyCardController =
      Get.put(ThiredPartyCardController());
  StreamSubscription? transferAmountSubscription;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    homeScreenController.userModel = widget.user!;

    kPrint("user name is ${homeScreenController.userModel.username}");
    // thiredPartyCardController.getLoyalityCardsFromSqlite(
    //     userId: widget.user!.username ?? "");
    // thiredPartyCardController.getThiredPartyCardsFromSqlite(
    //     userName: widget.user!.username ?? "");
    transferAmountSubscription = eventBus.on().listen((event) {
      String totalBalance =
          homeScreenController.voucherResponse.totalVoucherBalance ?? '0';
      if (event is OwnershipTransfer) {
        kPrint(
            "event is ${event.amount} ${event.voucherCode} ${homeScreenController.voucherResponse.totalVoucherBalance}");

        if (double.parse(totalBalance) > 0) {
          double remainingBalance = double.parse(totalBalance) - event.amount;
          homeScreenController.voucherResponse.totalVoucherBalance =
              remainingBalance.toString();
        }
        homeScreenController.totaGiftCardAmount.value =
            homeScreenController.voucherResponse.totalVoucherBalance!;
        homeScreenController.giftCardsList.value
            .removeWhere((element) => element.idNr == event.voucherCode);
        homeScreenController.giftCardsList.refresh();
      } else if (event is PartialTransfer) {
        if (double.parse(totalBalance) > 0) {
          double remainingBalance =
              double.parse(totalBalance) - event.amount.toDouble();
          homeScreenController.voucherResponse.totalVoucherBalance =
              remainingBalance.toStringAsFixed(2);
          homeScreenController.totaGiftCardAmount.value =
              homeScreenController.voucherResponse.totalVoucherBalance!;
          Voucher v = homeScreenController.giftCardsList.value
              .where((element) => element.idNr == event.voucherCode)
              .first;

          double remainingCardAmount =
              (v.currentAmount - event.amount).toDouble();
          v.currentAmount = remainingCardAmount;
          kPrint("my ammount $remainingCardAmount");
          if (remainingCardAmount <= 0) {
            // kPrint("my ammount $remainingCardAmount");
            homeScreenController.giftCardsList.value.removeWhere(
                (element) => element.idNr == event.voucherCode);
          }

          homeScreenController.giftCardsList.refresh();
        }
      }
    });
    homeScreenController.getStores();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    await thiredPartyCardController.getLoyalityCardsFromSqlite(
        userId: widget.user!.username ?? "");
    await thiredPartyCardController.getThiredPartyCardsFromSqlite(
        userName: widget.user!.username ?? "");
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      kPrint("Called called");
    } else if (state == AppLifecycleState.resumed) {
      kPrint("Called called1");

      int? appPausedTime = sharedPreferences.getInt('appPausedTime');
      kPrint(appPausedTime ?? "null operator");
      if (appPausedTime != null) {
        // sharedPreferences.setInt(
        //     'appPausedTime', DateTime.now().millisecondsSinceEpoch);
        appPausedTime = sharedPreferences.getInt('appPausedTime');

        kPrint(
            "DateTime.now().millisecondsSinceEpoch ${DateTime.now().millisecondsSinceEpoch}");

        int timeDifference =
            DateTime.now().millisecondsSinceEpoch - (appPausedTime ?? 0);

        // if more than 1 hour passed
        if (timeDifference >= 3600000) {
          //loginController.signOut('fingerprintAuthRegistered');

          sharedPreferences.setInt(
              'appPausedTime', DateTime.now().millisecondsSinceEpoch);

          Get.off(() => LoginScreen());

          kPrint("User should be logged out due to inactivity.");
        }
      }
    }
  }

  @override
  void dispose() {
    transferAmountSubscription!.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //homeScreenController.getUser(userModel);
    // homeScreenController.userModel = widget.user!;
    // homeScreenController.getVoucher();
    // homeScreenController.getTransactions();
    // homeScreenController.getCoupons();
    //homeScreenController.update();
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        //backgroundColor: Colors.transparent,
        // appBar: homeScreenController.currentIndex.value == 0
        //     ? PreferredSize(child: Container(), preferredSize: Size(0, 0))
        //     : AppBar(
        //         // leading: Padding(
        //         //   padding: EdgeInsets.only(top: 20),
        //         //   child: InkWell(
        //         //       onTap: () {
        //         //         _scaffoldKey.currentState!.openDrawer();
        //         //       },
        //         //       child: const Icon(
        //         //         Icons.view_headline_outlined,
        //         //         color: Colors.black,
        //         //       )),
        //         // ),
        //         backgroundColor: Colors.transparent,
        //         centerTitle: true,
        //         automaticallyImplyLeading: false,
        //         foregroundColor: colorPrimaryDark,
        //         shadowColor: colorPrimary,
        //         bottomOpacity: 0.0,
        //         elevation: 0.0,
        //         title: homeScreenController.currentIndex.value != 0
        //             ? Padding(
        //                 padding: const EdgeInsets.only(top: 20),
        //                 child: Text(
        //                   homeScreenController.pagesName[
        //                       HomeScreenController.to.currentIndex.value],
        //                   style: const TextStyle(
        //                       fontSize: 32,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //               )
        //             : Container(),
        //       ),
        // drawer: const MyDrawer(),
        // const Padding(
        //   padding: EdgeInsets.only(top: 20),
        //   child: Icon(Icons.view_headline_outlined, color: Colors.black,),
        // ),
        body: Obx(() {
          return IndexedStack(
            index: homeScreenController.currentIndex.value,
            children: homeScreenController.pages,
          );
        }),
        // homeScreenController
        //     .pages[HomeScreenController.to.currentIndex.value],
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
              ),
            ],
          ),
          child: BottomNavigationBar(
            elevation: 20,

            currentIndex: homeScreenController.currentIndex.value,
            onTap: homeScreenController.changePage,
            selectedItemColor: MyColors.lightBlueColor,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: const TextStyle(color: Colors.white),
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,

            //type: BottomNavigatio,
            selectedFontSize: 14.sp,
            items: [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: const Icon(Icons.home),
                // Image.asset(
                //   "assets/overview.png",
                //   height: 32.h,
                //   width: 32.w,
                // ),
                label: homeScreenController.currentIndex.value == 0
                    ? "overview_heading".tr
                    : "",
              ),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: const Icon(Icons.card_giftcard),
                  // icon: Image.asset("assets/voucher.png",
                  //     height: 32.h, width: 32.w),
                  label: homeScreenController.currentIndex.value == 1
                      ? "credits".tr
                      : ""),
              // BottomNavigationBarItem(
              //     backgroundColor: Colors.white,
              //     icon: const Icon(Icons.flip_to_front_rounded),
              //     // Image.asset(
              //     //   "assets/coupon.png",
              //     //   height: 32.h,
              //     //   width: 32.w,
              //     // ),
              //     label: homeScreenController.currentIndex.value == 2
              //         ? "coupon_header".tr
              //         : ""),
              BottomNavigationBarItem(
                  backgroundColor: Colors.white,
                  icon: const Icon(Icons.send_to_mobile_outlined),
                  // Image.asset(
                  //   "assets/transactions-white.png",
                  //   height: 32.h,
                  //   width: 32.w,
                  //   color: Colors.black,
                  // ),
                  label: homeScreenController.currentIndex.value == 2
                      ? "trans_header".tr
                      : ""),
            ],
          ),
        ),
      ),
    );
  }

  Widget items(bool isSelected, IconData icon, String lable) {
    return Column(
      children: [Icon(icon), isSelected ? Text(lable) : Container()],
    );
  }
}
