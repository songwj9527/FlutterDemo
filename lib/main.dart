import 'dart:io';

import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';

import 'application.dart';
import 'blocs/base/bloc_provider.dart';
import 'blocs/blocs/app_localization/app_localization_bloc.dart';
import 'blocs/blocs/decision_page/decision_page_bloc.dart';
import 'common/common.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    LogUtil.e("Platform is Android");
//    // 设置状态栏和底部按键栏（为刘海屏不遮盖准备）
//    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
//      statusBarColor: Colors.white,//背景白色
//      statusBarIconBrightness: Brightness.dark, //图标黑色
//      systemNavigationBarColor: Colors.white,//底部navigationBar背景颜色
//    );
//    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else if (Platform.isIOS) {
    LogUtil.e("Platform is IOS");
  }
  /// 显示状态栏和底部按钮栏
  SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top, SystemUiOverlay.bottom]);

  OrientationPlugin.setPreferredOrientations(DeviceOrientation.values);
  OrientationPlugin.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  FlutterBugly.postCatchedException(() => runApp(BlocProvider<AppLocalizationBloc>(
      bloc: AppLocalizationBloc(),// 国际化切换语言
      child: BlocProvider<DecisionPageBloc>(
        bloc: DecisionPageBloc(), // 自定义路由
        child: Application(),
      ),
    )),
    debugUpload: Constants.configure.environment != Environment.RELEASE,
  );
}

