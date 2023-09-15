// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../controller/home_screen_controller.dart';
// import '../../../model/coupon_model.dart';
// import '../../../utils/routes/nevigate.dart';
// import '../../helper_function/colors.dart';
// import '../../helper_function/coupon/coupon_card.dart';
// import '../../helper_function/username_qr_code.dart';
// import 'coupons_filter_screen.dart';
//
// class CouponsScreen extends StatefulWidget {
//   const CouponsScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CouponsScreen> createState() => _CouponsScreenState();
// }
//
// class _CouponsScreenState extends State<CouponsScreen> {
//   late Future<void> future;
//   HomeScreenController homeController = Get.put(HomeScreenController());
//
//   @override
//   void initState() {
//     //future = homeController.getCoupons();
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<HomeScreenController>(
//         init: HomeScreenController(),
//         builder: (homeScreenController) {
//           return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(
//               //toolbarHeight: 60.h,
//               elevation: 0,
//               centerTitle: true,
//               automaticallyImplyLeading: false,
//               title: Text(
//                 "coupon_header".tr,
//                 style: TextStyle(
//                   fontSize: 32.sp,
//                   fontWeight: FontWeight.bold,
//                   color: colorGiftCardDetails,
//                 ),
//               ),
//               backgroundColor: Colors.transparent,
//               actions: [
//                 Obx(() => homeController.filterCouponList.value.isEmpty
//                     ? const SizedBox()
//                     : Padding(
//                         padding: EdgeInsets.only(right: 20.w),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 homeController.clearCouponsFilter();
//                               },
//                               child: const SizedBox(
//                                   height: 20,
//                                   child: Text(
//                                     "Clear Fillter",
//                                     style: TextStyle(color: Colors.black),
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ))
//               ],
//             ),
//             body: RefreshIndicator(
//               onRefresh: () async {
//                 //await homeController.getCoupons(shouldClear: false);
//               },
//               child: Container(
//                 height: Get.height,
//                 width: Get.width,
//                 color: Colors.transparent,
//                 child: Stack(
//                   children: [
//                     FutureBuilder(
//                         future: future,
//                         builder: (context, snapshot) {
//                           return snapshot.connectionState ==
//                                   ConnectionState.waiting
//                               ? Center(
//                                   child: SizedBox(
//                                     height: 20.h,
//                                     width: 20.h,
//                                     child: const CircularProgressIndicator(
//                                       color: MyColors.greenTealColor,
//                                     ),
//                                   ),
//                                 )
//                               : Obx(() {
//                                   return ListView.builder(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 38.w, vertical: 16.h),
//                                     shrinkWrap: true,
//                                     itemCount: homeScreenController
//                                             .getSelectedFilter.isEmpty
//                                         ? homeScreenController
//                                             .couponList.value.length
//                                         : homeScreenController
//                                             .filterCouponList.value.length,
//                                     itemBuilder: (context, index) {
//                                       CouponModel coupons = homeScreenController
//                                               .getSelectedFilter.isEmpty
//                                           ? homeScreenController
//                                               .couponList.value[index]
//                                           : homeScreenController
//                                               .filterCouponList.value[index];
//
//                                       return InkWell(
//                                         onTap: () {},
//                                         child: couponCard(coupons, context),
//                                       );
//                                     },
//                                   );
//                                 });
//                         }),
//                     Align(
//                       alignment: Alignment.bottomLeft,
//                       child: Container(
//                         padding: const EdgeInsets.only(left: 20, bottom: 20),
//                         height: 130.h,
//                         width: 65.h,
//                         color: Colors.transparent,
//                         alignment: Alignment.bottomLeft,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             InkWell(
//                               onTap: () async {
//                                 // final Uri _url = Uri.parse(
//                                 //     'https://redimi.net/privacy-policy-app/');
//                                 // if (!await launchUrl(_url)) {
//                                 //   throw Exception('Could not launch $_url');
//                                 // }
//                                 // push(RoutePath.filterCards);
//
//                                 Get.to(CouponsFilterScreen());
//                               },
//                               child: Container(
//                                 height: 44.h,
//                                 width: 44.h,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black26,
//                                         spreadRadius: 1,
//                                         blurRadius: 1,
//                                         offset: Offset(0, 1))
//                                   ],
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.edit,
//                                     size: 20,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: Container(
//                         padding: const EdgeInsets.only(right: 20, bottom: 20),
//                         height: 130.h,
//                         width: 65.h,
//                         color: Colors.transparent,
//                         alignment: Alignment.bottomRight,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             InkWell(
//                               onTap: () async {
//                                 final Uri _url =
//                                     Uri.parse('https://www.google.com/');
//                                 if (!await launchUrl(_url)) {
//                                   throw Exception('Could not launch $_url');
//                                 }
//                               },
//                               child: Container(
//                                 height: 44.h,
//                                 width: 44.h,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black26,
//                                         spreadRadius: 1,
//                                         blurRadius: 1,
//                                         offset: Offset(0, 1))
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(3.0),
//                                   child: Center(
//                                       child: Image.asset(
//                                           "assets/google_icon.png")),
//                                 ),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 usernameQRCode(context);
//                               },
//                               child: Container(
//                                 height: 44.h,
//                                 width: 44.h,
//                                 decoration: const BoxDecoration(
//                                   color: Colors.white,
//                                   shape: BoxShape.circle,
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black26,
//                                         spreadRadius: 1,
//                                         blurRadius: 1,
//                                         offset: Offset(0, 1))
//                                   ],
//                                 ),
//                                 child: const Center(
//                                   child: Icon(
//                                     Icons.qr_code_scanner,
//                                     size: 20,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
