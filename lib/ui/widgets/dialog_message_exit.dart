import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class ExitMessageDialog extends Dialog {
  String? title;
  String? message;
  String? negativeText;
  String? positiveText;
  void Function()? onNegativePressEvent;
  void Function()? onPositivePressEvent;
  bool outsideDismiss;
  void Function()? dismissMethod;
  bool? isShow = true;

  ExitMessageDialog({
    Key? key,
    this.title,
    this.message,
    this.negativeText,
    this.positiveText,
    this.onNegativePressEvent,
    this.onPositivePressEvent,
    this.outsideDismiss = true
  }) : super(key: key);

  bool get isShown => (isShow != null && isShow!);

  void dismiss() {
    if (!isShown) {
      return;
    }
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
      if (onNegativePressEvent != null) {
        onNegativePressEvent!();
      }
    }
    dismissMethod = _dismissDialog;

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
                            child: Text(
                              title??"",
                              style: TextStyle(
                                fontSize: scaleSp(18.0),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              isShow = false;
                              Navigator.of(context).pop();
                              if (onNegativePressEvent!= null) {
                                onNegativePressEvent!();
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
                      constraints: BoxConstraints(minHeight: scaleHeight(140.0)),
                      child: Padding(
                        padding: EdgeInsets.all(scaleWidth(12.0)),
                        child: IntrinsicHeight(
                          child: Text(
                            message??"",
                            style: TextStyle(fontSize: scaleSp(16.0)),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xffe0e0e0),
                      height: 0.6,
                    ),
                    this._buildBottomButtonGroup(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _buildBottomButtonGroup(BuildContext context) {
    var widgets = <Widget>[];
    if (negativeText != null && negativeText!.isNotEmpty) {
      widgets.add(_buildBottomNegativeButton(context));
    }
    if ((negativeText != null && negativeText!.isNotEmpty) && (positiveText != null && positiveText!.isNotEmpty)) {
      widgets.add(Expanded(flex: 0, child: Container(color: Color(0xffe0e0e0), width: 0.6)));
    }
    if (positiveText != null && positiveText!.isNotEmpty) {
      widgets.add(_buildBottomPositiveButton(context));
    }
    return Container(
        height: scaleHeight(46.0),
        child: Flex(direction: Axis.horizontal, children: widgets,)
    );
  }

  Widget _buildBottomNegativeButton(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
        height: scaleHeight(46.0),
        onPressed: () {
          isShow = false;
          Navigator.of(context).pop();
          if (onNegativePressEvent!= null) {
            onNegativePressEvent!();
          }
        },
        child: Text(
          negativeText??"",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: scaleSp(16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomPositiveButton(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: FlatButton(
        height: scaleHeight(46.0),
        onPressed: () {
          isShow = false;
          Navigator.of(context).pop();
          if (onPositivePressEvent != null) {
            onPositivePressEvent!();
          }
        },
        child: Text(
          positiveText??"",
          style: TextStyle(
            color: Colors.cyan,
            fontSize: scaleSp(16.0),
          ),
        ),
      ),
    );
  }

  double scaleWidth(double width) => ScreenUtil.getInstance().getWidth(width);
  double scaleHeight(double height) => ScreenUtil.getInstance().getHeight(height);
  double scaleSp(double sp) => ScreenUtil.getInstance().getSp(sp);
}