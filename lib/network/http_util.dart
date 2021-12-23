import 'dart:collection';

import 'package:flutter_demo_app/utils/code_util.dart';

import 'constants.dart';

class HttpUtil {

  static Map<String, dynamic> getApiCommonParams() {
    Map<String, dynamic> paramDict = HashMap();
    // 应用客户端ID: web: '10000', app: "10001", wechat: '10002'
    paramDict["ClientId"] = Constants.ClientId;
    // app端硬件标识
    paramDict["DeviceToken"] = Constants.DeviceToken;
    // 当前系统时间的时间戳
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    paramDict["Timestamp"] = timestamp.toString();
    return paramDict;
  }

  static Map<String, dynamic> combineApiCommonParamsWithCommonParamMap(String commitParam, {String? token, bool payload = true}) {
    Map<String, dynamic> paramDict = HashMap();
    // 应用客户端ID: web: '10000', app: "10001", wechat: '10002'
    paramDict["ClientId"] = Constants.ClientId;
    // app端硬件标识
    paramDict["DeviceToken"] = Constants.DeviceToken;
    // 当前系统时间的时间戳
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    paramDict["Timestamp"] = timestamp.toString();

    //签名用URL
    String signatureUrl = "payload=${(commitParam??"")}&Timestamp=${(timestamp??"")}";
    //密钥添加(yy*&^%$zzk)
    String orginContent = signatureUrl + Constants.SECRETKEY;
    //MD5加密
    String md5Str = CodeUtil.generateMd5(orginContent);
    //添加到公共参数字典
    paramDict["Signature"] = md5Str;

    //Token参数添加
    paramDict["Token"] = token??"";

    if (payload) {
      //payload参数添加
      paramDict["payload"] = commitParam ?? "";
    }

    return paramDict;
  }

  static String combineApiCommonParamsWithCommonParam(Map param, String commitParam, {String? token, bool payload = true}) {

    //系统时间戳
    String timestamp = param["Timestamp"];

    //签名用URL
    String signatureUrl = "payload=${(commitParam??"")}&Timestamp=${(timestamp??"")}";
    //密钥添加(yy*&^%$zzk)
    String orginContent = signatureUrl + Constants.SECRETKEY;
    //MD5加密
    String md5Str = CodeUtil.generateMd5(orginContent);
    //添加到公共参数字典
    param["Signature"] = md5Str;

    //Token参数添加
    param["Token"] = token??"";

    if (payload) {
      //payload参数添加
      param["payload"] = commitParam ?? "";
    }

    //生成公共参数URL
    StringBuffer sbReturnUrl = StringBuffer("?");
    param.forEach((key, value) {
      sbReturnUrl.write("$key=$value&");
    });
    String returnUrl = sbReturnUrl.toString();
    return returnUrl.substring(0, returnUrl.length - 1);
  }

  static String apiCommonParamsToString(Map params) {
    //生成公共参数URL
    StringBuffer sbReturnUrl = StringBuffer("?");
    params.forEach((key, value) {
      sbReturnUrl.write("$key=$value&");
    });
    String returnUrl = sbReturnUrl.toString();
    return returnUrl.substring(0, returnUrl.length - 1);
  }
}