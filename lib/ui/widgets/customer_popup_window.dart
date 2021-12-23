import 'package:flutter/material.dart';

class CustomerPopupWindow extends StatelessWidget {
  final Widget? child;
  final double? left; //距离左边位置
  final double? top; //距离上面位置
  final Function? onCancel;
  final Function? onSelected; //点击item事件

  CustomerPopupWindow({
    this.child,
    this.left,
    this.top,
    this.onCancel,
    this.onSelected
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
            Positioned(
              child: GestureDetector(
                child: child??Container(),
//                onTap: () {
//                  if (onSure != null) {
//                    Navigator.of(context).pop();
//                    onSure();
//                  }
//                },
              ),
              left: left??0.0,
              top: top??0.0,
            ),
          ],
        ),
        onTap: () { //点击空白处
          Navigator.of(context).pop();
          if (onCancel != null) {
            onCancel!();
          }
        },
      ),
    );
  }
}