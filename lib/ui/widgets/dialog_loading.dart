import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'circular_indicator.dart';

class LoadingDialog extends Dialog {
  String? loadingText;
  Color? textColor;
  double textSize;
  Color? dialogBackgroundColor;
  Color? circularProgressColor;
  Color? circularProgressBackgroundColor;
  bool outsideDismiss;
  void Function()? dismissCallback;
  void Function()? dismissMethod;
  bool? isShow = true;

  LoadingDialog(
      {Key? key,
        this.loadingText = "",
        this.textColor,
        this.textSize = 16.0,
        this.dialogBackgroundColor,
        this.circularProgressColor,
        this.circularProgressBackgroundColor,
        this.outsideDismiss = true,
        this.dismissCallback,
      }) : super(key: key);

  bool get isShown => (isShow != null && isShow!);

  void dismiss() {
    if (!isShown) {
      return;
    }
    isShow = false;
    if (dismissMethod != null) {
      dismissMethod!();
    }
  }

  @override
  Widget build(BuildContext context) {
    isShow = true;
    _dismissDialog() {
      isShow = false;
      Navigator.of(context).pop();
      if (dismissCallback != null) {
        dismissCallback!();
      }
    }
    dismissMethod = _dismissDialog;

    return GestureDetector(
      onTap: outsideDismiss ? _dismissDialog : null,
      child: Material(
        type: MaterialType.transparency,
        child: Center(
          child: SizedBox(
            width: scaleWidth(140.0),
            height: scaleWidth(140.0),
            child: Container(
              decoration: ShapeDecoration(
                color: dialogBackgroundColor?? Color(0xB0000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(scaleWidth(8.0)),
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: (loadingText != null && loadingText!.length > 0) ?
                [
                  // CircularProgressBar(
                  //   margin: EdgeInsets.only(top: scaleWidth(8.0)),
                  //   width: scaleWidth(30.0),
                  //   height: scaleWidth(30.0),
                  //   accentColor: circularProgressColor ?? Theme.of(context).accentColor,
                  // ),
                  Container(
                    margin: EdgeInsets.only(top: scaleWidth(8.0)),
                    width: scaleWidth(30.0),
                    height: scaleWidth(30.0),
                    child: CircularIndicator(
                      indicatorRadius: scaleWidth(15.0),
                      indicatorColor: CupertinoDynamicColor.withBrightness(
                        color: Color(0xFFFFFFFF),
                        darkColor: Color(0xFFEBEBF5),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: scaleHeight(20.0), left: scaleWidth(8.0), right: scaleWidth(8.0)),
                    child: Text(
                      loadingText??"",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: scaleSp(textSize),
                          color: textColor ?? Colors.white),
                    ),
                  ),
                ]
                    :
                [
                  // CircularProgressBar(
                  //   width: scaleWidth(30.0),
                  //   height: scaleWidth(30.0),
                  //   accentColor: circularProgressColor ?? Theme.of(context).accentColor,
                  // ),
                  CircularIndicator(
                    indicatorRadius: scaleWidth(15.0),
                    indicatorColor: CupertinoDynamicColor.withBrightness(
                      color: Color(0xFFFFFFFF),
                      darkColor: Color(0xFFEBEBF5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double scaleWidth(double width) => ScreenUtil.getInstance().getWidth(width);
  double scaleHeight(double height) => ScreenUtil.getInstance().getHeight(height);
  double scaleSp(double sp) => ScreenUtil.getInstance().getSp(sp);
}