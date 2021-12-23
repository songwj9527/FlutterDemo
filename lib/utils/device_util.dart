import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter_demo_app/network/constants.dart';

class DeviceUtil {
  /// 初始化设备信息
  static void initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      Constants.DeviceToken = "${androidInfo.manufacturer}_${androidInfo.model}_${androidInfo.androidId}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      Constants.DeviceToken = "${iosInfo.name}_${iosInfo.identifierForVendor}";
    }
  }

  /// 获取设备ID
  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.manufacturer}_${androidInfo.model}_${androidInfo.androidId}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "${iosInfo.name}_${iosInfo.identifierForVendor}";
    }
    return "";
  }

  /// 获取设备名称
  static Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return "${androidInfo.manufacturer} ${androidInfo.model}";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return "${iosInfo.name}";
    }
    return "";
  }
}