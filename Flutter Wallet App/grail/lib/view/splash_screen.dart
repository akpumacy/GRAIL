import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/home_screen_controller.dart';
import '../controller/login_controller.dart';
import '../main.dart';
import 'helper_function/colors.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash_screen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    LoginController loginController = Get.put(LoginController());
    HomeScreenController homeScreenController = Get.put(HomeScreenController());
    permissionStorage();
    //requestPermissions(context);
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();

      String? clientHash = prefs.getString('clientHash');
      String? clientSalt = prefs.getString('clientSalt');
      if (clientHash != null && clientSalt != null) {
        await loginController
            .saveLocalData(loginController.userModel, shpuldRefreshHash: true)
            .then((value) {
          loginController.saveLocalData(
            homeScreenController.userModel,
          );
          Get.off(() => HomeScreen(loginController.userModel));
        });
      } else {
        Timer(const Duration(seconds: 3), () => Get.off(() => LoginScreen()));
      }

      // int? appPausedTime = prefs.getInt('appPausedTime');
      // kPrint(appPausedTime ?? "null operator");
      // if (appPausedTime == null) {
      //   prefs.setInt('appPausedTime', DateTime.now().millisecondsSinceEpoch);
      // }
      // appPausedTime = prefs.getInt('appPausedTime');
      //
      // kPrint(
      //     "DateTime.now().millisecondsSinceEpoch ${DateTime.now().millisecondsSinceEpoch}");
      //
      // int timeDifference =
      //     DateTime.now().millisecondsSinceEpoch - (appPausedTime ?? 0);
      //
      // // if more than 1 hour passed
      // if (timeDifference >= 3600000) {
      //   //loginController.signOut('fingerprintAuthRegistered');
      //   Timer(const Duration(seconds: 3), () => Get.off(() => LoginScreen()));
      //
      //   kPrint("User should be logged out due to inactivity.");
      // } else {
      //   String? clientHash = prefs.getString('clientHash');
      //   String? clientSalt = prefs.getString('clientSalt');
      //   if (clientHash != null && clientSalt != null) {
      //     await loginController
      //         .saveLocalData(loginController.userModel, shpuldRefreshHash: true)
      //         .then((value) {
      //       loginController.saveLocalData(
      //         homeScreenController.userModel,
      //       );
      //       Get.off(() => HomeScreen(loginController.userModel));
      //     });
      //   } else {
      //     Timer(const Duration(seconds: 3), () => Get.off(() => LoginScreen()));
      //   }
      // }
    });
    super.initState();

    // WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // GetBuilder<LoginController>(
        //     init: LoginController(),
        //     builder: (controller) {
        //       return
        Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150.h,
            ),
            Image.asset(
              "assets/grail_logo.png",
              height: 100.h,
              width: 240.w,
            ),
            SizedBox(
              height: 2.h,
            ),
            // Padding(
            //   padding: EdgeInsets.only(left: 26.w, right: 26.w),
            //   child: Text(
            //     'splash_text'.tr,
            //     maxLines: 3,
            //     overflow: TextOverflow.ellipsis,
            //     textAlign: TextAlign.center,
            //     style: const TextStyle(
            //         fontSize: 28,
            //         color: purple_700,
            //         fontWeight: FontWeight.bold),
            //   ),
            // ),
            SizedBox(
              height: 150.h,
            ),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(purple_700),
            ),
          ],
        ),
      ),
    );
    // });
  }

  void permissionStorage() async {
    Map<Permission, PermissionStatus> permissions = await [
      Permission.storage,
      Permission.contacts,
      Permission.camera
    ].request();
  }
}
