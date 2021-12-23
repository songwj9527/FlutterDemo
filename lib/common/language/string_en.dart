import 'string_base.dart';

class StringEn extends StringBase {

  // 通用
  @override
  String appName = "app";


  @override
  String notHavePhonePermission = "no phone permission";

  @override
  String notHaveStoragePermission = "no storage permission";

  @override
  String notHaveCameraPermission = "no camera permission";

  @override
  String notHaveLocationPermission = "no location permission";


  @override
  String sure = "sure";

  @override
  String cancel = "cancel";

  @override
  String pushAgainApplicationExit = "Click again and the application exits";


  // 更新版本
  @override
  String versionCheckFailed = "Failed to check version, please check network, and try again.";

  @override
  String versionUpdateTitle = "App Version Update";

  @override
  String versionUpdateMessage = "Downloading apk, please wait a minute.";

  @override
  String versionUpdateFailed = "Failed to install: please retry to open app. If it fails again, please download from official channel and install.";


  // 登录界面
  @override
  String appCompanyName = "app company";

  @override
  String welcome = "Welcome !";

  @override
  String login = "Login";

  @override
  String inputAccount = "please input account";

  @override
  String inputPassword = "please input password";

  @override
  String loginLoading = "login loading ...";

  @override
  String loginFailed = "login failed";

  @override
  String loginSuccess = "login success";


  @override
  String languageZH = "Chinese";

  @override
  String languageEN = "English";


  // 左侧边栏
  @override
  String versionUpdate = "version update";

  @override
  String languageSetting = "language setting";

  @override
  String logout = "logout";


  // 列表刷新、加载等
  @override
  String pullToRefresh = "pull to refresh";

  @override
  String refreshing = "refreshing...";

  @override
  String get refreshFailed => "refresh failed";

  @override
  String get refreshed => "refreshed";

  @override
  String get releaseToRefresh => "release to refresh";

  @override
  String get noData => "no data";

  @override
  String get pushToLoad => "push to load";

  @override
  String get loading => "loading...";

  @override
  String get loadFailed => "load failed";

  @override
  String get loaded => "loaded";

  @override
  String get releaseToLoad => "release to load";

  @override
  String get noMore => "no more";

  @override
  String get updateAt => "update at %T";
}