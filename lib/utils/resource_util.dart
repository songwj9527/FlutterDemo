import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/language/custom_localizations.dart';
import 'package:flutter_demo_app/common/language/string_base.dart';

class ResourceUtil {

  // 获取多国语言字符串
  static StringBase? getLocale(BuildContext context) {
    return CustomLocalizations.of(context).currentLocalized;
  }

  // 获取本地图片路径
  static String getResourceImage(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }


  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}