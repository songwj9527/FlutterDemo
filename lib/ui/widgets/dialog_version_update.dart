import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:app_installer/app_installer.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/blocs/blocs/app_update/app_update_bloc.dart';
import 'package:flutter_demo_app/blocs/blocs/app_update/app_update_event.dart';
import 'package:flutter_demo_app/blocs/blocs/app_update/app_update_state.dart';
import 'package:flutter_demo_app/blocs/widgets/bloc_state_builder.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/utils/code_util.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

const String VERSION_UODATE_DIR = "meizhiyin_version_update/";
class VersionUpdateDialog extends Dialog {
  String _linkUrl = "";
  String _version = "";
  void Function()? _onFailedCallback;
  void Function()? _onSuccessCallback;
  bool outsideDismiss = false;

  VersionUpdateDialog({
    Key? key,
    required String linkUrl,
    required String version,
    void Function()? onFailedCallback,
    void Function()? onSuccessCallback,
    bool outsideDismiss = false,
  }) : super(key: key) {
    this._linkUrl = linkUrl;
    this._version = version;
    this._onFailedCallback = onFailedCallback;
    this._onSuccessCallback = onSuccessCallback;
    this.outsideDismiss = outsideDismiss;
  }


  @override
  Widget build(BuildContext context) {
    return _DialogContent(
        linkUrl: _linkUrl,
        version: _version,
        onFailedCallback: _onFailedCallback,
        outsideDismiss: outsideDismiss
    );
  }
}

class _DialogContent extends StatefulWidget {
  String _linkUrl = "";
  String _version = "";
  void Function()? _onFailedCallback;
  void Function()? _onSuccessCallback;
  bool outsideDismiss = false;

  _DialogContent({
    required String linkUrl,
    required String version,
    void Function()? onFailedCallback,
    void Function()? onSuccessCallback,
    bool outsideDismiss = false,
  }) {
    this._linkUrl = linkUrl;
    this._version = version;
    this._onFailedCallback = onFailedCallback;
    this._onSuccessCallback = onSuccessCallback;
    this.outsideDismiss = outsideDismiss;
  }


  @override
  State<StatefulWidget> createState() {
    return _DialogContentState(
        linkUrl: _linkUrl,
        version: _version,
        onFailedCallback: _onFailedCallback,
        onSuccessCallback: _onSuccessCallback,
        outsideDismiss: outsideDismiss
    );
  }
}

class _DialogContentState extends State<_DialogContent> {
  String _linkUrl = "";
  String _version = "";
  void Function()? _onFailedCallback;
  void Function()? _onSuccessCallback;
  bool outsideDismiss = false;
  AppUpdateBloc _appUpdateBloc = AppUpdateBloc();

  _DialogContentState({
    double progress = 0.0,
    required String linkUrl,
    required String version,
    void Function()? onFailedCallback,
    void Function()? onSuccessCallback,
    bool outsideDismiss = false
  }) {
    this._linkUrl = linkUrl;
    this._version = version;
    this._onFailedCallback = onFailedCallback;
    this.outsideDismiss = outsideDismiss;
  }

  @override
  void initState() {
    super.initState();
    _appUpdateBloc.eventSink(AppUpdateEvent());

    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    _download();
  }

  _TaskInfo? _taskInfo;
  ReceivePort _port = ReceivePort();
  bool _isLoading = false;
  void _download() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    final _directory = await getExternalStorageDirectory();
    if (_directory == null) {
      return;
    }
    final _localPath = _directory.path + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.createSync();
    }
    String fileName;
    if (TextUtil.isEmpty(_version)) {
      fileName = "${CodeUtil.generateMd5(_linkUrl)}.apk";
    } else {
      fileName = "$_version.apk";
    }
    _taskInfo = _TaskInfo(name: fileName, link: _linkUrl, path: _localPath + Platform.pathSeparator + fileName );
    _taskInfo?.taskId = (await FlutterDownloader.enqueue(
      url: _linkUrl,
      savedDir: _localPath,
      fileName: fileName,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    ))??"";
    _appUpdateBloc.eventSink(AppUpdateEvent(type: AppUpdateEventType.download_start, progress: 0));
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_taskInfo != null && _taskInfo!.taskId == id) {
        if (status == DownloadTaskStatus.enqueued) {
          _appUpdateBloc.eventSink(AppUpdateEvent(type: AppUpdateEventType.download_start, progress: progress));
        }
        else if (status == DownloadTaskStatus.running) {
          _appUpdateBloc.eventSink(AppUpdateEvent(type: AppUpdateEventType.download_running, progress: progress));
        }
        else if (status == DownloadTaskStatus.complete) {
          _appUpdateBloc.eventSink(AppUpdateEvent(type: AppUpdateEventType.download_complete, progress: progress));
          AppInstaller.installApk(_taskInfo!.path);
        }
        else if (status == DownloadTaskStatus.paused) {
          _appUpdateBloc.eventSink(AppUpdateEvent(type: AppUpdateEventType.download_paused, progress: progress));
        }
        else if (status == DownloadTaskStatus.failed) {
          _appUpdateBloc.eventSink(AppUpdateEvent(type: AppUpdateEventType.download_failed, progress: progress));
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    _unbindBackgroundIsolate();
    _appUpdateBloc.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
    LogUtil.e("###### deactivate");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    LogUtil.e("###### didChangeDependencies");
  }

  @override
  void didUpdateWidget(_DialogContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    LogUtil.e("###### didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    _dismissDialog() {
      Navigator.of(context).pop();
    }
    LogUtil.e("###### build");
    return GestureDetector(
      onTap: outsideDismiss ? _dismissDialog : null,
      child: Padding(
        padding: EdgeInsets.all(scaleWidth(30.0)),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: ShapeDecoration(
                  color: Color(0xffffffff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(scaleWidth(8.0)),
                    ),
                  ),
                ),
                margin: EdgeInsets.all(scaleWidth(12.0)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(scaleWidth(10.0)),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          Center(
                            child: Text(ResourceUtil.getLocale(context) != null ? ResourceUtil.getLocale(context)!.versionUpdateTitle : "",
                              style: TextStyle(
                                fontSize: scaleSp(18.0),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (_isLoading && _taskInfo != null) {
                                FlutterDownloader.cancel(taskId: _taskInfo!.taskId);
                                FlutterDownloader.remove(taskId: _taskInfo!.taskId);
                                _taskInfo = null;
                                _isLoading = false;
                              }
                              Navigator.of(context).pop();
                              if (_onFailedCallback != null) {
                                _onFailedCallback!();
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(scaleWidth(5.0)),
                              child: Icon(
                                Icons.close,
                                color: Color(0xffe0e0e0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffe0e0e0),
                      height: 0.6,
                    ),
                    Container(
                      constraints: BoxConstraints(minHeight: scaleHeight(180.0)),
                      child: Padding(
                        padding: EdgeInsets.all(scaleWidth(12.0)),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Text(
                              //   "下载地址：" + _linkUrl,
                              //   maxLines: 4,
                              //   overflow: TextOverflow.ellipsis,
                              //   style: TextStyle(fontSize: scaleSp(14.0)),
                              // ),
                              Text(
                                "版本号：v$_version",
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: scaleSp(14.0),
                                  color: Colors.red,
                                ),
                              ),
                              Container(
                                width: scaleWidth(46),
                                height: scaleWidth(46),
                                margin: EdgeInsets.only(top: scaleWidth(30)),
                                child: BlocEventStateBuilder<AppUpdateState>(
                                    bloc: _appUpdateBloc,
                                    builder: (context, state) {
                                      return InkWell(
                                        onTap: () {
                                          if (_isLoading && _taskInfo != null) {
                                            if (state.status == AppUpdateEventType.prepare
                                                || state.status == AppUpdateEventType.download_start
                                                || state.status == AppUpdateEventType.download_running) {
                                              FlutterDownloader.pause(taskId: _taskInfo!.taskId);
                                            }
                                            else if (state.status == AppUpdateEventType.download_paused) {
                                              FlutterDownloader.resume(taskId: _taskInfo!.taskId);
                                            }
                                            else if (state.status == AppUpdateEventType.download_complete) {
                                              AppInstaller.installApk(_taskInfo!.path);
                                            }
                                            else if (state.status == AppUpdateEventType.download_failed) {
                                              FlutterDownloader.retry(taskId: _taskInfo!.taskId);
                                            }
                                          }
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              width: scaleWidth(46),
                                              height: scaleWidth(46),
                                              child: CircularProgressIndicator(
                                                value: state.progress / 100.0,
                                                strokeWidth: 5.0,
                                                backgroundColor: ResourceColors.gray_bb,
                                                valueColor: _CircleColorAnimate(Colors.lightGreen),
                                              ),
                                            ),
                                            Text(getStatus(state),
                                              style: TextStyle(
                                                fontSize: scaleSp(11.0),
                                                color: Colors.lightGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  String getStatus(AppUpdateState state) {
    String ret = "";
    switch(state.status) {
      case AppUpdateEventType.prepare:
        ret = "${state.progress}%";
        break;
      case AppUpdateEventType.download_start:
        ret = "${state.progress}";
        break;
      case AppUpdateEventType.download_running:
        ret = "${state.progress}";
        break;
      case AppUpdateEventType.download_complete:
        ret = "安装";
        break;
      case AppUpdateEventType.download_paused:
        ret = "继续";
        break;
      case AppUpdateEventType.download_failed:
      default:
        ret = "重试";
        break;
    }
    return ret;
  }
  double scaleWidth(double width) => ScreenUtil.getInstance().getAdapterSize(width);
  double scaleHeight(double height) => ScreenUtil.getInstance().getAdapterSize(height);
  double scaleSp(double sp) => ScreenUtil.getInstance().getSp(sp);
}

class _TaskInfo {
  final String name;
  final String link;
  final String path;

  String taskId = "";
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;

  _TaskInfo({required this.name, required this.link, required this.path});
}

class _CircleColorAnimate extends Animation<Color> {

  Color? _valueColor;
  _CircleColorAnimate(Color valueColor) {
    this._valueColor = valueColor;
  }

  @override
  void addListener(listener) {

  }

  @override
  void addStatusListener(listener) {

  }

  @override
  void removeListener(listener) {

  }

  @override
  void removeStatusListener(listener) {

  }

  @override
  AnimationStatus get status => AnimationStatus.forward;

  @override
  Color get value => (_valueColor != null) ? _valueColor! : ResourceColors.theme_background;

}