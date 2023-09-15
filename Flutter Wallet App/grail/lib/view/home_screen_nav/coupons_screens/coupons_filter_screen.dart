import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/filters_controller.dart';
import '../../../controller/home_screen_controller.dart';
import '../../../main.dart';
import '../../helper_function/colors.dart';
import '../../helper_function/custom_widgets/custom_field.dart';
import '../../helper_function/custom_widgets/custom_search_widgets.dart';

class CouponsFilterScreen extends StatefulWidget {
  bool comingFromCoupon;
  CouponsFilterScreen({this.comingFromCoupon = true, super.key});

  @override
  State<CouponsFilterScreen> createState() => _CouponsFilterScreenState();
}

class _CouponsFilterScreenState extends State<CouponsFilterScreen> {
  List<RadioModel> radioList = [];
  List<RadioModel> searchFilterList = [];
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  HomeScreenController homeController = Get.put(HomeScreenController());
  // FilterController filterController = Get.put(FilterController());
  bool hasShownSearchBar = false;

  @override
  void initState() {
    // bool hasDemoMall = widget.comingFromCoupon
    //     ? homeController.couponList.value
    //         .any((element) => element.webshopName == "Redimi Demo Mall")
    //     : homeController.giftCardsList.value
    //         .any((element) => element.webShopName == "Redimi Demo Mall");
    // bool hasDemoRetailer = widget.comingFromCoupon
    //     ? homeController.couponList.value
    //         .any((element) => element.webshopName == "Redimi Demo Retailer")
    //     : homeController.giftCardsList.value
    //         .any((element) => element.webShopName == "Redimi Demo Retailer");
    // kPrint(hasDemoMall);
    // if (hasDemoMall) {
    //   radioList.add(RadioModel(name: "Redimi Demo Mall", value: 0));
    // }
    // if (hasDemoRetailer) {
    //   radioList.add(RadioModel(name: "Redimi Demo Retailer", value: 1));
    // }
    kPrint("${homeController.getSelectedFilter}");
    RadioModel? radioModel;
    if (widget.comingFromCoupon) {
      homeController.couponList.value.forEach((element) {
        bool hadAlreadyPresent =
            radioList.any((shopName) => shopName.name == element.webshopName);
        if (!hadAlreadyPresent) {
          radioModel = RadioModel(name: element.webshopName!);
          radioList.add(radioModel!);
          int index = radioList.indexOf(radioModel!);
          radioList[index].value = index;
        }
      });
    } else {
      homeController.giftCardsList.value.forEach((element) {
        bool hadAlreadyPresent =
            radioList.any((shopName) => shopName.name == element.webShopName);
        if (!hadAlreadyPresent) {
          radioModel = RadioModel(name: element.webShopName!);
          radioList.add(radioModel!);
          int index = radioList.indexOf(radioModel!);
          radioList[index].value = index;
        }
      });
    }
    super.initState();
  }

  void onChange(String query) {
    setState(() {
      searchQuery = query;
      searchFilterList = radioList
          .where((radioModel) =>
              radioModel.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyColors.darkBlueColor,
        centerTitle: true,
        title: Text(
          "partnerRetailers".tr,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 23.sp),
        ),
      ),
      body: SizedBox(
        // height: MediaQuery.of(context).size.height -
        //     MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: CustomTextField(
                      title: "search_here".tr,
                      controller: _searchController,
                      suffixIcon: searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  searchQuery = '';
                                  searchFilterList.clear();
                                });
                              },
                              child: const Icon(Icons.cancel))
                          : const Icon(Icons.search),
                      focusNode: _searchFocusNode,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      isReadOnly: false,
                      nextFocusNode: null,
                      onChange: onChange,
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
            ),
            Expanded(
                child: searchQuery.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchFilterList.length,
                        itemBuilder: (context, index) {
                          RadioModel radioModel = searchFilterList[index];
                          // bool isSelected = homeController.getSelectedFilter
                          //     .containsKey(radioModel.name);
                          // kPrint(radioModel.name + "$isSelected");
                          return radioTile(radioModel.name, true);
                        })
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: radioList.length,
                        itemBuilder: (context, index) {
                          RadioModel radioModel = radioList[index];
                          // bool isSelected = homeController.getSelectedFilter
                          //     .containsKey(radioModel.name);
                          // kPrint(radioModel.name + "$isSelected");
                          return radioTile(radioModel.name, true);
                        })),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  if (widget.comingFromCoupon) {
                    homeController.applyFilteredList();
                  } else {
                    homeController.applyGiftCardsFilteredList();
                  }
                  kPrint("${homeController.filterCouponList.length}");
                  Get.back();
                },
                child: Container(
                  height: 40.h,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: MyColors.greenTealColor,
                    borderRadius: BorderRadius.circular(
                        5.0), // Set the border radius here
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: Center(
                      child: Text(
                        "applyFilter".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget radioTile(String title, bool isSelected) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 2,
      child: Obx(() {
        return CheckboxListTile(
            // groupValue: selectedValue,
            title: Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400),
            ),
            value: widget.comingFromCoupon
                ? homeController.getSelectedFilter.containsKey(title)
                : homeController.getSelectedGiftCardFilter.containsKey(title),
            onChanged: (newValue) {
              if (newValue == true) {
                homeController.setSelectedFilter(
                    newValue!, title, widget.comingFromCoupon);
              } else {
                homeController.removeFilter(title, widget.comingFromCoupon);
              }
            });
      }),
    );
  }
}

class RadioModel {
  String name;
  int? value;
  RadioModel({required this.name, this.value});
}
