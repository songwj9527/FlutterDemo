import 'dart:async';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_app/common/event_bus/event_bus_helper.dart';
import 'package:flutter_demo_app/common/event_bus/token_timeout_event.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/material_square/material_square_page.dart';
import 'package:flutter_demo_app/ui/pages/me/me_page.dart';
import 'package:flutter_demo_app/ui/pages/team/team_page.dart';
import 'package:flutter_demo_app/ui/pages/work/work_page.dart';
import 'package:flutter_demo_app/utils/navigator_util.dart';

import '../base/double_click_exit_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("HomePage: createState()");

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
          systemNavigationBarColor: Colors.transparent
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
    /// 显示状态栏和底部按钮栏
    SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    return _HomePageState();
  }
}

class _HomePageState extends DoubleClickExitState<HomePage> with SingleTickerProviderStateMixin {
  int currentBottomBarIndex = 0;
  List<Widget> _bottomBarContentViews = [MaterialSquarePage(), TeamPage(), WorkPage(), MePage()];
  StreamSubscription<TokenTimeoutEvent>? _tokenStreamSubscription;

  @override
  void initState() {
    super.initState();
    LogUtil.e("_HomePageState: initState()");
    _tokenStreamSubscription =  EventBusHelper.instance.on<TokenTimeoutEvent>().listen((event) {
      //清除登录用户信息
      SpUtil.putObject("UserInfo", "");

      // DecisionPageBloc? decisionPageBloc = BlocProvider.of<DecisionPageBloc>(context);
      // decisionPageBloc?.eventSink(DecisionPageEvent(type: DecisionPageEventType.LoginPage));
      NavigatorUtil.pushNamedAndRemoveUntil(context, '/LoginPage');
      if (Platform.isAndroid) {
        SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: ResourceColors.theme_background,
        );
        SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      }
    });
  }

  @override
  void dispose() {
    _tokenStreamSubscription?.cancel();
    super.dispose();
    LogUtil.e("_HomePageState: dispose()");
  }

  @override
  Widget buildChild(BuildContext context) {
    LogUtil.e("_HomePageState: buildChild()");

    return Scaffold(
      backgroundColor: Colors.white,
      // body: _bottomBarContentViews[currentBottomBarIndex],
      body: IndexedStack(
        children: _bottomBarContentViews,
        index: currentBottomBarIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == this.currentBottomBarIndex) {
            return;
          }
          setState(() {
            currentBottomBarIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentBottomBarIndex,
        selectedItemColor: ResourceColors.theme_background,
        unselectedItemColor: Colors.black38,
        selectedFontSize: ScreenUtil.getInstance().getSp(12.0),
        unselectedFontSize: ScreenUtil.getInstance().getSp(12.0),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.camera),
            label: '素材',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.people),
            label: '团队',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.apps),
            label: '工作',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.account_box),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
