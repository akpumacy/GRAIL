// ignore_for_file: constant_identifier_names

import 'package:grail/utils/routes/route_utils.dart';

import '../../main.dart';
import 'export.dart';

/// Use for push page.
///
/// If need now the page is close, can use [routeObserver].
/// If need get callback param of previous page, can use callback.
///
/// extra:
/// Real param.
///
/// arguments:
/// Designed for compatibility with older version.
///
/// allowJumpRepeat:
/// If need allow jumping to repeat page can set as [true].
push(
  String routePath, {
  Map<String, dynamic>? extra,
  Object? arguments,
  bool allowJumpRepeat = false,
}) {
  extra ??= {};
  String shortString = toShortString(arguments ?? "");
  extra['shortString'] = shortString;

  final String location = GoRouter.of(RouteUtil.context!).location;
  if (location == routePath && !allowJumpRepeat) {
    kPrint("[push] [return] Already has same route.");
    return;
  }
  RouteUtil.context!.push(routePath, extra: extra);
}

pushRemove(
  String routeName, {
  Object? arguments,
  Object? predicateArguments,
  Map<String, dynamic>? extra,
}) {
  extra ??= {};
  String shortString = toShortString(arguments ?? "");
  extra['shortString'] = shortString;
  RouteUtil.context!.go(routeName, extra: extra);
}

popUntil({required Object predicateArguments}) {
  //context.read<AllChatsBloc>().add(const OnRefreshScreenOpenEvent());
  RouteUtil().popUntil((route) =>
      route.settings.arguments == toShortString(predicateArguments) ||
      route.isFirst);
}

String toShortString(enumobj) {
  return enumobj.toString().split('.').last;
}

/// route constant file
enum RoutedNameEnum { HomeScreen, ChattingPage }
