import 'package:flutter/material.dart';

class CustomerPopupWindowStateful extends StatefulWidget {
  final Widget? child;
  final double? left; //距离左边位置
  final double? top; //距离上面位置
  final Function? onCancel;
  final Function? onSelected; //点击item事件

  CustomerPopupWindowStateful({
    @required this.child,
    this.left,
    this.top,
    this.onCancel,
    this.onSelected
  });

  @override
  State<StatefulWidget> createState() {
    return _PopupWindowState();
  }
}

class _PopupWindowState extends State<CustomerPopupWindowStateful> {

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
                child: (widget.child)??Container(),
//                onTap: () {
//                  if (onSure != null) {
//                    Navigator.of(context).pop();
//                    onSure();
//                  }
//                },
              ),
              left: (widget.left)??0.0,
              top: (widget.top)??0.0,
            ),
          ],
        ),
        onTap: () { //点击空白处
          Navigator.of(context).pop();
          if (widget.onCancel != null) {
            widget.onCancel!();
          }
        },
      ),
    );
  }
}