import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

class CircularProgressBar extends Container {

  CircularProgressBar({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    Clip clipBehavior = Clip.none,
    Color accentColor = ResourceColors.theme_background,
    double strokeWidth = 4.0,
  }) : super(
    key: key,
    alignment: alignment,
    padding: padding,
    color: color,
    decoration: decoration,
    foregroundDecoration: foregroundDecoration,
    width: width,
    height: height,
    constraints: constraints,
    margin: margin,
    transform: transform,
    clipBehavior: clipBehavior,
//     child: CircularProgressIndicator(
//       strokeWidth: strokeWidth,
//       valueColor: _CircleColorAnimate(accentColor),
// //                    backgroundColor: circularProgressColor ?? Theme.of(context).backgroundColor,
//     ),
    child: ((width??0) > 0 || (height??0) > 0) ? CupertinoActivityIndicator(radius: (width??0) > (height??0) ? (width??0) / 2 : (height??0) / 2,) : CupertinoActivityIndicator(),
  );

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
  Color get value => _valueColor??Colors.white;

}