import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grail/utils/routes/route_path.dart';
import 'package:grail/utils/routes/route_utils.dart';

import '../../view/home_screen_nav/coupons_screens/coupons_filter_screen.dart';
import '../../view/splash_screen.dart';

export 'route_utils.dart';

class RouteDefine {
  /// Here can config route, any route need add "/" to start position
  /// when call route function.
  ///
  /// example:
  /// I want push splash page, code below.
  /// ```dart
  /// context.push('/splash');
  /// ```
  static List<RouteBase> routeList = <RouteBase>[
    PhizRoute(
      path: RoutePath.root,
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
    PhizRoute(
      path: RoutePath.filterCards,
      builder: (BuildContext context, GoRouterState state) {
        Map<String, dynamic> extra = (state.extra! as Map<String, dynamic>);

        return CouponsFilterScreen(
          comingFromCoupon: extra['isCoupon'],
        );
      },
    ),
  ];
}
