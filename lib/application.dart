import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';

import 'blocs/base/bloc_provider.dart';
import 'blocs/blocs/app_localization/app_localization_bloc.dart';
import 'common/common.dart';
import 'common/language/custom_localizations_delegate.dart';
import 'common/language/local_model.dart';
import 'common/wechat/wechat_helper.dart';
import 'network/net_client.dart';
import 'ui/pages/decision/DecisionPage.dart';
import 'ui/pages/home/home_page.dart';
import 'ui/pages/login/login_page.dart';
import 'ui/pages/splash/splash_page.dart';
import 'utils/device_util.dart';

class Application extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ApplicationState();

}
class _ApplicationState extends State<Application> {
  LocalModel? localModel = null;

  @override
  void initState() {
    super.initState();
    LogUtil.e("_ApplicationState: initState()");

    /// 初始化包信息：PackageInfo
    _initPackageInfo();
    /// 初始化设备信息
    _initDeviceInfo();
    DeviceUtil.initDeviceInfo();
    /// 初始化本地语言
    _initLocal();
    /// 初始化本地数据存储
    SpUtil.getInstance();
    /// 初始化本地文件夹
    setInitDir(initTempDir: true, initAppDocDir: true, initAppSupportDir: true, initStorageDir: true);
    /// 初始化微信sdk
    _initWXSDK();
    /// 初始化文件下载插件
    _initFileDownload();
    /// 初始化网络
    _initNet();
    /// 初始化bugly
    _initBugly();

    if (!mounted) return;
  }

  /// 初始化PackageInfo, SpHelper, Flutter与Native原生系统通信
  void _initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // `CFBundleVersion` on iOS, `versionCode` on Android.
    AppPackageInfo.buildNumber = packageInfo.buildNumber;
    LogUtil.e("buildNumber: "+packageInfo.buildNumber);
    // `CFBundleShortVersionString` on iOS, `versionName` on Android.
    AppPackageInfo.version = packageInfo.version;
    LogUtil.e("version: "+packageInfo.version);
    if (Platform.isAndroid) {
      LogUtil.e("app name: "+packageInfo.appName);
    }
    LogUtil.e("package name: "+packageInfo.packageName);
    AppPackageInfo.packageName = packageInfo.packageName;
  }

  /// 初始化设备信息
  void _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(_readAndroidBuildData(androidInfo).toString());
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(_readIosDeviceInfo(iosInfo).toString());
      if (iosInfo.model.toUpperCase().contains("IPAD")) {
        setDesignWHD(1024, 1366, density: 2.0);
      }
    }
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      '\nversion.securityPatch': build.version.securityPatch,
      '\nversion.sdkInt': build.version.sdkInt,
      '\nversion.release': build.version.release,
      '\nversion.previewSdkInt': build.version.previewSdkInt,
      '\nversion.incremental': build.version.incremental,
      '\nversion.codename': build.version.codename,
      '\nversion.baseOS': build.version.baseOS,
      '\nboard': build.board,
      '\nbootloader': build.bootloader,
      '\nbrand': build.brand,
      '\ndevice': build.device,
      '\ndisplay': build.display,
      '\nfingerprint': build.fingerprint,
      '\nhardware': build.hardware,
      '\nhost': build.host,
      '\nid': build.id,
      '\nmanufacturer': build.manufacturer,
      '\nmodel': build.model,
      '\nproduct': build.product,
      '\nsupported32BitAbis': build.supported32BitAbis,
      '\nsupported64BitAbis': build.supported64BitAbis,
      '\nsupportedAbis': build.supportedAbis,
      '\ntags': build.tags,
      '\ntype': build.type,
      '\nisPhysicalDevice': build.isPhysicalDevice,
      '\nandroidId': build.androidId + "\n"
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      '\nname': data.name,
      '\nsystemName': data.systemName,
      '\nsystemVersion': data.systemVersion,
      '\nmodel': data.model,
      '\nlocalizedModel': data.localizedModel,
      '\nidentifierForVendor': data.identifierForVendor,
      '\nisPhysicalDevice': data.isPhysicalDevice,
      '\nutsname.sysname:': data.utsname.sysname,
      '\nutsname.nodename:': data.utsname.nodename,
      '\nutsname.release:': data.utsname.release,
      '\nutsname.version:': data.utsname.version,
      '\nutsname.machine:': data.utsname.machine + "\n",
    };
  }

  /// 初始化本地语言
  void _initLocal() {
    SpUtil.getInstance();
    String? _saveLanguage = SpUtil.getString(Constants.keyLanguage);
    if (ObjectUtil.isNotEmpty(_saveLanguage)) {
      Map<String, dynamic> userMap = json.decode(_saveLanguage!);
      localModel = LocalModel.fromJson(userMap);
    }
    else if (localModel == null) {
      localModel = LocalModel('zh', 'CH');
      SpUtil.putObject(Constants.keyLanguage, localModel!);
    }
  }

  /// 初始化bugly
  void _initBugly() {
    FlutterBugly.init(androidAppId: "17ba09cf16",iOSAppId: "6af5c021ed").then((value) {
      LogUtil.e("####FlutterBugly#### appId: ${value.appId}, message: ${value.message}");
    });
  }

  /// 初始化网络
  void _initNet() {
    NetClient.instance.build(Configure(
      connectTimeout: 1000 * 15,
      receiveTimeout: 1000 * 30,
      sendTimeout: 1000 * 30,
      isLogPrint: true,
    ));
  }

  /// 初始化微信sdk
  void _initWXSDK() {
    // WeChatHelper.init();
  }

  /// 初始化文件下载插件
  void _initFileDownload() async {
    // if (Platform.isAndroid) {
    //   await FlutterDownloader.initialize(
    //       debug: true // optional: set false to disable printing logs to console
    //   );
    // }
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_ApplicationState: build()");
    final routes = {
      '/DecisionPage': (context, {arguments}) => DecisionPage(),// 自定义路由中间面
      '/LoginPage': (context, {arguments}) => LoginPage(),//登录页面
      '/HomePage': (context, {arguments}) => HomePage(),//主页面
    };
    // 全局变动：如切换语言
    AppLocalizationBloc? appLocalizationBloc = BlocProvider.of<AppLocalizationBloc>(context);
    return StreamBuilder<LocalModel>(
      stream: appLocalizationBloc?.appLocalizationSubjectStream,
      initialData: localModel,
      builder: (context, snapshot){
        LocalModel snap_data;
        if (snapshot.hasData && snapshot.data != null) {
          snap_data = snapshot.data!;
        } else if (localModel != null) {
          snap_data = localModel!;
        } else {
          snap_data = LocalModel('zh', 'CH');
        }
        return MaterialApp(
          // 取出右上角debug表示标识
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: _buildLightTheme(),
          darkTheme: _buildDarkTheme(),
          locale: Locale(snap_data.languageCode, snap_data.countryCode),
          localizationsDelegates: [
            // 本地化的代理类
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            CustomLocalizationsDelegate.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'), // English
            const Locale('zh', 'CH'), // Chinese
          ],
          // 在routes查找不到时，会调用该方法
          onGenerateRoute: (routeSetting) {
            var routeName = routeSetting.name;
            LogUtil.e("_ApplicationState: $routeName");
            var pageBuilder = routes[routeSetting.name];
            if (pageBuilder != null) {
              if (routeSetting.arguments != null) {
                // 创建路由页面并携带参数
                return CupertinoPageRoute(
                  builder: (context) => pageBuilder(context, arguments: routeSetting.arguments),
                  settings: RouteSettings(name: routeSetting.name),
                );
              } else {
                return CupertinoPageRoute(
                  builder: (context) => pageBuilder(context, arguments: routeSetting.arguments),
                  settings: RouteSettings(name: routeSetting.name),
                );
              }
            }
            return CupertinoPageRoute(
              builder: (context) => SplashPage(),
            );

          },
          routes: {},
          home: SplashPage(),
        );
      },
    );
  }

  ThemeData _buildDarkTheme() {
    final ThemeData base = ThemeData(
      brightness: Brightness.dark,
//      backgroundColor: ResourceColors.theme_background,
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: Brightness.dark,
      ),
    );
    return base;
  }

  ThemeData _buildLightTheme() {
    final ThemeData base = ThemeData(
        brightness: Brightness.light,
//        backgroundColor: ResourceColors.theme_background,
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.light,
        ));
    return base;
  }
}