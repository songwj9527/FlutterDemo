import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusNavigationBarUtil {

  /// System overlays should be drawn with a light color. Intended for
  /// applications with a dark background.
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  /// System overlays should be drawn with a dark color. Intended for
  /// applications with a light background.
  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,
    statusBarColor: null,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  /// 设置状态栏和底部状态栏风格
  static void setSystemUIOverlayStyle({
    Color? statusBarColor: Colors.transparent,
    Brightness? statusBarBrightness: Brightness.dark,
    Brightness? statusBarIconBrightness: Brightness.light,
    Color? systemNavigationBarColor: Colors.transparent,
    Color? systemNavigationBarDividerColor: Colors.transparent,
    Brightness? systemNavigationBarIconBrightness: Brightness.light
  }) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: statusBarColor??Colors.transparent,
      statusBarBrightness: statusBarBrightness??Brightness.dark,
      statusBarIconBrightness: statusBarIconBrightness??Brightness.light,
      systemNavigationBarColor: systemNavigationBarColor??Colors.transparent,
      systemNavigationBarDividerColor: systemNavigationBarDividerColor??Colors.transparent,
      systemNavigationBarIconBrightness: systemNavigationBarIconBrightness??Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  static void enabledSystemUIOverlays({
    bool enableStatusBar: true,
    bool enableNavigationBar: true,
  }) {
    List<SystemUiOverlay> systemUIOverlaysList = <SystemUiOverlay>[];
    // 显示状态栏
    if (enableStatusBar) {
      systemUIOverlaysList.add(SystemUiOverlay.top);
    }
    // 底部按钮栏
    if (enableNavigationBar) {
      systemUIOverlaysList.add(SystemUiOverlay.bottom);
    }
    SystemChrome.setEnabledSystemUIOverlays(systemUIOverlaysList);
  }
}