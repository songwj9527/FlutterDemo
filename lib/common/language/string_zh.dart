import 'string_base.dart';

class StringZh extends StringBase {

  // 通用
  @override
  String appName = "app";


  @override
  String notHavePhonePermission = "缺少手机配置信息权限";

  @override
  String notHaveStoragePermission = "缺少存储权限";

  @override
  String notHaveCameraPermission = "缺少相机权限";

  @override
  String notHaveLocationPermission = "缺少位置权限";


  @override
  String sure = "确定";

  @override
  String cancel = "取消";

  @override
  String pushAgainApplicationExit = "再按一次，应用退出";


  // 更新版本
  @override
  String versionCheckFailed = "版本检测失败,请检查网络是否正常，并尝试重新检测。";

  @override
  String versionUpdateTitle = "版本升级";

  @override
  String versionUpdateMessage = "正在下载安装包，请稍后!";

  @override
  String versionUpdateFailed = "版本安装失败，请尝试重新启动App，如若再次异常，请官方下载安装并使用。";


  // 登录界面
  @override
  String appCompanyName = "公司名称";

  @override
  String welcome = "Welcome !";

  @override
  String login = "登录";

  @override
  String inputAccount = "请输入用户名";

  @override
  String inputPassword = "请输入登录密码";

  @override
  String loginLoading = "登录中...";

  @override
  String loginFailed = "登录失败";

  @override
  String loginSuccess = "登录成功";


  @override
  String languageZH = "中文";

  @override
  String languageEN = "英文";

  // 左侧边栏
  @override
  String versionUpdate = "版本更新";

  @override
  String languageSetting = "语言设置";

  @override
  String logout = "注销登录";


  // 列表刷新、加载等
  @override
  String pullToRefresh = "下拉刷新";

  @override
  String refreshing = "正在刷新...";

  @override
  String get refreshFailed => "刷新失败";

  @override
  String get refreshed => "刷新完成";

  @override
  String get releaseToRefresh => "释放刷新";

  @override
  String get noData => "暂无数据";

  @override
  String get pushToLoad => "上拉加载";

  @override
  String get loading => "正在加载...";

  @override
  String get loadFailed => "加载失败";

  @override
  String get loaded => "加载完成";

  @override
  String get releaseToLoad => "释放加载";

  @override
  String get noMore => "没有更多数据";

  @override
  String get updateAt => "更新于 %T";
}