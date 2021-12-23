import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static Future<T?> showCustomerDialog<T>(BuildContext context, Dialog dialog, {bool outsideDismiss: true, bool backPressEnable: true}) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: context,
        barrierDismissible: outsideDismiss,// false, 屏蔽点击对话框外部自动关闭
        builder: (BuildContext buildContext) {
          return backPressEnable ? dialog : WillPopScope(child: dialog, onWillPop: () async {return Future.value(false);});
        },
      );
    } else {
      return showDialog<T>(
        context: context,
        barrierDismissible: outsideDismiss,// false, 屏蔽点击对话框外部自动关闭
        builder: (BuildContext buildContext) {
          return backPressEnable ? dialog : WillPopScope(child: dialog, onWillPop: () async {return Future.value(false);});
        },
      );
    }
  }

  static PersistentBottomSheetController<T> showBottomFullDialog<T>(BuildContext context, Widget dialog, {Color? backgroundColor}) {
    return showBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      builder: (BuildContext context) {
        return dialog??Container();
      },
    );
  }

  static Future<T?> showBottomDialog<T>(BuildContext context, Widget dialog, {Color? backgroundColor, bool isDismissible = true, bool isScrollControlled = true,}) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: backgroundColor,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      builder: (BuildContext context) {
        return dialog??Container();
      },
    );
  }
}