import 'package:flutter_demo_app/common/common.dart' as common;

class Constants {
  // 网络地址
  static final String BASE_URL_DEBUG = "";
  // 网络地址
  static final String BASE_URL_RELEASE = "";
  // 应用下载链接H5地址
  static final String APP_H5_URL_DEBUG = "";
  // 应用下载链接H5地址
  static final String APP_H5_URL_RELEASE = "";

  static String BASE_URL() {
    if (common.Constants.configure.environment == common.Environment.RELEASE) {
      return BASE_URL_RELEASE;
    }
    return BASE_URL_DEBUG;
  }

  static String APP_H5_URL() {
    if (common.Constants.configure.environment == common.Environment.RELEASE) {
      return APP_H5_URL_RELEASE;
    }
    return APP_H5_URL_DEBUG;
  }

  // 应用客户端ID ClientId	{web: '10000', app: "10001", wechat: '10002'}
  static final String ClientId = "10001";

  // app端硬件标识
  static String DeviceToken = "";

  // 签名密钥Key
  static final String SECRETKEY = "yy*&^%\$zzk";


  /*******************************************************
   * 以下为网络业务API名
   *******************************************************/
  // 发送验证码
  static final String GET_APP_ONLINE_VERSION = "/version";


  // 发送验证码
  static final String SEND_VERIFICATION_CODE = "/verificationCode";
  // 用户账户、密码登录
  static final String ACCOUNT_PASSWORD_LOGIN = "/login";
  // 验证码登录
  static final String VERIFICATION_CODE_LOGIN = "/login/verificationCode";
  // 退出登录
  static final String LOGOUT = "/logout";
  // 修改密码
  static final String MODIFY_USER_PASSWORD = "/user/password";
  // 获取个人信息
  static final String GET_USER_INFO = "/user/detail";
  // 获取个人信息
  static final String MODIFY_USER_INFO = "/user/detail";


  // 文件上传
  static final String UPLOAD_FILE = "/file/upload";
  // 文件上传（不签名）
  static final String UPLOAD_FILE_SPECIAL = "/file/upload/special";
  // 文件下载
  static final String DOWNLOAD_FILE = "/file/download/";
  // 文件下载（不签名）
  static final String DOWNLOAD_FILE_SPECIAL = "/special";
}