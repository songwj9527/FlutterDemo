import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:common_utils/common_utils.dart';
import 'package:path/path.dart' as path;
import 'package:wechat_kit/wechat_kit.dart';

class WeChatHelper {
  static final String WECHAT_APPID = '';
  static final String WECHAT_APPSECRET = '';
  static final String WECHAT_MINIAPPID = '';
  static final String WECHAT_UNIVERSAL_LINK = ''; // iOS 请配置


  static final WeChatHelper _singleton = WeChatHelper();

  static WeChatHelper init() {
    _singleton._init();
    return _singleton;
  }

  static WeChatHelper getInstance() {
    return _singleton;
  }

  _init() {
    Wechat.instance.registerApp(
      appId: WECHAT_APPID,
      universalLink: WECHAT_UNIVERSAL_LINK,
    );
  }

  StreamSubscription<WechatSdkResp> setShareListener(Function(WechatSdkResp) listener) {
    return Wechat.instance.shareMsgResp().listen(listener);
  }

  StreamSubscription<WechatPayResp> setPayListener(Function(WechatPayResp) listener) {
    return Wechat.instance.payResp().listen(listener);
  }

  StreamSubscription<WechatLaunchMiniProgramResp> setMiniProgramListener(Function(WechatLaunchMiniProgramResp) listener) {
    return Wechat.instance.launchMiniProgramResp().listen(listener);
  }

  Future<void>? shareText(String text, {scene: WechatScene.TIMELINE}) async {
    if (TextUtil.isEmpty(text)) {
      return;
    }
    return Wechat.instance.shareText(
      scene: scene,
      text: text,
    );
  }

  Future<void>? shareImage(File? image, {scene: WechatScene.SESSION, String? title, String? description, Uint8List? thumbData}) async {
    if (image == null) {
      return null;
    }
    bool exists = await image.exists();
    if (!exists) {
      return null;
    }
    return Wechat.instance.shareImage(
      scene: scene,
      title: title??'图片分享',
      description: description??"",
      imageUri: Uri.file(image.path),
      imageData: thumbData,
    );
  }

  Future<void>? shareFile(File? file,{scene: WechatScene.SESSION, String? title, String? description, Uint8List? thumbData}) async {
    if (file == null) {
      return null;
    }
    bool exists = await file.exists();
    if (!exists) {
      return null;
    }
    return Wechat.instance.shareFile(
      scene: scene,
      title: title??'文件分享',
      description: description??"",
      fileUri: Uri.file(file.path),
      fileExtension: path.extension(file.path),
      thumbData: thumbData,
    );
  }

  Future<void>? shareWebPage(String webUrl, {scene: WechatScene.TIMELINE, String? title, String? description, Uint8List? thumbData}) {
    if (TextUtil.isEmpty(webUrl)) {
      return null;
    }
    return Wechat.instance.shareWebpage(
      scene: scene,
      title: title??'网页分享',
      description: description??"",
      webpageUrl: webUrl,
      thumbData: thumbData,
    );
  }

  Future<void>? pay(String partnerId, String prepayId, String package, String nonceStr, String timeStamp, String sign) {
    // 微信 Demo 例子：https://wxpay.wxutil.com/pub_v2/app/app_pay.php
    return Wechat.instance.pay(
      appId: WECHAT_APPID,
      partnerId: partnerId,
      prepayId: prepayId,
      package: package,
      nonceStr: nonceStr,
      timeStamp: timeStamp,
      sign: sign,
    );
  }

  Future<void>? mini() {
    return Wechat.instance.launchMiniProgram(
      userName: WECHAT_MINIAPPID,
      path: 'page/page/index?uid=123',
      type: WechatMiniProgram.preview,
    );
  }
}