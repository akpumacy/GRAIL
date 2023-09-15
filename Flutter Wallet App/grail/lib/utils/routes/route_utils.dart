import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:grail/utils/routes/route_define.dart';
import 'package:grail/utils/routes/route_path.dart';
import '../../main.dart'
    show
        GoRoute,
        GoRouter,
        GoRouterState,
        GoRouterWidgetBuilder,
        RouteDefine,
        RoutePath,
        routeObserver;
import 'export.dart';

class RouteUtil {
  /// NavigatorKey can implement route push without context.
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  /// Context of navigator.
  ///
  /// When need push page but no context, can use it.
  ///
  /// example:
  /// ```dart
  /// RouteUtil.context.push('/splash');
  /// ```
  static BuildContext? get context =>
      navKey.currentContext ?? navKey.currentState?.context;

  /// Check context is not be null.
  static bool get hasContext => context != null;

  /// When open app first show screen.
  static String initialLocation = RoutePath.root;

  /// Real use router.
  static GoRouter router = GoRouter(
    initialLocation: initialLocation,
    observers: [routeObserver],
    navigatorKey: navKey,
    routes: RouteDefine.routeList,
  );

  /// Displays a Material dialog above the current contents of the app, with
  /// Material entrance and exit animations, modal barrier color, and modal
  /// barrier behavior (dialog is dismissible with a tap on the barrier).
  Future<T?> showDialog<T>({
    required Widget Function(BuildContext) builder,
    bool? barrierDismissible = true,
    bool useRootNavigator = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) =>
      RouteImpUtil.showDialogImpl(
          builder: builder,
          barrierDismissible: barrierDismissible,
          useRootNavigator: useRootNavigator,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          useSafeArea: useSafeArea,
          routeSettings: routeSettings,
          anchorPoint: anchorPoint);

  Future<bool> _contextLoaded() async {
    await Future.delayed(Duration.zero);
    if (!hasContext && !kReleaseMode) {
      throw noContextError;
    }
    return RouteUtil.hasContext;
  }

  /// Pop the top-most dialog off the RouteUtil.dialog.
  popDialog<T extends Object>([T? result]) async {
    if (!(await _contextLoaded())) return;
    return Navigator.of(context!).pop<T>(result);
  }

  /// Push the given route onto the navigator.
  Future push(Route route) {
    return Navigator.of(context!).push(route);
  }

  /// Whether the navigator can be popped.
  bool canPop() {
    return Navigator.of(context!).canPop();
  }

  /// Pop page.
  void pop() {
    if (RouteUtil().canPop()) Navigator.of(context!).pop();
  }

  /// Calls [pop] repeatedly until the predicate returns true.
  ///
  /// The predicate may be applied to the same route more than once if [Route.willHandlePopInternally] is true.
  ///
  /// To pop until a route with a certain name, use the [RoutePredicate] returned from [ModalRoute.withName].
  void popUntil(RoutePredicate predicate) =>
      navKey.currentState!.popUntil(predicate);

  /// Push the given route onto the navigator, and then remove all the previous
  /// routes until the `predicate` returns true.
  Future<T?> pushAndRemoveUntil<T extends Object?>(
          Route<T> newRoute, RoutePredicate predicate) =>
      navKey.currentState!.pushAndRemoveUntil<T>(newRoute, predicate);
}

const String noContextError = """
  RouteUtil not initiated! please use builder method.
  You need to use the RouteUtil().builder function to be able to show dialogs and overlays! e.g. ->

  MaterialApp(
    builder: RouteUtil().builder,
    ...
  )

  If you already set the RouteUtil().builder early, maybe you are probably trying to use some methods that will only be available after the first MaterialApp build.
  RouteUtil needs to be initialized by MaterialApp before it can be used in the application. This error exception occurs when RouteUtil context has not yet loaded and you try to use some method that needs the context, such as the showDialog, dismissSnackBar, showSnackBar, showModalBottomSheet, showBottomSheet or popDialog methods.

  If you need to use any of these RouteUtil methods before defining the MaterialApp, a safe way is to check if the RouteUtil context has already been initialized.
  e.g. 

  ```dart
    if (RouteUtil.hasContext) {RouteUtil().showDialog (...);}
  ```
""";

class RouteImpUtil {
  static Future<T?> showDialogImpl<T>({
    required Widget Function(BuildContext) builder,
    required bool? barrierDismissible,
    required bool useRootNavigator,
    required Color? barrierColor,
    required String? barrierLabel,
    required bool useSafeArea,
    required RouteSettings? routeSettings,
    required Offset? anchorPoint,
  }) =>
      showDialog<T?>(
        context: RouteUtil.context!,
        builder: (context) => builder(context),
        barrierDismissible: barrierDismissible!,
        useRootNavigator: useRootNavigator,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        routeSettings: routeSettings,
        anchorPoint: anchorPoint,
      );
}

class PhizRoute extends GoRoute {
  PhizRoute({
    required String path,
    required GoRouterWidgetBuilder builder,
  }) : super(
          path: path,
          pageBuilder: (
            BuildContext context,
            GoRouterState state,
          ) {
            Map<String, dynamic>? extra =
                (state.extra as Map<String, dynamic>?);
            return CupertinoPage<void>(
              name: state.name,
              arguments: extra?['shortString'],
              child: builder(context, state),

              // child: RootWindow(
              //     builder: builder, inContext: context, inState: state),
            );
          },
        );
}
