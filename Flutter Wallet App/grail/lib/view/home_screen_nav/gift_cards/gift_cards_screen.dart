import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/home_screen_controller.dart';
import '../../../controller/login_controller.dart';
import '../../../main.dart';
import '../../../model/voucher_model.dart';
import '../../helper_function/colors.dart';
import '../../helper_function/username_qr_code.dart';
import '../../helper_function/voucher/voucher_card.dart';
import '../../helper_function/voucher/voucher_detail_screen.dart';
import '../coupons_screens/coupons_filter_screen.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({Key? key}) : super(key: key);

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  late Future<void> future;

  HomeScreenController homeController = Get.put(HomeScreenController());
  LoginController loginController = Get.put(LoginController());

  @override
  void initState() {
    future = fetchVouchers();
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchVouchers({bool shouldCleraData = true}) async {
    kPrint("Vpuchers Calling");
    return await homeController.getVoucher(shouldClear: shouldCleraData);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
        init: HomeScreenController(),
        builder: (homeController) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              // toolbarHeight: 80.h,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: Text(
                "balances".tr,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: MyColors.newAppPrimaryColor,
                ),
              ),
              backgroundColor: Colors.white,
              actions: [
                Obx(() => homeController.filterGiftCardsList.value.isEmpty
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(right: 20.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                homeController.clearGiftCardFilter();
                              },
                              child: const SizedBox(
                                  height: 20,
                                  child: Text(
                                    "Clear Fillter",
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ),
                          ],
                        ),
                      ))
              ],
            ),
            body: SizedBox(
              height: Get.height,
              width: Get.width,
              // color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        FutureBuilder(
                            future: future,
                            builder: (context, snapshot) {
                              return snapshot.connectionState == ConnectionState.waiting
                                  ? Center(
                                      child: SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child: const CircularProgressIndicator(
                                          color: MyColors.greenTealColor,
                                        ),
                                      ),
                                    )
                                  : Obx(() {
                                      return RefreshIndicator(
                                        onRefresh: () async {
                                          await fetchVouchers(
                                              shouldCleraData: false);
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 30.h,
                                                  horizontal: 30.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: Get.width,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: HeaderCell(
                                                            title:
                                                                "${homeController.userModel.balanceAmount ?? 0} €",
                                                            headerColor: MyColors
                                                                .giftCardDetailsClr,
                                                            titleColor: MyColors
                                                                .newAppPrimaryColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 21.w,
                                                        ),
                                                        Expanded(
                                                          child: HeaderCell(
                                                            title:
                                                                "${homeController.userModel.balanceLength}",
                                                            //  homeController
                                                            //         .voucherResponse
                                                            //         .totalVouchers ??
                                                            //     "",
                                                            headerColor: MyColors
                                                                .redeemGiftCardBtnClr,
                                                            titleColor:
                                                                Colors.white,
                                                            hasBalance: false,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child:
                                                  //Obx(() {
                                                //return
                                            ListView.builder(
                                                  //reverse: true,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 38.w,
                                                      vertical: 20.h),
                                                  shrinkWrap: true,
                                                  itemCount: homeController
                                                          .getSelectedGiftCardFilter
                                                          .isEmpty
                                                      ? homeController
                                                          .giftCardsList
                                                          .value
                                                          .length
                                                      : homeController
                                                          .filterGiftCardsList
                                                          .value
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Voucher giftCard = homeController
                                                            .getSelectedGiftCardFilter
                                                            .isEmpty
                                                        ? homeController
                                                            .giftCardsList
                                                            .value[index]
                                                        : homeController
                                                            .filterGiftCardsList
                                                            .value[index];

                                                    return InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                            VoucherDetailScreen(
                                                                homeController
                                                                    .userModel,
                                                                giftCard));
                                                      },
                                                      child: VoucherCard(
                                                          voucher: giftCard),
                                                    );
                                                  },
                                                )
                                              //}),
                                              //),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                            }),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding:
                                const EdgeInsets.only(left: 20, bottom: 20),
                            height: 130.h,
                            width: 65.h,
                            color: Colors.transparent,
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final Uri _url = Uri.parse(
                                        'https://redimi.net/gift-cards');
                                    if (!await launchUrl(_url)) {
                                      throw Exception('Could not launch $_url');
                                    }
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: 44.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1))
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    //push(RoutePath.filterCards,
                                    // extra: {'isCoupon': false});
                                    Get.to(CouponsFilterScreen(
                                      comingFromCoupon: false,
                                    ));
                                    // final Uri _url = Uri.parse(
                                    //     'https://redimi.net/privacy-policy-app/');
                                    // if (!await launchUrl(_url)) {
                                    //   throw Exception('Could not launch $_url');
                                    // }
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: 44.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1))
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding:
                                const EdgeInsets.only(right: 20, bottom: 20),
                            height: 130.h,
                            width: 65.h,
                            color: Colors.transparent,
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    final Uri _url =
                                        Uri.parse('https://www.google.com/');
                                    if (!await launchUrl(_url)) {
                                      throw Exception('Could not launch $_url');
                                    }
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: 44.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1))
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Center(
                                          child: Image.asset(
                                              "assets/google_icon.png")),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    usernameQRCode(context);
                                  },
                                  child: Container(
                                    height: 44.h,
                                    width: 44.h,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 1))
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.qr_code_scanner,
                                        size: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

class HeaderCell extends StatelessWidget {
  String title;
  Color headerColor;
  Color titleColor;
  bool hasBalance;

  HeaderCell(
      {required this.headerColor,
      required this.title,
      required this.titleColor,
      this.hasBalance = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: hasBalance ? 5.h : 14.h, horizontal: 20.w),
      constraints: BoxConstraints(
        minHeight: 60.h,
        // minWidth: Get.width / 2.5.w,
        // maxWidth: hasBalance ? Get.width - 200.w : Get.width / 2.5.w
      ),
      decoration: BoxDecoration(
          color: headerColor, borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Column(
          children: [
            Text(
              title.tr,
              maxLines: 3,
              style: TextStyle(
                  color: titleColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700),
            ),
            if (hasBalance)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "balance".tr,
                    style: TextStyle(
                        color: MyColors.textGrayColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
