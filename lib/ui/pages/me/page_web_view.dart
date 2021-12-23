import 'dart:async';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rxdart/rxdart.dart';

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  String news_url = "https://www.baidu.com/";
  String title = "Title";

  // 标记是否是加载中
  bool loading = true;
  BehaviorSubject<bool> _loadingController = BehaviorSubject<bool>();

  // 标记当前页面是否是我们自定义的回调页面
  bool isLoadingCallbackPage = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // URL变化监听器
  StreamSubscription<String>? onUrlChanged;

  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged>? onStateChanged;

  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
          switch (state.type) {
            case WebViewState.shouldStart:
            // 准备加载
              setState(() {
                loading = true;
              });
              break;
            case WebViewState.startLoad:
            // 开始加载
              break;
            case WebViewState.finishLoad:
            // 加载完成
              setState(() {
                loading = false;
              });
              if (isLoadingCallbackPage) {
                // 当前是回调页面，则调用js方法获取数据
                parseResult();
              }
              break;
            case WebViewState.abortLoad:
              break;
          }
        });
  }

  // 解析WebView中的数据
  void parseResult() {
//    flutterWebViewPlugin.evalJavascript("get();").then((result) {
//      // result json字符串，包含token信息
//
//    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(
      title,
      style: TextStyle(color: Colors.white),
    ));
    if (loading) {
      // 如果还在加载中，就在标题栏上显示一个圆形进度条
      titleContent.add(CupertinoActivityIndicator());
    }
    titleContent.add(Container(width: 50.0));
    // WebviewScaffold是插件提供的组件，用于在页面上显示一个WebView并加载URL
    return WebviewScaffold(
      key: scaffoldKey,
      url: news_url,
      // 登录的URLß
      appBar: AppBar(
        title: StreamBuilder<bool>(
          stream: _loadingController.stream,
          builder: (context, snapshot) {
            List<Widget> titleContent = [];
            titleContent.add(Text(
              title,
              style: TextStyle(color: Colors.white),
            ));
            if (snapshot != null && snapshot.hasData && (snapshot.data??false)) {
              // 如果还在加载中，就在标题栏上显示一个圆形进度条
              titleContent.add(CupertinoActivityIndicator());
            }
            titleContent.add(Container(width: 50.0));
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: titleContent,
            );
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      withZoom: true,
      // 允许网页缩放
      withLocalStorage: true,
      // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }

  @override
  void dispose() {
    // 回收相关资源
    // Every listener should be canceled, the same should be done with this stream.
    onUrlChanged?.cancel();
    onStateChanged?.cancel();
    _loadingController.close();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }
}