import 'package:flutter/material.dart';
import 'package:flutter_demo_app/ui/widgets/customer_popup_route.dart';
import 'package:flutter_demo_app/ui/widgets/customer_popup_window.dart';
import 'package:flutter_demo_app/ui/widgets/customer_popup_window_stateful.dart';

class PopupWindowUtil {
  static void popup(BuildContext context, {Widget? child, double? left, double? top, Function? select, Function? cancel}) {
    Navigator.push(
      context,
      CustomerPopupRoute(
        child: CustomerPopupWindow(
          child: child,
          left: left,
          top: top,
          onSelected: select,
          onCancel: cancel,
        ),
      ),
    );
  }

  static Future<T?> popup_state<T>(BuildContext context, {Widget? child, double? left, double? top, Function? select, Function? cancel}) {
    return Navigator.push<T>(
      context,
      CustomerPopupRoute<T>(
        child: CustomerPopupWindowStateful(
          child: child,
          left: left,
          top: top,
          onSelected: select,
          onCancel: cancel,
        ),
      ),
    );
  }
}