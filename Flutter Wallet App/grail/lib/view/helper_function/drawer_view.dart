import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/home_screen_controller.dart';
import '../../controller/login_controller.dart';
import '../../controller/thired_party_card_controller.dart';
import '../../model/user_model.dart';
import '../home_screen_nav/drawer_screens/thired_party_gift_cards/thired_party_gift_card_list.dart';
import '../login_screen.dart';
import '../setting_screen.dart';
import 'colors.dart';
import 'contacts_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  ThiredPartyCardController thiredPartyCardController =
      Get.put(ThiredPartyCardController());
  LoginController loginController = Get.put(LoginController());
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        const SizedBox(
          height: 80,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Image.asset(
            "assets/grail_logo.png",
            height: 75,
            width: 150,
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            "navmenu_cardsandvouchers".tr,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: gray_1),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: InkWell(
            onTap: () {
              thiredPartyCardController.setIsThiredarty(false);
              Get.to(() => LoyaltyAndThiredPartyGiftCardScreen());
            },
            child: Container(
              height: 50,
              width: 150,
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset("assets/loyaltycards.png", height: 28, width: 28),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "lcard_header".tr,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   height: 30,
        // ),
        InkWell(
          onTap: () {
            thiredPartyCardController.setIsThiredarty(true);
            // Navigator.pushNamed(
            //     context, LoyaltyAndThiredPartyGiftCardScreen.routeName);
            Get.to(LoyaltyAndThiredPartyGiftCardScreen(
              isThiredParty: true,
            ));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Container(
              height: 50,
              width: 150,
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset("assets/voucher.png", height: 28, width: 28),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "extcard_header".tr,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        // const SizedBox(
        //   height: 30,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 24),
        //   child: Container(
        //     height: 50,
        //     width: 150,
        //     color: Colors.transparent,
        //     child: Row(
        //       children: [
        //         Image.asset("assets/vaccinations.png", height: 28, width: 28),
        //         const SizedBox(
        //           width: 6,
        //         ),
        //         Text(
        //           "invoices_text".tr + "(Coming Soon)",
        //           style: const TextStyle(
        //               fontSize: 16,
        //               fontWeight: FontWeight.w600,
        //               color: Colors.black),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(
          height: 20,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 12, right: 12),
          child: Divider(
            height: 1,
            color: gray_1,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            "navmenu_profile".tr,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: gray_1),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: InkWell(
            onTap: () {
              Get.to(ContactScreen(false));
            },
            child: Container(
              height: 20,
              width: 150,
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset("assets/contacts.png", height: 28, width: 28),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "contact_header".tr,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: InkWell(
            onTap: () {
              Get.to(() => const SettingScreen());
            },
            child: Container(
              height: 20,
              width: 150,
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset("assets/settings.png", height: 28, width: 28),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "settings_header".tr,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: InkWell(
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'settings_signout'.tr,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  content: Text(
                    'sign_out_confirmation'.tr,
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
                      onPressed: () {
                        // homeScreenController.update();
                        // loginController.update();
                        loginController.signOut('');
                        homeScreenController.signOut();

                        Get.off(() => LoginScreen());
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
              height: 20,
              width: 150,
              color: Colors.transparent,
              child: Row(
                children: [
                  Image.asset("assets/signout.png", height: 28, width: 28),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    "settings_signout".tr,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
