import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'circular_progress_bar.dart';

class WebView extends StatefulWidget {
  String url;
  _WebViewState? _webViewState;

  WebView(this.url);

  @override
  State<StatefulWidget> createState() {
    return (_webViewState = _WebViewState());
  }

  void hide() {
    _webViewState?.hide();
  }

  void show() {
    _webViewState?.show();
  }
}

class _WebViewState extends State<WebView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //监听URL的改变
  StreamSubscription<String>? _onUrlChanged;
  //监听WebView的状态改变
  StreamSubscription<WebViewStateChanged>? _onStateChanged;
  //监听WebView的错误状态
  StreamSubscription<WebViewHttpError>? _onHttpError;
  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close(); //关闭页面 防止重新打开
    _onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      LogUtil.e("onStateChanged: ${state.type.toString()}");
      switch (state.type) {
        case WebViewState.shouldStart:
          // 准备加载
          break;
        case WebViewState.startLoad:
          // 开始加载
          break;
        case WebViewState.finishLoad:
          // 加载完成
          break;
        case WebViewState.abortLoad:
          break;
      }
    });
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((event) {
      LogUtil.e("onUrlChanged: $event");
    });
    _onHttpError = flutterWebViewPlugin.onHttpError.listen((event) {
      LogUtil.e("onHttpError: ${event.code}");
    });
  }

  void show() {
    flutterWebViewPlugin.show();
  }

  void hide() {
    flutterWebViewPlugin.hide();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_WebViewState: ${widget.url}");
    // WebviewScaffold是插件提供的组件，用于在页面上显示一个WebView并加载URL
    return WebviewScaffold(
      key: scaffoldKey,
      url: widget.url, //加载的URL
      withZoom: true, //允许缩放
      withLocalStorage: true, //本地缓存
      allowFileURLs: true,//bool 是否允许请求本地的FileURL
      withJavascript: true, // 允许执行js代码
      useWideViewPort: true, //适应屏幕
      withOverviewMode: true,
      initialChild: Center(
        child: CircularProgressBar(
          width: ScreenUtil.getInstance().getAdapterSize(20.0),
          height: ScreenUtil.getInstance().getAdapterSize(20.0),
          accentColor: Theme.of(context).accentColor,
        ),
      ),
    );
    // return WebviewScaffold(
    //   key: scaffoldKey,
    //   url: "https://www.baidu.com/", //加载的URL
    //   withZoom: true, //允许缩放
    //   withLocalStorage: true, //本地缓存
    //   allowFileURLs: true,//bool 是否允许请求本地的FileURL
    //   withJavascript: true, // 允许执行js代码
    //   useWideViewPort: true, //适应屏幕
    //   // withOverviewMode: true,
    //   initialChild: Center(
    //     child: CircularProgressBar(
    //       width: ScreenUtil.getInstance().getAdapterSize(20.0),
    //       height: ScreenUtil.getInstance().getAdapterSize(20.0),
    //       accentColor: Theme.of(context).accentColor,
    //     ),
    //   ),
    // );
  }

  @override
  void dispose() {
    // 销毁web view源
    _onUrlChanged?.cancel();
    _onStateChanged?.cancel();
    _onHttpError?.cancel();
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}