import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/ui/pages/base/task_and_exit_state.dart';
import 'package:flutter_demo_app/ui/widgets/dialog_version_update.dart';
import 'package:flutter_demo_app/utils/dialog_util.dart';
import 'package:flutter_demo_app/utils/navigator_util.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';


class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    LogUtil.e("SplashPage createState()");
    return _SplashPageState();
  }

}

class _SplashPageState extends TaskAndExitState<SplashPage> {
  TimerUtil? _timerUtil;

  @override
  void initState() {
    super.initState();
    LogUtil.e("_SplashPageState initState()");
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      _checkPermission().then((_) {
        // if (Platform.isAndroid) {
        //  // _showAppUpdateDialog("https://fs.fgrid.io/download/apk/latest/app-release.apk", '1.1.1');
        //   _checkAppVersion();
        // } else {
        //   _startTimer();
        // }
        _checkAppVersion();
      });
    });
  }

  // 权限检测
  Future _checkPermission() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // Android 6.0及以上版本才可以动态申请权限
      if (androidInfo.version.sdkInt < 23) {
        return;
      }
    }

    List<Permission> _permissionList = <Permission>[];
    /// 存储权限
    var _storageStatus = await Permission.storage.status;
    if (!_storageStatus.isGranted) {
      LogUtil.e("_SplashPageState checkPermission(): storage");
      _permissionList.add(Permission.storage);
    }
    /// 相机权限
    var _cameraStatus = await Permission.camera.status;
    if (!_cameraStatus.isGranted) {
      LogUtil.e("_SplashPageState checkPermission(): camera");
      _permissionList.add(Permission.camera);
    }
    /// 相册权限(ios)
    if (Platform.isIOS) {
      var _photosStatus = await Permission.photos.status;
      LogUtil.e("_photosStatus: ${_photosStatus}");
      if (!_photosStatus.isGranted) {
        LogUtil.e("SplashPageState checkPermission(): photos");
        _permissionList.add(Permission.photos);
      }
    }
    if (_permissionList.length > 0) {
      Map<Permission, PermissionStatus> _statusResult = await _permissionList
          .request();
      _statusResult.forEach((permission, status) {
        if (permission == Permission.storage) {
          if (!status.isGranted) {
            ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.notHaveStoragePermission : "");
          }
        } else if (permission == Permission.camera) {
          if (!status.isGranted) {
            ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.notHaveCameraPermission : "");
          }
        } else if (Platform.isIOS && permission == Permission.photos) {
          if (!status.isGranted) {
            ToastUtil.showToast("请打开相册权限");
          }
        }
        // openAppSettings();
      });
    }
  }

  void _checkAppVersion() {
//     CancelToken cancelToken = CancelToken();
//     var streamSubscription = VersionApi.getAppOnlineVersion(cancelToken: cancelToken).listen((event) {
//       removeTaskAndToken("getAppOnlineVersion");
//       if (event == null) {
//         _showDialog(context: context,
//             dialog: MessageDialog(
//                 title: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.versionUpdateTitle : "",
//                 message: "版本检测失败，请检查网络。",
//                 positiveText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.sure : "",
//                 outsideDismiss: false,
// //            onPositivePressEvent: ()=> exit(0),
//                 onPositivePressEvent: () async {
//                   await exitSystem();
//                 }
//             )
//         );
//         return;
//       }
//       if (event.Code != 0) {
//         ToastUtil.showToast("${event.Message}");
//         _goJump();
//         return;
//       }
//       if (event.Result == null || event.Result!.client == null) {
//         ToastUtil.showToast("暂无版本信息");
//         _goJump();
//         return;
//       }
//       ApplicationBean? applicationBean = null;
//       if (Platform.isIOS) {
//         applicationBean = event.Result!.client?.ios;
//       } else {
//         applicationBean = event.Result!.client?.android;
//       }
//       if (applicationBean == null) {
//         ToastUtil.showToast("暂无版本信息");
//         _goJump();
//         return;
//       }
//       if (Platform.isAndroid) {
//         if (TextUtil.isEmpty(applicationBean.XZDZ)) {
//           _goJump();
//           return;
//         }
//       }
//       String version = applicationBean.XBBH??"";
//       if (TextUtil.isEmpty(version)) {
//         _goJump();
//         return;
//       }
//       PackageInfo.fromPlatform().then((value) {
//         if (value == null) {
//           _goJump();
//           return;
//         }
//         var splitOnline = version.split(".");
//         var splitCurrent = value.version.split(".");
//         if (splitOnline == null || splitOnline.length == 0 || splitCurrent == null || splitCurrent.length == 0) {
//           _goJump();
//           return;
//         }
//         var judgeEndIndex = splitOnline.length > splitCurrent.length ? splitCurrent.length : splitOnline.length;
//         var isOnlineLengthOver = splitOnline.length > splitCurrent.length;
//         var onlineNew = false;
//         for (int index = 0; index < judgeEndIndex; index++) {
//           if (splitOnline[index].compareTo(splitCurrent[index]) > 0) {
//             onlineNew = true;
//             break;
//           } else if (splitOnline[index].compareTo(splitCurrent[index]) < 0) {
//             break;
//           }
//         }
//         // 是否当前版本低于最新版本，是，则去判断当前版本低于最低版本。
//         if (onlineNew || isOnlineLengthOver) {
//           if (!TextUtil.isEmpty(applicationBean!.ZDBBH)) {
//             var splitMin = applicationBean.ZDBBH!.split(".");
//             var judgeEndIndex2 = splitMin.length > splitCurrent.length ? splitCurrent.length : splitMin.length;
//             var isMinLengthOver = splitMin.length > splitCurrent.length;
//             var isMinNew = false;
//             for (int index = 0; index < judgeEndIndex2; index++) {
//               if (splitMin[index].compareTo(splitCurrent[index]) > 0) {
//                 isMinNew = true;
//                 break;
//               } else if (splitMin[index].compareTo(splitCurrent[index]) < 0) {
//                 break;
//               }
//             }
//             // 是否当前低于最低版本，是，则升级；否则不用强制更新。
//             if (isMinNew || isMinLengthOver) {
//               // 升级
//               if (Platform.isIOS) {
//                 AppInstaller.goStore("", "1538100261");
//               } else {
//                 _showAppUpdateDialog(applicationBean.XZDZ??"", applicationBean.XBBH??"");
//               }
//             } else {
//               _goJump();
//               return;
//             }
//           } else {
//             // 升级
//             if (Platform.isIOS) {
//               AppInstaller.goStore("", "1538100261");
//             } else {
//               _showAppUpdateDialog(applicationBean.XZDZ??"", applicationBean.XBBH??"");
//             }
//           }
//         } else {
//           _goJump();
//           return;
//         }
//       });
//     });
//     addTaskAndToken("getAppOnlineVersion", streamSubscription, cancelToken);
    var streamSubscription = Future.delayed(Duration(seconds: 1)).asStream().listen((event) {
      removeTaskAndToken("getAppOnlineVersion");
      _goJump();
    });

  }

  // 版本更新安装弹框
  void _showAppUpdateDialog(String download, String version) {
    _showDialog(context: context,
        dialog: VersionUpdateDialog(
          linkUrl: download,
          version: version,
          onFailedCallback: () {
            exitSystem();
          },
          outsideDismiss: false,
        )
    );
  }

  // 展示弹框
  void _showDialog({required BuildContext context, required Dialog dialog}) {
    DialogUtil.showCustomerDialog(context, dialog, outsideDismiss: false, backPressEnable: false);
  }

  @override
  void dispose() {
    _timerUtil?.cancel();
    _timerUtil = null;
    super.dispose();
  }

  @override
  Widget buildChild(BuildContext context) {
    LogUtil.e("_SplashPageState buildChild()");
    double _status_bar_height = 20.0;
    double _navigation_bar_height = ScreenUtil.getInstance().bottomBarHeight;
    if (ScreenUtil.getInstance().statusBarHeight > 1) {
      _status_bar_height = ScreenUtil.getInstance().statusBarHeight;
    }
    LogUtil.e("_SplashPageState",
        tag: (
                "screenWidth: ${ScreenUtil.getInstance().screenWidth}, "
                "screenHeight: ${ScreenUtil.getInstance().screenHeight}, "
                    "screenDensity: ${ScreenUtil.getInstance().screenDensity}, "
                "statusBarHeight: ${ScreenUtil.getInstance().statusBarHeight}, "
                "bottomBarHeight: ${ScreenUtil.getInstance().bottomBarHeight}, "
        )
    );

    return Scaffold(
      backgroundColor: const Color(0xFF107F42),
      body: Stack(
          children: <Widget>[
            _buildSplashBg(_status_bar_height, _navigation_bar_height),
          ]
      ),
    );
  }

  // 绘制闪屏页背景
  Widget _buildSplashBg(double _status_bar_height, double _navigation_bar_height) {
    Widget ret;
    if (Platform.isIOS) {
      if (_status_bar_height > 26) {
        ret = Container(
          // margin: EdgeInsets.only(top: _status_bar_height, bottom: _navigation_bar_height),
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            ResourceUtil.getResourceImage('launch_background_large'),
            fit: BoxFit.contain,
          ),
        );
      } else {
        ret = Container(
          // margin: EdgeInsets.only(top: _status_bar_height),
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            ResourceUtil.getResourceImage('launch_background'),
            fit: BoxFit.cover,
          ),
        );
      }
    } else if (_status_bar_height > 26) {
      ret = Container(
        margin: EdgeInsets.only(
          // top: _status_bar_height > _navigation_bar_height ? _status_bar_height : _navigation_bar_height,
          // bottom: _status_bar_height > _navigation_bar_height ? _status_bar_height : _navigation_bar_height,
          left: 12,
          right: 12,
        ),
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          ResourceUtil.getResourceImage('launch_background'),
          fit: BoxFit.scaleDown,
        ),
      );
    } else {
      ret = Container(
        margin: EdgeInsets.only(top: _status_bar_height > _navigation_bar_height ? _status_bar_height : _navigation_bar_height, bottom: _status_bar_height > _navigation_bar_height ? _status_bar_height : _navigation_bar_height),
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          ResourceUtil.getResourceImage('launch_background'),
          fit: BoxFit.scaleDown,
        ),
      );
    }
    return ret;
  }

  // 跳转页面
  void _goJump() {
    _startTimer();
  }

  // 开始2秒跳转页面倒计时
  void _startTimer() {
    _timerUtil = TimerUtil(mTotalTime: 2 * 1000);
    _timerUtil?.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      if (_tick == 0) {
        _timerUtil?.cancel();
        _timerUtil = null;
        _goLoginPage();
      }
    });
    _timerUtil?.startCountDown();
  }

  // 进入主页
  void _goMainPage() {
    // DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
    // decisionPageBloc?.eventSink(DecisionPageEvent(type: DecisionPageEventType.HomePage));
    // Navigator.of(context).pushReplacementNamed('/DecisionPage');
    NavigatorUtil.pushNamedAndRemoveUntil(context, "/HomePage");
  }

  // 进入登录页面
  void _goLoginPage() {
    if (_timerUtil != null) {
      _timerUtil?.cancel();
      _timerUtil = null;
    }
    // DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
    // decisionPageBloc?.eventSink(DecisionPageEvent(type: DecisionPageEventType.LoginPage));
    // Navigator.of(context).pushReplacementNamed('/DecisionPage');
    NavigatorUtil.pushNamedAndRemoveUntil(context, "/LoginPage");
  }
}