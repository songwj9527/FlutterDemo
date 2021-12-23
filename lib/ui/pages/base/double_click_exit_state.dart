import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';

import 'base_state.dart';

abstract class DoubleClickExitState<T extends StatefulWidget> extends BaseState<T> {

  // Android双击返回按钮退出应用
  int _lastClickTime = 0;
  Future<bool> _onWillPop() {
    int nowTime = DateTime.now().microsecondsSinceEpoch;
    if (_lastClickTime != 0 && nowTime - _lastClickTime > 1500) {
      //        exit(0);
      exitSystem();
      return Future.value(true);
    } else {
      _lastClickTime = DateTime.now().microsecondsSinceEpoch;
      Future.delayed(const Duration(milliseconds: 1500), () {
        _lastClickTime = 0;
      });
      ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.pushAgainApplicationExit : "");
      return Future.value(false);
    }
  }

  // 退出系统应用
  Future<bool> exitSystem() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context);
}