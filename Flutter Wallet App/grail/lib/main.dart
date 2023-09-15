import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:grail/view/home_screen_nav/drawer_screens/thired_party_gift_cards/create_thired_party_card.dart';
import 'package:grail/view/home_screen_nav/drawer_screens/thired_party_gift_cards/qr_scanner_camera.dart';
import 'package:grail/view/home_screen_nav/drawer_screens/thired_party_gift_cards/thired_party_gift_card_list.dart';
import 'package:grail/view/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'controller/localization_controller.dart';
import 'db_manager.dart';

Map? en, de;
Locale? locale;
Future<Database>? database;
late SharedPreferences sharedPreferences;
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();
EventBus eventBus = EventBus();
// replace global print
void kPrint(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

Future<void> main() async {
  if (Platform.isMacOS) {
    WidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DbManager.openDB();
  sharedPreferences = await SharedPreferences.getInstance();
  final locationService = LocalizationController();
  en = await locationService.loadLang('en');
  de = await locationService.loadLang('de');
  locale = await locationService.fetchLocale();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Grail',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: SplashScreen(),
          locale: locale,
          fallbackLocale: LocalizationController.fallbackLocale,
          translations: LocalizationController(),
          initialRoute: '/',
          routes: {
            '/': (ctx) => SplashScreen(),
            LoyaltyAndThiredPartyGiftCardScreen.routeName: (ctx) =>
                LoyaltyAndThiredPartyGiftCardScreen(),
            CreateThiredPartyCard.routeName: (ctx) => CreateThiredPartyCard("", false),
            QRCamScanner.routeName: (ctx) => QRCamScanner()
          },
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        );
      },
    );
  }
}
