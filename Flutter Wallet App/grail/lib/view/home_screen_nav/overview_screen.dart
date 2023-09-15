import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/view/home_screen_nav/drawer_screens/convertRewardsScreen.dart';
import '../../controller/home_screen_controller.dart';
import '../../controller/thired_party_card_controller.dart';
import '../../utils/assets.dart';
import '../helper_function/colors.dart';
import '../helper_function/drawer_view.dart';
import 'drawer_screens/thired_party_gift_cards/thired_party_gift_card_list.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  List<GridModel> gridList = [];

  GridModel getGridModelForIndex(int index) {
    switch (index) {
      case 0:
        return GridModel(
            image: MyAssets.giftCard,
            count: "${_homeScreenController.userModel.balanceAmount}€",
            title: "gift_card_balance");
      case 1:
        return GridModel(
            image: MyAssets.rewardCardIcon,
            count: _homeScreenController.userModel.rewardBalanceAmount,
            title: "rewarded_balance");
      case 2:
        return GridModel(
            image: MyAssets.loyality, count: "0", title: "lcard_header");
      case 3:
        return GridModel(
            image: MyAssets.savedGiftCards,
            count: '0', //_homeScreenController.userModel.vouchersLength,
            title: "3rd_party");
      default:
        return GridModel();
    }
  }

  double calculateAspectRatio(BuildContext context) {
    final screenWidth = Get.width;
    final desiredSquareSize =
        screenWidth / 2; // Subtract spacing from available width
    return desiredSquareSize /
        (desiredSquareSize *
            0.9.h); // Adjust the aspect ratio based on the desiredSquareSize and desired height-to-width ratio
  }

  @override
  void initState() {
    gridList = List.generate(4, (index) {
      GridModel gridModel = getGridModelForIndex(index);
      return gridModel;
    });
    // TODO: implement initState
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ThiredPartyCardController _thiredPartyCardController =
      Get.put(ThiredPartyCardController());
  @override
  Widget build(BuildContext context) {
    return
        // GetBuilder<HomeScreenController>(
        //     init: HomeScreenController(),
        //     builder: (homeScreenController) {
        //       // homeScreenController.getVoucher();
        //       return
        Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.newAppPrimaryColor,
      appBar: AppBar(
        toolbarHeight: 30.h,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.newAppPrimaryColor,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Container(
            height: 250.h,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: MyColors.newAppPrimaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: _topHeader(
                        _homeScreenController.userModel.firstName != "" &&
                                _homeScreenController.userModel.lastName != ""
                            ? Text(
                                _homeScreenController
                                        .userModel.firstName!.characters
                                        .getRange(0, 1)
                                        .string
                                        .capitalize! +
                                    _homeScreenController
                                        .userModel.lastName!.characters
                                        .getRange(0, 1)
                                        .string
                                        .capitalize!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp),
                              )
                            : const Icon(Icons.person),
                      ),
                    ),
                    _topHeader(const Icon(Icons.notifications_none))
                  ],
                ),
                SizedBox(
                  height: 34.h,
                ),
                Text(
                  "hi".tr + _homeScreenController.userModel.firstName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 28.h,
                ),
                Text(
                  "ready_discount".tr,
                  maxLines: 2,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            width: double.infinity,
            // padding: EdgeInsets.fromLTRB(23.w, 40.h, 23.w, 12.h),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     MenuCardCell(gridModel: gridList[0]),
                  //     MenuCardCell(gridModel: gridList[1]),
                  //   ],
                  // )
                  // Expanded(
                  //   child:
                  GridView.builder(
                    padding: EdgeInsets.fromLTRB(23.w, 40.h, 23.w, 12.h),
                    shrinkWrap: true,
                    itemCount: gridList.length,

                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      mainAxisSpacing: 13.0.h, // Spacing between rows
                      crossAxisSpacing: 35.0.w,

                      childAspectRatio: 1.1.h, //calculateAspectRatio(context),
                    ),
                    itemBuilder: (context, index) {
                      if (index == 2) {
                        gridList[index].count = _thiredPartyCardController
                            .loaylityCardsList.length
                            .toString();
                      }
                      if (index == 3) {
                        gridList[index].count = _thiredPartyCardController
                            .thiredPartyGiftCardsList.length
                            .toString();
                      }
                      return GestureDetector(
                          onTap: () {
                            switch (index) {
                              case 0:
                                _homeScreenController.changePage(1);
                                break;
                              case 1:
                                Get.to(() => ConvertRewardScreen());
                                //_homeScreenController.changePage(2);
                                break;
                              case 2:
                                _thiredPartyCardController
                                    .setIsThiredarty(false);
                                Get.to(() =>
                                    LoyaltyAndThiredPartyGiftCardScreen());
                                break;
                              case 3:
                                Get.to(LoyaltyAndThiredPartyGiftCardScreen(
                                  isThiredParty: true,
                                ));
                                break;
                              default:
                            }
                          },
                          child: MenuCardCell(
                            gridModel: gridList[index],
                            index: index,
                          ));
                    },
                    // ),
                  ),

                  // SizedBox(
                  //   height: 10.h,
                  // ),

                  Container(
                    height: 95.h,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 23.w),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Image.asset(
                          MyAssets.casFlow,
                          scale: 4,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ))

          ////////
          // SizedBox(
          //   height: 30.h,
          // ),

          // Padding(
          //   padding: EdgeInsets.only(left: 20, right: 20),
          //   child: Container(
          //     height: 60.h,
          //     width: 310,
          //     color: Colors.transparent,
          //     child: Text(
          //       "hi".tr + homeScreenController.userModel.firstName!,
          //       style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 32,
          //           fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ),

          // SizedBox(
          //   height: 30.h,
          // ),
          ///////////

          // Padding(
          //   padding: EdgeInsets.only(left: 36, right: 36),
          //   child: Container(
          //     height: 124,
          //     width: 350,
          //     color: Colors.white,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Padding(
          //           padding: EdgeInsets.only(left: 26.w),
          //           child: Container(
          //             height: 120,
          //             width: 250.w,
          //             color: Colors.transparent,
          //             child: Column(
          //               children: [
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 40.w, top: 18.h),
          //                   child: Text(homeScreenController.userModel.vouchersAmount + " EUR", style: const TextStyle(
          //                       color: Colors.black, fontSize: 32, fontWeight: FontWeight.w600
          //                   ),),
          //                 ),
          //                 Padding(
          //                   padding: EdgeInsets.only(left: 20.w, top: 10.h),
          //                   child: Center(
          //                     child: Container(
          //                       height: 36,
          //                       width: 250.w,
          //                       child: Center(
          //                         child: Text("redimi_voucher_balance".tr, maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(
          //                             color: gray_1, fontSize: 16, fontWeight: FontWeight.w600
          //                         ),),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(right: 4),
          //           child: Container(
          //             height: 120,
          //             width: 30,
          //             child: Column(
          //               children: [
          //                 const SizedBox(
          //                   height: 6,
          //                 ),
          //                 Container(
          //                   height: 24,
          //                   width: 24,
          //                   decoration: const BoxDecoration(
          //                     color: colorPumacyGreen,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: const Center(
          //                     child: Text("i", style: TextStyle(
          //                       color: Colors.white, fontSize: 16
          //                     ),),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          //
          //
          // SizedBox(height: 36.h,),

          /// From Here.......................

          // Padding(
          //   padding: const EdgeInsets.only(left: 36, right: 36),
          //   child: Container(
          //     height: 160.h,
          //     width: 350,
          //     color: Colors.white,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           homeScreenController.userModel.vouchersAmount! +
          //               " EUR",
          //           style: const TextStyle(
          //               color: Colors.black,
          //               fontSize: 32,
          //               fontWeight: FontWeight.w600),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         Center(
          //           child: Text(
          //             "redimi_voucher_balance".tr,
          //             maxLines: 2,
          //             textAlign: TextAlign.center,
          //             style: const TextStyle(
          //                 color: gray_1,
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.w600),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          // SizedBox(
          //   height: 36.h,
          // ),

          // Padding(
          //   padding: const EdgeInsets.only(left: 36, right: 36),
          //   child: Container(
          //     height: 160.h,
          //     width: 350,
          //     color: Colors.white,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           "coupon_header".tr,
          //           style: const TextStyle(
          //               color: Colors.black, fontSize: 28),
          //         ),
          //         const Padding(
          //           padding: EdgeInsets.only(
          //               left: 36, right: 36, top: 8, bottom: 8),
          //           child: Divider(
          //             height: 1,
          //             color: Colors.black,
          //           ),
          //         ),
          //         Text(
          //           homeScreenController.userModel.couponsLength!,
          //           style: const TextStyle(
          //               color: Colors.black,
          //               fontSize: 32,
          //               fontWeight: FontWeight.w600),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
    //});
  }

  Widget _topHeader(Widget child) {
    return Container(
      height: 42.h,
      width: 42.h,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(50.h)),
      child: Center(child: child),
    );
  }
}

class MenuCardCell extends StatelessWidget {
  GridModel gridModel;
  int index;

  MenuCardCell({required this.gridModel, required this.index, super.key});
  final ThiredPartyCardController _thiredPartyCardController =
      Get.put(ThiredPartyCardController());
  final HomeScreenController _homeController = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 150.h,
      width: 150.h,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Image.asset(
                    gridModel.image!,
                    scale: 4,
                  ),
                ],
              ),
              if (index == 0)
                Obx(
                  () => _homeController.totaGiftCardAmount.value.isNotEmpty
                      ? Text(
                          "${_homeController.totaGiftCardAmount.value} €",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.newAppPrimaryColor),
                        )
                      : Text(
                          "${_homeController.userModel.balanceAmount} €",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.newAppPrimaryColor),
                        ),
                ),
              if (index == 1)
                Obx(
                  () => _homeController.couponList.value.isNotEmpty
                      ? Text(
                          "${_homeController.couponList.value.length}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.newAppPrimaryColor),
                        )
                      : Text(
                          "${_homeController.userModel.rewardBalanceAmount}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: MyColors.newAppPrimaryColor),
                        ),
                ),
              if (index == 2)
                Obx(() => Text(
                      "${_thiredPartyCardController.loaylityCardsList.value.length}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: MyColors.newAppPrimaryColor),
                    )),
              if (index == 3)
                Obx(() => Text(
                      "${_thiredPartyCardController.thiredPartyGiftCardsList.value.length}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: MyColors.newAppPrimaryColor),
                    )),
              Text(
                gridModel.title!.tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: MyColors.newAppPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridModel {
  String? title;
  String? count;
  String? image;

  GridModel({
    this.title,
    this.count,
    this.image,
  });
}
