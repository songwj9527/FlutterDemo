import 'package:flutter/cupertino.dart';

class NavigatorUtil {

  /// 跳转到page页面
  static Future<T?>? pushPage<T>(BuildContext? context, Widget? page) {
    if (context == null || page == null) return null;
    return Navigator.push<T>(context, CupertinoPageRoute<T>(builder: (ctx) => page));
  }

  /// 跳转到page页面
  static Future<T?>? pushNamed<T>(BuildContext? context, String? page, {Object? arguments,}) {
    if (context == null || page == null) return null;
    return Navigator.pushNamed<T>(context, page, arguments: arguments);
  }

  /// 用page页面替换当前页面
  static Future<T?>? pushReplacement<T, B>(BuildContext? context, Widget? page) {
    if (context == null || page == null) return null;
    return Navigator.pushReplacement<T, B>(context, CupertinoPageRoute<T>(builder: (ctx) => page));
  }

  /// 跳转到page页面，并清空之前所有页面
  static Future<T?>? pushAndRemoveUntil<T>(BuildContext? context, Widget? page) {
    if (context == null || page == null) return null;
    return Navigator.pushAndRemoveUntil<T>(context, CupertinoPageRoute<T>(builder: (ctx) => page), (route) => false);
  }

  /// 用newRouteName页面替换当前页面
  static Future<T?>? pushReplacementNamed<T, B>(BuildContext? context, String? name, {Object? arguments}) {
    if (context == null || name == null || name.length == 0) return null;
    return Navigator.pushReplacementNamed<T, B>(context, name, arguments: arguments);
  }

  /// 跳转到newRouteName页面，并清空之前所有页面
  static Future<T?>? pushNamedAndRemoveUntil<T>(BuildContext? context, String? newRouteName) {
    if (context == null || newRouteName == null || newRouteName.length == 0) return null;
    return Navigator.pushNamedAndRemoveUntil<T>(context, newRouteName, (route) => true);
  }

  /// 跳转到newRouteName页面，并且在newRouteName返回时，回到了oldRouteName
  static Future<T?>? pushNamedAndRemoveUntilTo<T>(BuildContext? context, String? newRouteName, String? oldRouteName, {Object? arguments}) {
    if (context == null || newRouteName == null || newRouteName.length == 0 || oldRouteName == null || oldRouteName.length == 0) return null;
    return Navigator.pushNamedAndRemoveUntil<T>(context, newRouteName, ModalRoute.withName(oldRouteName), arguments: arguments);
  }

  /// 返回某页面并销毁俩个页面之间的页面
  static void popUntilWithName(BuildContext? context, String? oldRouteName, {Object? arguments}) {
    if (context == null || oldRouteName == null || oldRouteName.length == 0) return;
    Navigator.of(context).popUntil(ModalRoute.withName(oldRouteName));
  }

}
