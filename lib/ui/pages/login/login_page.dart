import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/blocs/blocs/login_page/login_page_bloc.dart';
import 'package:flutter_demo_app/models/login_record_model.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/base/task_and_exit_state.dart';
import 'package:flutter_demo_app/utils/navigator_util.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';

import 'account_record_popup.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("LoginPage createState");

    if (Platform.isAndroid) {
//      /// 隐藏状态栏和底部按钮栏
//      SystemChrome.setEnabledSystemUIOverlays ([]);
//      /// 隐藏状态栏
//      SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
//      /// 隐藏底部按钮栏
//      SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top]);
//      /// 显示状态栏和底部按钮栏
//      SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top, SystemUiOverlay.bottom]);

      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: ResourceColors.theme_background
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    return _LoginPageState();
  }
}

class _LoginPageState<LoginPage> extends TaskAndExitState {
  late FocusNode _accountFocusNode;
  late FocusNode _passwordFocusNode;
  late TextEditingController _accountController;
  late TextEditingController _passwordController;

  late LoginPageBloc _loginPageBloc;

  List<LoginRecordModel>? _recordList;

  @override
  void initState() {
    super.initState();
    LogUtil.e("LoginPageState initState()");
    _accountFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _accountController = TextEditingController();
    _passwordController = TextEditingController();
    _loginPageBloc = LoginPageBloc();

    Future.delayed(Duration(milliseconds: 200)).then((_) {
      _checkPermission().then((_) {
        List<Map<String, dynamic>>? list = SpUtil.getObjectList("LoginRecord")?.cast<Map<String, dynamic>>();
        if (list != null && list.length > 0) {
          _recordList = list.map((value) {
            return LoginRecordModel.fromJson(value);
          }).toList();

          _accountController.text = _recordList![0].getUserAccount()??"";
          _loginPageBloc.onAccountChanged(_recordList![0].getUserAccount()??"");
          _passwordController.text = _recordList![0].getUserPwd()??"";
          _loginPageBloc.onPasswordChanged(_recordList![0].getUserPwd()??"");
        }
        LogUtil.e(_recordList == null ? "null" : _recordList.toString());
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

    List<Permission> _permissionList = [];
    /// 存储权限
    var _storageStatus = await Permission.storage.status;
    if (!_storageStatus.isGranted) {
      LogUtil.e("SplashPageState checkPermission(): storage");
      _permissionList.add(Permission.storage);
    }
    /// 相机权限
    var _cameraStatus = await Permission.camera.status;
    LogUtil.e("_cameraStatus: ${_cameraStatus}");
    if (!_cameraStatus.isGranted) {
      LogUtil.e("SplashPageState checkPermission(): camera");
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

  @override
  Widget buildChild(BuildContext context) {
    LogUtil.e("LoginPageState buildChild()");

    double _status_bar_height = 20.0;
    double _navigation_bar_height = ScreenUtil.getInstance().bottomBarHeight;
    if (ScreenUtil.getInstance().statusBarHeight > 1) {
      _status_bar_height = ScreenUtil.getInstance().statusBarHeight;
    }
    LogUtil.e("Screen",
        tag: (
            "screenWidth: ${ScreenUtil.getInstance().screenWidth}, "
                "screenHeight: ${ScreenUtil.getInstance().screenHeight}, "
                "statusBarHeight: ${ScreenUtil.getInstance().statusBarHeight}, "
                "bottomBarHeight: ${ScreenUtil.getInstance().bottomBarHeight}, "
        )
    );

    return Scaffold(
      backgroundColor: ResourceColors.theme_background,
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {
          if (_accountFocusNode.hasFocus) {
            _accountFocusNode.unfocus();
          }
          if (_passwordFocusNode.hasFocus) {
            _passwordFocusNode.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 顶部图标
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: _status_bar_height + scaleHeight(60)),
                child: Image.asset(
                    ResourceUtil.getResourceImage('ic_launcher'),
                    width: scaleWidth(85),
                    height: scaleWidth(85),
                    fit: BoxFit.fill
                ),
              ),
              // 卡片
              Card(
                margin: EdgeInsets.only(left: scaleWidth(20), top: scaleHeight(20), right: scaleWidth(20)),
                color: Colors.white,
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // welcome
                    Container(
                      margin: EdgeInsets.only(left: scaleWidth(20), top: scaleWidth(16), right: scaleWidth(20)),
                      child: Text(
                          (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.welcome : "",//ResourceUtils.getString(Ids.welcome),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.black54,
//                              fontFamily: "SourceHanSansCN",
                              fontSize: scaleSp(16)
                          )
                      ),
                    ),
                    // 登录
                    Container(
                      margin: EdgeInsets.only(left: scaleWidth(20), top: scaleWidth(10), right: scaleWidth(20)),
                      child: Text(
                        (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.login : "",//ResourceUtils.getString(Ids.login),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black,
//                              fontFamily: "SourceHanSansCN",
                            fontWeight: FontWeight.w400,
                            fontSize: scaleSp(20)
                        ),
                      ),
                    ),
                    // 蓝色标签
                    Container(
                      margin: EdgeInsets.only(left: scaleWidth(20), top: scaleWidth(4), right: scaleWidth(20)),
                      width: scaleWidth(20),
                      height: scaleWidth(4),
                      color: ResourceColors.theme_background,
                    ),
                    // 账号
                    Container(
                      margin: EdgeInsets.only(left: scaleWidth(20), top: scaleWidth(20), right: scaleWidth(20)),
                      height: scaleWidth(46),
                      child: Stack(
                        children: <Widget>[
                          // 文本编辑
                          Container(
                            height: scaleWidth(46),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: scaleWidth(10), right: scaleWidth(42)),
                            child: StreamBuilder<String>(
                                stream: _loginPageBloc.account,
                                builder: (ctx, snapshot) {
                                  return TextField(
                                    controller: _accountController,
                                    focusNode: _accountFocusNode,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(fontSize: scaleSp(14), color: ResourceColors.gray_33),
                                    decoration: InputDecoration(
                                        icon: Image.asset(
                                            ResourceUtil.getResourceImage('icon_account'),
                                            width: scaleWidth(28),
                                            height: scaleWidth(28),
                                            fit: BoxFit.fill
                                        ),
                                        border: InputBorder.none,
                                        hintText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.inputAccount : "",
                                        hintStyle: TextStyle(fontSize: scaleSp(14))
                                    ),
                                    onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
                                    onChanged: _loginPageBloc.onAccountChanged,
                                  );
                                }
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(color: ResourceColors.divider, width: 1)
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            height: scaleWidth(46),
                            child: StreamBuilder<bool>(
                              stream: _loginPageBloc.record,
                              builder: (ctx, snapshot) {
                                return InkWell(
                                  onTap: () {
                                    if (_accountFocusNode.hasFocus) {
                                      _accountFocusNode.unfocus();
                                    }
                                    if (_passwordFocusNode.hasFocus) {
                                      _passwordFocusNode.unfocus();
                                    }

                                    if (_recordList == null || _recordList!.length == 0) {
                                      return;
                                    }

                                    _loginPageBloc.onAccountRecordChanged((snapshot.hasData) ? !(snapshot.data??false) : true);
                                    AccountRecordPopup.popupWindow(
                                        context,
                                        _recordList!,
                                        select: (item){
                                          if (item != null) {
                                            _accountController.text = item.getUserAccount()??"";
                                            _passwordController.text = item.getUserPwd()??"";
                                            _loginPageBloc.onAccountChanged(item.getUserAccount()??"");
                                            _loginPageBloc.onPasswordChanged(item.getUserPwd()??"");
                                          }
                                          _loginPageBloc.onAccountRecordChanged(false);
                                        },
                                        cancel: () {
                                          _loginPageBloc.onAccountRecordChanged(false);
                                        }
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: scaleWidth(4)),
                                    padding: EdgeInsets.all(scaleWidth(6)),
                                    child: Image.asset(
                                        ResourceUtil.getResourceImage(((snapshot.hasData) ? (snapshot.data??false) : false) ? 'icon_more_up' : 'icon_more_down'),
                                        width: scaleWidth(26),
                                        height: scaleWidth(26),
                                        color: Colors.grey,
                                        fit: BoxFit.fill
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 密码
                    Container(
                      margin: EdgeInsets.only(left: scaleWidth(20), top: scaleWidth(20), right: scaleWidth(20)),
                      height: scaleWidth(46),
                      child: Stack(
                        children: <Widget>[
                          // 文本编辑
                          Container(
                            height: scaleWidth(46),
                            padding: EdgeInsets.only(left: scaleWidth(10), right: scaleWidth(42)),
                            child: StreamBuilder<bool>(
                                stream: _loginPageBloc.passwordObscure,
                                builder: (context1, snapshot1) {
                                  return StreamBuilder<String>(
                                      stream: _loginPageBloc.password,
                                      builder: (context2, snapshot2) {
                                        return TextField(
                                          controller: _passwordController,
                                          focusNode: _passwordFocusNode,
                                          textInputAction: TextInputAction.done,
                                          style: TextStyle(fontSize: scaleSp(14), color: ResourceColors.gray_33),
                                          decoration: InputDecoration(
                                              icon: Image.asset(
                                                  ResourceUtil.getResourceImage('icon_password'),
                                                  width: scaleWidth(28),
                                                  height: scaleWidth(28),
                                                  fit: BoxFit.fill
                                              ),
                                              border: InputBorder.none,
                                              hintText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.inputPassword : "",
                                              hintStyle: TextStyle(fontSize: scaleSp(14))
                                          ),
                                          obscureText: !(snapshot1.hasData && (snapshot1.data??false)),
                                          onChanged: _loginPageBloc.onPasswordChanged,
                                        );
                                      }
                                  );
                                }
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                border: Border.all(color: ResourceColors.divider, width: 1)
                            ),
                          ),
                          Container(
                            height: scaleWidth(46),
                            alignment: Alignment.centerRight,
                            child: StreamBuilder<bool>(
                                stream: _loginPageBloc.passwordObscure,
                                builder: (ctx, snapshot) {
                                  return InkWell(
                                    onTap: () {
                                      if (_accountFocusNode.hasFocus) {
                                        _accountFocusNode.unfocus();
                                      }
                                      _loginPageBloc.onPasswordObscureChanged((snapshot.hasData) ? !(snapshot.data??false) : true);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: scaleWidth(4)),
                                      padding: EdgeInsets.all(scaleWidth(8)),
                                      child: Image.asset(
                                          ResourceUtil.getResourceImage((snapshot.hasData && (snapshot.data??false)) ? 'icon_open_eye' : 'icon_close_eye'),
                                          width: scaleWidth(22),
                                          height: scaleWidth(22),
                                          fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 登录按钮
                    Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(scaleWidth(30), scaleWidth(30), scaleWidth(30), scaleWidth(30)),
                        child: StreamBuilder<bool>(
                            stream: _loginPageBloc.loginValid,
                            builder: (ctx, snapshot) {
                              return Ink(
                                decoration: BoxDecoration(
                                  color: (snapshot.hasData && (snapshot.data??false)) ? ResourceColors.theme_background : Color(0xFFBBCDE7),
                                  gradient: (snapshot.hasData && (snapshot.data??false)) ? LinearGradient(colors: [Color(0xBB2978FC), Color(0xDD2978FC), Color(0xFF2978FC)], begin: FractionalOffset(0, 1), end: FractionalOffset(1, 0)) : null,
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                  onTap: () {
                                    if (_accountFocusNode.hasFocus) {
                                      _accountFocusNode.unfocus();
                                    }
                                    if (_passwordFocusNode.hasFocus) {
                                      _passwordFocusNode.unfocus();
                                    }
                                    if (snapshot.hasData && (snapshot.data??false)) {
                                      _login(_accountController.text, _passwordController.text);
                                    } else{
                                      if (_accountController.text == null || _accountController.text.length == 0) {
                                        ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.inputAccount : "");
                                        return;
                                      }
                                      if (_passwordController.text == null || _passwordController.text.length == 0) {
                                        ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.inputPassword : "");
                                        return;
                                      }
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.fromLTRB(scaleWidth(10), scaleWidth(10), scaleWidth(10), scaleWidth(10)),
                                    child: Text(
                                      (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.login : "",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: scaleSp(16),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(left: scaleWidth(25), right: scaleWidth(25)),
                height: scaleWidth(8),
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(4.0), bottomRight: Radius.circular(4.0))
                ),
              ),
              // 公司名称
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(
                    left: scaleWidth(10),
                    top: (ScreenUtil.getInstance().screenHeight
                        - _navigation_bar_height
                        - _status_bar_height
                        - scaleHeight(60)
                        - scaleWidth(85)
                        - scaleHeight(20)
                        - scaleWidth(16)
                        - scaleSp(16)
                        - scaleWidth(10)
                        - scaleSp(20)
                        - scaleWidth(4)
                        - scaleWidth(4)
                        - scaleWidth(20)
                        - scaleWidth(46)
                        - scaleWidth(20)
                        - scaleWidth(46)
                        - scaleWidth(27)
                        - scaleWidth(30)
                        - scaleWidth(10)
                        - scaleWidth(16)
                        - scaleWidth(10)
                        - scaleWidth(30)
                        - scaleWidth(8)
                        - scaleSp(12)
                        - scaleHeight(40)
                    ),
                    right: scaleWidth(10)),
                child: Text(
                  (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.appCompanyName : "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xFFE4EDFF),
//                        fontFamily: "SourceHanSansCN",
                      fontSize: scaleSp(12)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double scaleWidth(double width) => ScreenUtil.getInstance().getWidth(width);
  double scaleHeight(double height) => ScreenUtil.getInstance().getHeight(height);
  double scaleSp(double sp) => ScreenUtil.getInstance().getSp(sp);

  void _login(final String account, final String password) {
    if (TextUtil.isEmpty(account)) {
      ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.inputAccount : "");
      return;
    }
    if (TextUtil.isEmpty(password)) {
      ToastUtil.showToast((ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.inputPassword : "");
      return;
    }

    showLoadingDialog(outsideDismiss: false);
    removeTaskAndToken("login");
    try {
      var _subscription = Future.delayed(Duration(seconds: 2)).asStream()
          .listen((event) {
        removeTaskAndToken("login");
        List<LoginRecordModel> list = <LoginRecordModel>[];
        LoginRecordModel userRecord = LoginRecordModel(account, account, password, 123456);
        list.add(userRecord);

        //检测本地数据是否有本次输入信息
        if (_recordList != null && _recordList!.length > 0) {
          for (LoginRecordModel info in _recordList!) {
            if ((info.getUserAccount()??"").compareTo(account) != 0) {
              list.add(info);
            }
          }
        }
        //记住账号密码
        SpUtil.putObjectList("LoginRecord", list);
        //保存用户信息
        SpUtil.putObject("UserInfo", event.Result!.toJson());
        //保存用户是否正在登录状态
        SpUtil.putBool("IsLogin", true);

        dismissLoadingDialog();
        _goHomePage();
      });
    } catch (e) {
      LogUtil.e(">>>>> ${e.toString()}");
      dismissLoadingDialog();
    }
  }

  @override
  void dispose() {
    _loginPageBloc.dispose();
    super.dispose();
    if (_accountFocusNode.hasFocus) {
      _accountFocusNode.unfocus();
    }
    if (_passwordFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
    _accountFocusNode.dispose();
    _passwordFocusNode.dispose();
    _accountController.dispose();
    _passwordController.dispose();
  }

  void _goHomePage() {
    // DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
    // decisionPageBloc?.eventSink(DecisionPageEvent(type: DecisionPageEventType.HomePage));
    NavigatorUtil.pushNamedAndRemoveUntil(context, '/HomePage');
  }

}