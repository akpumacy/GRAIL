import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:grail/controller/home_screen_controller.dart';
import '../../../model/store_model.dart';
import '../../helper_function/colors.dart';
import '../../helper_function/custom_snackbar.dart';
import '../../helper_function/custom_widgets/custom_field.dart';


class ConvertRewardScreen extends StatefulWidget {

  static final GlobalKey<FormState> _form = GlobalKey<FormState>();

  const ConvertRewardScreen({super.key});

  @override
  State<ConvertRewardScreen> createState() => _ConvertRewardScreenState();
}

class _ConvertRewardScreenState extends State<ConvertRewardScreen> {

  TextEditingController shopUsernameTextController = TextEditingController();
  TextEditingController rewardTextController = TextEditingController();
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  String dropdownValue = "";
  double userCurrentRewardsDouble = 0;
  String userCurrentRewardsString = "";

  @override
  void initState(){
    fetchStoresData();
    super.initState();
    userCurrentRewardsString = homeScreenController.userModel.rewardBalanceAmount!;
    userCurrentRewardsDouble = double.parse(userCurrentRewardsString);
  }

  Future<void> fetchStoresData() async {
    await homeScreenController.getStores();
  }

  @override
  Widget build(BuildContext context) {
    //double currentA = userModel?.rewardBalanceAmount != null ? double.parse(userModel!.rewardBalanceAmount!) : 0.0;
    int rewardCount = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
          ),
        ),
        title: Text(
          "convert_rewards".tr,
          style: TextStyle(
              fontSize: 24.sp,
              color: MyColors.newAppPrimaryColor,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: GetBuilder<HomeScreenController>(
          init: HomeScreenController(),
          builder: (controller) {
            return Form(
              key: ConvertRewardScreen._form,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.transparent,
                      height: 340.h,
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  //width: Get.width,
                                  //height: 75.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: MyColors.giftCardDetailsClr,
                                  ),
                                  child: Center(
                                    child: DropdownMenu<String>(
                                      initialSelection: controller.storeList.first.name,
                                      hintText: "please_select_store".tr,
                                      width: Get.width-36,
                                      // menuStyle: const MenuStyle(
                                      //   padding: MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                                      // ),
                                      inputDecorationTheme: InputDecorationTheme(
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintStyle: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.normal
                                        )
                                      ),
                                      onSelected: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          dropdownValue = value!;
                                        });
                                      },
                                      dropdownMenuEntries: controller.storeList.map<DropdownMenuEntry<String>>((StoreModel store) {
                                        return DropdownMenuEntry<String>(
                                            value: store.username!, label: store.name!
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 16,
                          ),


                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: CustomTextField(
                          //           title: 'shop_username'.tr,
                          //           controller: shopUsernameTextController,
                          //           isReadOnly: false,
                          //           onChange: (newVal) {},
                          //           suffixIcon: const SizedBox(),
                          //           focusNode: controller.userNameFocusNode,
                          //           keyboardType: TextInputType.text,
                          //           maxLines: 1,
                          //           nextFocusNode: null,
                          //           onSaved: () {},
                          //           validator: (text) {
                          //             if (text!.isEmpty) {
                          //               return "Please Enter Username";
                          //             }
                          //             return null;
                          //           }),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                // child: TextField(
                                //   controller: controller.voucherGiftCardAmount,
                                //   decoration: InputDecoration(
                                //     hintText: 'gift_card_amount'.tr,
                                //   ),
                                // ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: MyColors.giftCardDetailsClr,
                                  ),
                                  child: CustomTextField(
                                      title: 'reward_want_to_convert'.tr,
                                      controller: rewardTextController,
                                      isReadOnly: false,
                                      onChange: (newVal) {},
                                      suffixIcon: const SizedBox(),
                                      focusNode: controller.voucherAmount,
                                      keyboardType: TextInputType.number,
                                      maxLines: 1,
                                      nextFocusNode: null,
                                      onSaved: () {},
                                      validator: (text) {
                                        int enterAmount = int.parse(text ?? '');
                                        rewardCount = enterAmount;
                                        if (text!.isEmpty) {
                                          return "enter_amount".tr;
                                        }
                                        if(enterAmount < 250){
                                          return "minimum_rewards_are_250".tr;
                                        }
                                        else if(enterAmount > userCurrentRewardsDouble){
                                          return "Amount_Insufficient".tr;
                                        }
                                        return null;
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 30.h),
                    child: GestureDetector(
                      onTap: () {
                        final isValid = ConvertRewardScreen._form!.currentState!.validate();
                        if (!isValid) {
                          return;
                        }
                        ConvertRewardScreen._form.currentState!.save();
                        int amountInInt = int.parse(rewardTextController.text.toString());
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              'convert_rewards'.tr,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            content: Text(
                              'are_you_sure_you_want_to_convert_rewards'.tr,
                              style: const TextStyle(fontSize: 14),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Get.back(),
                                child: Text(
                                  'lcard_no'.tr,
                                  style: const TextStyle(color: teal_700),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //int rewardCount = int.parse(rewardTextController.text);
                                  if(dropdownValue == ""){
                                    customSnackBar("error_text".tr, "please_select_store".tr, red);
                                  }
                                  else{
                                    controller.convertRewardsToBalance(dropdownValue, rewardCount);
                                  }
                                },
                                child: Text(
                                  'lcard_yes'.tr,
                                  style: const TextStyle(color: teal_700),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        // height: 50.h,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        width: 300.w,
                        decoration: BoxDecoration(
                          color: MyColors.redeemGiftCardBtnClr,
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        child: Center(
                          child: Text(
                            "convert_rewards".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
