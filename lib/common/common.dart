class Constants {
  // 应用包信息
  static final AppPackageInfo packageInfo = AppPackageInfo();

  // 应用配置
  static final AppConfigure configure = AppConfigure();

  // 存储在本地的语言设置的key
  static const String keyLanguage = 'key_language';
}

// 应用包信息
class AppPackageInfo {
  // 版本号
  // `CFBundleVersion` on iOS, `versionCode` on Android.
  static String buildNumber = '1';
  // 版本
  static String version = '1.0.0';
  // 包名
  static String packageName = "";
}

// 应用配置
class AppConfigure {
  // 应用环境
  Environment environment = Environment.RELEASE;
}

// 应用环境
enum Environment {
  DEBUG,   // 测试环境
  PREVIEW, // 预发环境
  RELEASE  // 正式环境
}