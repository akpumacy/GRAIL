import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/view/home_screen_nav/drawer_screens/thired_party_gift_cards/qr_scanner_camera.dart';
import '../../../../controller/home_screen_controller.dart';
import '../../../../controller/thired_party_card_controller.dart';
import '../../../../main.dart';
import '../../../../model/thired_party_card_model.dart';
import '../../../../model/user_model.dart';
import '../../../helper_function/colors.dart';
import '../../../helper_function/custom_widgets/custom_field.dart';
import '../../../helper_function/custom_widgets/custom_search_widgets.dart';
import '3rd_party_card_cell.dart';
import 'create_thired_party_card.dart';

class LoyaltyAndThiredPartyGiftCardScreen extends StatefulWidget {
  static const routeName = "/LoyaltyAndThiredPartyGiftCardScreen";
  bool isThiredParty;
  LoyaltyAndThiredPartyGiftCardScreen({this.isThiredParty = false, super.key});

  @override
  State<LoyaltyAndThiredPartyGiftCardScreen> createState() =>
      _LoyaltyAndThiredPartyGiftCardScreenState();
}

class _LoyaltyAndThiredPartyGiftCardScreenState
    extends State<LoyaltyAndThiredPartyGiftCardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  ThiredPartyCardController thiredPartyCardController =
      Get.put(ThiredPartyCardController());
  HomeScreenController homeController = Get.put(HomeScreenController());
  TextEditingController searchController = TextEditingController();
  FocusNode searchNode = FocusNode();
  bool hasShownSearchBar = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future future;
  UserModel userModel = UserModel();


  String searchQuery = "";
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }
  List<GiftAndLoyaltyCard> getFilteredCards() {
    return widget.isThiredParty
        ? thiredPartyCardController.thiredPartyGiftCardsList.value.values
        .where((card) =>
        card.cardName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
        : thiredPartyCardController.loaylityCardsList.value.values
        .where((card) =>
        card.cardName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    future = widget.isThiredParty ? getCards() : getLoyalityCards();

    super.initState();
  }

  Future<bool> getCards() async {
    kPrint("user is ${homeController.userModel.clientSalt}");

    return await thiredPartyCardController.getThiredPartyCardsFromSqlite(
        userName: homeController.userModel.username!);
  }

  Future<bool> getLoyalityCards() async {
    return await thiredPartyCardController.getLoyalityCardsFromSqlite(
        userId: homeController.userModel.username!);
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    // print(Get.mediaQuery.viewInsets.bottom);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: colorGiftCardDetails,
            ),
          ),
          title: Text(
            widget.isThiredParty ? "3rd_party".tr : "lcard_header".tr,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
                color: MyColors.newAppPrimaryColor,
                fontSize: 28.sp,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: SizedBox(
          height: Get.height - keyboardHeight - 60,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child:
                // Padding(
                //   padding: EdgeInsets.only(left: 16.w, right: 16.w),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: TextField(
                //           decoration: InputDecoration(
                //             hintText: 'shop_search'.tr,
                //             border: InputBorder.none,
                //           ),
                //           onChanged: (value) {
                //             setState(() {
                //               searchQuery = value;
                //             });
                //           },
                //         ),
                //       ),
                //       //SizedBox(width: 16.0),
                //       IconButton(
                //         icon: const Icon(Icons.search),
                //         onPressed: () {},
                //       ),
                //     ],
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextField(
                      title: "search_here".tr,
                      controller: searchController,
                      suffixIcon: const Icon(Icons.search),
                      focusNode: searchNode,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      isReadOnly: false,
                      nextFocusNode: null,
                      onChange: (newVal) {
                        setState(() {
                          searchQuery = newVal;
                        });
                      },
                      onSaved: () {},
                      validator: (text) {
                        // if (text!.isEmpty) {
                        //   return "Please Enter Code";
                        // }
                        return null;
                      }),
                ),
                // AnimatedCrossFade(
                //     firstChild: SearchWidget(onTap: () {
                //       setState(() {
                //         hasShownSearchBar = true;
                //       });
                //     }),
                //     secondChild: SearchField(
                //         onTap: () {
                //           hasShownSearchBar = false;
                //           _searchFocusNode.unfocus();
                //           setState(() {});
                //         },
                //         searchController: _searchController,
                //         searchFocusNode: _searchFocusNode),
                //     crossFadeState: !hasShownSearchBar
                //         ? CrossFadeState.showFirst
                //         : CrossFadeState.showSecond,
                //     duration: const Duration(milliseconds: 375)),
              ),
              FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? const Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : widget.isThiredParty
                          ? Obx(() {
                              return Expanded(
                                  child: thiredPartyCardController
                                          .thiredPartyGiftCardsList
                                          .value
                                          .isEmpty
                                      ? Center(
                                          child: Text("tillyet_no_card".tr),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.only(top: 20.h),
                                          // shrinkWrap: true,
                                          itemCount: getFilteredCards().length,
                                          // thiredPartyCardController.thiredPartyGiftCardsList.value.length,
                                          itemBuilder: (context, index) {
                                            GiftAndLoyaltyCard
                                                giftAndLoyaltyCard = getFilteredCards()[index];
                                                // thiredPartyCardController
                                                //     .thiredPartyGiftCardsList
                                                //     .value
                                                //     .values
                                                //     .elementAt(index);
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(CreateThiredPartyCard(
                                                  "", false,
                                                  isReadAble: true,
                                                  giftAndLoyaltyCard:
                                                      giftAndLoyaltyCard,
                                                ));
                                              },
                                              child: GiftCardCell(
                                                  giftAndLoyaltyCard:
                                                      giftAndLoyaltyCard),
                                            );
                                          },
                                        )
                                  //}),
                                  );
                            })
                          : Obx(() {
                              return Expanded(
                                  child: thiredPartyCardController
                                          .loaylityCardsList.value.isEmpty
                                      ? Center(
                                          child: Text("tillyet_no_card".tr),
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.only(top: 20.h),
                                          // shrinkWrap: true,
                                          itemCount: getFilteredCards().length,
                                          // thiredPartyCardController.loaylityCardsList.value.length,
                                          itemBuilder: (context, index) {
                                            GiftAndLoyaltyCard giftAndLoyaltyCard = getFilteredCards()[index];
                                            //thiredPartyCardController.loaylityCardsList.value.values.elementAt(index);
                                            return GestureDetector(
                                              onTap: () {
                                                Get.to(CreateThiredPartyCard(
                                                  "", false,
                                                  isReadAble: true,
                                                  giftAndLoyaltyCard:
                                                      giftAndLoyaltyCard,
                                                ));
                                              },
                                              child: GiftCardCell(
                                                  giftAndLoyaltyCard:
                                                      giftAndLoyaltyCard),
                                            );
                                          },
                                        )
                                  //}),
                                  );
                            });
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 70.w, right: 70.w, bottom: 50.h, top: 20.h),
                child: InkWell(
                  onTap: () {
                    Get.to(() => QRCamScanner());
                  },
                  child: Card(
                    //margin: EdgeInsets.only(left: 70.w, right: 70.w, bottom: 50.h, top: 20.h),
                    color: MyColors.redeemGiftCardBtnClr,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // Set the border radius here
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Text(
                          widget.isThiredParty
                              ? "add_thiredparty_card".tr
                              : "lcard_addcard".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
