import 'package:flutter/material.dart';

//滑动效果
class SlidePageRouteBuilder<T> extends PageRouteBuilder<T> {
  final Widget widget;
  final int duration;
  SlidePageRouteBuilder({required this.widget, this.duration = 500, RouteSettings? settings}) : super(
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder:(context, animation1, animation2) {
      return widget;
    },
    transitionsBuilder:(context, animation1, animation2, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(CurvedAnimation(
          parent: animation1,
          curve: Curves.fastOutSlowIn,
        )),
        child: child,

      );
    },
    settings: settings,
  );
}

//渐变效果
class FadePageRouteBuilder extends PageRouteBuilder {
  final Widget widget;
  final int duration;
  FadePageRouteBuilder({required this.widget, this.duration = 500, RouteSettings? settings}) : super(
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder:(context, animation1, animation2) {
      return widget;
    },
    transitionsBuilder:(context, animation1, animation2, child) {
      return FadeTransition(
        opacity: Tween(begin:0.0, end :2.0).animate(CurvedAnimation(
          parent:animation1,
          curve:Curves.fastOutSlowIn,
        )),
        child: child,
      );
    },
    settings: settings,
  );
}


//缩放效果
class ZoomPageRouteBuilder extends PageRouteBuilder {
  final Widget widget;
  final int duration;
  ZoomPageRouteBuilder({required this.widget, this.duration = 500, RouteSettings? settings}) : super(
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder:(context, animation1, animation2) {
      return widget;
    },
    transitionsBuilder:( context, animation1, animation2, child) {
      return ScaleTransition(
        scale:Tween(begin:0.0,end:1.0).animate(CurvedAnimation(
            parent:animation1,
            curve: Curves.fastOutSlowIn
        )),
        child:child,
      );
    },
    settings: settings,
  );
}


//旋转+缩放效果
class RotateZoomPageRouteBuilder extends PageRouteBuilder {
  final Widget widget;
  final int duration;
  RotateZoomPageRouteBuilder({required this.widget, this.duration = 500, RouteSettings? settings}) : super(
    transitionDuration: Duration(milliseconds: duration),
    pageBuilder:(context, animation1, animation2){
      return widget;
    },
    transitionsBuilder:(context, animation1,  animation2, child) {
      return RotationTransition(
          turns:Tween(begin:0.0,end:1.0)
              .animate(CurvedAnimation(
              parent: animation1,
              curve: Curves.fastOutSlowIn
          )),
          child:ScaleTransition(
            scale:Tween(begin: 0.0, end:1.0).animate(CurvedAnimation(
                parent: animation1,
                curve:Curves.fastOutSlowIn
            )),
            child: child,
          )
      );
    },
    settings: settings,
  );
}