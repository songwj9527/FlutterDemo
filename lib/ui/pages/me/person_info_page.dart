import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/models/login_record_model.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/base/task_controller_state.dart';
import 'package:flutter_demo_app/ui/pages/common/crop_image_page.dart';
import 'package:flutter_demo_app/ui/widgets/customer_app_bar.dart';
import 'package:flutter_demo_app/ui/widgets/dialog_account_record.dart';
import 'package:flutter_demo_app/ui/widgets/dialog_bottom_choose_photo.dart';
import 'package:flutter_demo_app/utils/dialog_util.dart';
import 'package:flutter_demo_app/utils/navigator_util.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';
import 'package:image_picker/image_picker.dart';

class PersonInfoPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("PersonInfoPage: createState()");
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: ResourceColors.gray_background,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    return _PersonInfoPageState();
  }
}

class _PersonInfoPageState extends TaskControllerState<PersonInfoPage> {
  final _imagePicker = ImagePicker();
  bool _changed = false;
  bool _exchangeAccount = false;

  Future<bool> _onWillPop() {
    LogUtil.e("_PersonInfoPageState: _onWillPop()");
    if (_changed || _exchangeAccount) {
      if (_exchangeAccount) {
        // DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
        // decisionPageBloc?.eventSink(DecisionPageEvent(type: DecisionPageEventType.HomePage));
        // Navigator.of(context).pushReplacementNamed('/DecisionPage');
        NavigatorUtil.pushNamedAndRemoveUntil(context, "/HomePage");
      } else {
        Navigator.pop(context, true);
      }
    } else {
      Navigator.pop(context);
    }
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    List<Map<String, dynamic>>? list = SpUtil.getObjectList("LoginRecord")?.cast<Map<String, dynamic>>();
    if (list != null && list.length > 0) {
      _recordList = list.map((value) {
        return LoginRecordModel.fromJson(value);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_PersonInfoPageState: build()");
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: CustomerAppBar(
          backgroundColor: ResourceColors.theme_background,
          titleContent: '个人基本信息',
          automaticallyImplyLeading: true,//是否返回按钮
          onWillPop: _onWillPop,
        ),
        backgroundColor: ResourceColors.gray_background,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 个人头像
              InkWell(
                onTap: () {
                  if (Platform.isAndroid) {
                    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: Colors.transparent,
                    );
                    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
                  }
                  DialogUtil.showBottomDialog<SelectType>(context, BottomChooosePhototDialog()).then((value) {
                    if (Platform.isAndroid) {
                      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
                        statusBarColor: Colors.transparent,
                        systemNavigationBarColor: ResourceColors.gray_background,
                      );
                      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
                    }
                    if (value != null) {
                      if (value == SelectType.photo) {
                        _pickHeadImage();
                      }
                      else if (value == SelectType.camera) {
                        _cameraHeadImage();
                      }
                    }
                  });
                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    top: ScreenUtil.getInstance().getHeight(8.0),
                    bottom: ScreenUtil.getInstance().getHeight(8.0),
                    left: ScreenUtil.getInstance().getWidth(18.0),
                    right: ScreenUtil.getInstance().getWidth(7.0),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('头像',
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {

                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: CachedNetworkImage(
                                  imageUrl: "http://img95.699pic.com/photo/50057/7197.jpg_wh300.jpg",
                                  width: ScreenUtil.getInstance().getWidth(42.0),
                                  height: ScreenUtil.getInstance().getWidth(42.0),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                  errorWidget: (context, url, error) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 姓名
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getAdapterSize(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getAdapterSize(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("姓名",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("--",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 联系电话
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getWidth(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getWidth(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("联系电话",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("暂无",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 身高
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getWidth(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getWidth(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("身高",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("暂无",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 体重
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getWidth(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getWidth(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("体重",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("暂无",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 性别
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getWidth(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getWidth(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("性别",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("暂无",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 出生年月
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getWidth(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getWidth(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("出生年月",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("暂无",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1.0,
                color: ResourceColors.divider,
              ),
              // 电子邮箱
              InkWell(
                onTap: () {

                },
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil.getInstance().getWidth(18.0),
                      ScreenUtil.getInstance().getWidth(14.0),
                      ScreenUtil.getInstance().getWidth(7.0),
                      ScreenUtil.getInstance().getWidth(14.0)
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("电子邮箱",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(8.0)),
                                alignment: Alignment.centerRight,
                                child: Text("暂无",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    color: ResourceColors.gray_99,
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: ResourceColors.divider),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(16.0),
                  right: ScreenUtil.getInstance().getWidth(16.0),
                  top: ScreenUtil.getInstance().getHeight(40.0),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      _logout();
                    },
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(11.0)),
                      alignment: Alignment.center,
                      child: Text("退出登录",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(16.0),
                  right: ScreenUtil.getInstance().getWidth(16.0),
                  top: ScreenUtil.getInstance().getAdapterSize(10.0),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      _showAccount();
                    },
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(11.0)),
                      alignment: Alignment.center,
                      child: Text("切换账号",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(16.0),
                  right: ScreenUtil.getInstance().getWidth(16.0),
                  top: ScreenUtil.getInstance().getAdapterSize(10.0),
                  bottom: ScreenUtil.getInstance().getHeight(20.0),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {

                    },
                    child: Container(
                      padding: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(11.0)),
                      alignment: Alignment.center,
                      child: Text("修改密码",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _cameraHeadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File _image = File(pickedFile.path);
      if (await _image.exists()) {
        NavigatorUtil.pushPage<File>(context, CropImagePage(_image))?.then((value) {
          if (value != null) {
            value.exists().then((exists) {
              if (exists) {
                ToastUtil.showToast("上传");
              }
            });
          }
        });
      }
    } else {
      LogUtil.e('No image selected.');
    }
  }

  void _pickHeadImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File _image = File(pickedFile.path);
      if (await _image.exists()) {
        NavigatorUtil.pushPage<File>(context, CropImagePage(_image))?.then((value) {
          if (value != null) {
            value.exists().then((exists) {
              if (exists) {
                ToastUtil.showToast("上传");
              }
            });
          }
        });
      }
    } else {
      LogUtil.e('No image selected.');
    }
  }

  void _logout() {
    showLoadingDialog(outsideDismiss: false);
    removeTaskAndToken("logout");
    var _cancelToken = CancelToken();
    var _subscription = Future.delayed(Duration(seconds: 2)).asStream()
        .listen((event) {
      removeTaskAndToken("logout");
      if (event == null) {
        dismissLoadingDialog();
        return;
      }
      if (event.Code != 0) {
        dismissLoadingDialog();
        if (event.Code == -200) {
          _toLoginPage();
        }
        ToastUtil.showToast(event.Message??"");
        return;
      }
      dismissLoadingDialog();
      _toLoginPage();
    });
    addTaskAndToken("logout", _subscription, _cancelToken);
  }

  void _toLoginPage() {
    //清除登录用户信息
    SpUtil.putObject("UserInfo", "");
    //清除用户正在登录状态
    SpUtil.putBool("IsLogin", false);

    // DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
    // decisionPageBloc?.eventSink(DecisionPageEvent(type: DecisionPageEventType.LoginPage));
    NavigatorUtil.pushNamedAndRemoveUntil(context, "/LoginPage");
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: ResourceColors.theme_background,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  void _showAccount() {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    DialogUtil.showBottomDialog<LoginRecordModel>(context, AccountRecordDialog()).then((value) {
      if (Platform.isAndroid) {
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: ResourceColors.gray_background,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
      if (value != null) {
        _changeAccount(value);
      }
    });
  }

  List<LoginRecordModel>? _recordList;
  void _changeAccount(LoginRecordModel account) {
    showLoadingDialog(outsideDismiss: false);
    removeTaskAndToken("_changeAccount");
    var _cancelToken = CancelToken();
    var _subscription = Future.delayed(Duration(seconds: 2)).asStream()
        .listen((event) {
      removeTaskAndToken("_changeAccount");
      if (event == null) {
        dismissLoadingDialog();
        return;
      }
      if (event.Code != 0) {
        dismissLoadingDialog();
        ToastUtil.showToast(event.Message??"");
        return;
      }
      if (event.Result == null) {
        dismissLoadingDialog();
        ToastUtil.showToast(event.Message??"");
        return;
      }
      List<LoginRecordModel> list = <LoginRecordModel>[];
      account.TXID = event.Result!.user!.TXID!;
      list.add(account);

      //检测本地数据是否有本次输入信息
      if (_recordList != null && _recordList!.length > 0) {
        for (LoginRecordModel info in _recordList!) {
          if ((info.getUserAccount()??"").compareTo((account.getUserAccount()??"")) != 0) {
            list.add(info);
          }
        }
      }
      //记住账号密码
      SpUtil.putObjectList("LoginRecord", list);
      //保存用户信息
      SpUtil.putObject("UserInfo", event.Result!.toJson());

      dismissLoadingDialog();
      setState(() {
        _changed = true;
        _exchangeAccount = true;
      });
    });
    addTaskAndToken("_changeAccount", _subscription, _cancelToken);
  }
}