import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';

class CustomerAppBar extends AppBar {
  bool automaticallyImplyLeading = true;
  TextStyle? titleStyle;
  String? titleContent = "";
  void Function()? onWillPop;
  String? rightAction = "";
  TextStyle? rightActionStyle;
  void Function()? onRightTap;

  CustomerAppBar({
    Key? key,
    Color? backgroundColor,
    this.titleContent,
    this.titleStyle,
    this.automaticallyImplyLeading = true,
    this.onWillPop,
    this.rightAction,
    this.rightActionStyle,
    this.onRightTap,
    List<Widget>? actions,
  }) : super(
    key: key,
    backgroundColor: backgroundColor,
    actions: _initActions(rightAction, onRightTap, rightActionStyle, actions),
    leading: automaticallyImplyLeading ? IconButton(
      iconSize: ScreenUtil.getInstance().getSp(18.0),
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        if (onWillPop != null) {
          onWillPop();
        }
      },
    ) : null,
    automaticallyImplyLeading: false,//是否显示默认的返回按钮
    centerTitle: true,
    title: Text(titleContent??"",
      style: titleStyle??TextStyle(
        fontSize: ScreenUtil.getInstance().getSp(18.0),
      ),
    ),
  );

  static List<Widget>? _initActions(String? rightAction, void Function()? onRightTap, TextStyle? rightActionStyle, List<Widget>? actions) {
    if (rightAction != null && rightAction.length > 0) {
      if (actions != null) {
        actions.add(
            Container(
              margin: EdgeInsets.only(right: ScreenUtil.getInstance().getAdapterSize(7.0)),
              child: Ink(
                decoration: BoxDecoration(
//                shape: BoxShape.circle,
                  borderRadius: BorderRadius.all(Radius.circular(Size.fromHeight(kToolbarHeight).height / 2)), // ScreenUtil.getInstance().getAdapterSize(26.0)
                  color: Colors.transparent,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(Size.fromHeight(kToolbarHeight).height / 2)),
                  onTap: onRightTap,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().getAdapterSize(11.0),
                      right: ScreenUtil.getInstance().getAdapterSize(11.0),
                    ),
                    child: Text(rightAction,
                      style: rightActionStyle??TextStyle(
                        fontSize: ScreenUtil.getInstance().getSp(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            )
        );
        return actions;
      }
      return [
        Container(
          margin: EdgeInsets.only(right: ScreenUtil.getInstance().getAdapterSize(7.0)),
          child: Ink(
            decoration: BoxDecoration(
//                shape: BoxShape.circle,
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().getAdapterSize(26.0))),
              color: Colors.transparent,
            ),
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().getAdapterSize(26.0))),
              onTap: onRightTap,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getAdapterSize(11.0),
                  right: ScreenUtil.getInstance().getAdapterSize(11.0),
                ),
                child: Text(rightAction,
                  style: rightActionStyle??TextStyle(
                    fontSize: ScreenUtil.getInstance().getSp(15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ];
    }
    return actions;
  }
}