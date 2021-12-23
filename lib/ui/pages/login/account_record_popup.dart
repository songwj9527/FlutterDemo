import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/models/login_record_model.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/widgets/customer_popup_route.dart';

class AccountRecordPopup {

  static void popupWindow(BuildContext context, List<LoginRecordModel> recordList, {void Function(LoginRecordModel)? select, void Function()? cancel}) {
    Navigator.push(context,
        CustomerPopupRoute(
          child: _PopupWindowStateful(
            recordList: recordList,
            left: ScreenUtil.getInstance().getWidth(40),
            top: ScreenUtil.getInstance().statusBarHeight
                + ScreenUtil.getInstance().getHeight(60)
                + ScreenUtil.getInstance().getWidth(85)
                + ScreenUtil.getInstance().getHeight(20)
                + ScreenUtil.getInstance().getWidth(16)
                + ScreenUtil.getInstance().getSp(16)
                + ScreenUtil.getInstance().getWidth(10)
                + ScreenUtil.getInstance().getSp(20)
                + ScreenUtil.getInstance().getWidth(4)
                + ScreenUtil.getInstance().getWidth(4)
                + ScreenUtil.getInstance().getWidth(20)
                + ScreenUtil.getInstance().getWidth(64),
            onSelected: select,
            onCancel: cancel,
          ),
        )
    );
  }
}

class _PopupWindowStateful extends StatefulWidget {
  final double left; //距离左边位置
  final double top; //距离上面位置
  final void Function()? onCancel;
  final void Function(LoginRecordModel)? onSelected; //点击item事件
  final List<LoginRecordModel> recordList;

  _PopupWindowStateful({
    required this.recordList,
    required this.left,
    required this.top,
    this.onCancel,
    this.onSelected,
  });

  @override
  State<StatefulWidget> createState() {
    return _PopupWindowState(recordList: recordList, left: left, top: top, onCancel: onCancel, onSelected: onSelected,);
  }
}

class _PopupWindowState extends State<_PopupWindowStateful> {
  final double left; //距离左边位置
  final double top; //距离上面位置
  final void Function()? onCancel;
  final void Function(LoginRecordModel)? onSelected; //点击item事件
  final List<LoginRecordModel> recordList;

  _PopupWindowState({
    required this.recordList,
    required this.left,
    required this.top,
    this.onCancel,
    this.onSelected,
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
                child: Container(
                  width: ScreenUtil.getInstance().screenWidth - ScreenUtil.getInstance().getWidth(80),
                  height: ScreenUtil.getInstance().getWidth((recordList.length >= 3 ? 180.0 : (60.0*recordList.length))),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      border: Border.all(color: ResourceColors.divider, width: 0.5)
                  ),
                  child: (recordList == null || recordList.length == 0) ? Center(child: Text("")) : ListView.separated(
                    padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().getWidth(8),
                      right: ScreenUtil.getInstance().getWidth(8),
                    ),
                    itemCount: recordList.length,
                    separatorBuilder: (ctc, index) {
                      return Divider();
                    },
                    itemBuilder: (ctx, index) {
                      return ListTile(
                        title: Text(
                          recordList[index].getUserName()??"",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: ResourceColors.gray_99,
                              fontSize: 15.0
                          ),
                        ),
                        trailing: InkWell(
                          onTap: () {
                            setState(() {
                              recordList.remove(recordList[index]);
                              //记住账号密码
                              SpUtil.putObjectList("LoginRecord", recordList);

                              if (recordList == null || recordList.length == 0) {
                                Navigator.of(ctx).pop();
                                if (onCancel != null) {
                                  onCancel!();
                                }
                              }
                            });
                          },
                          child: Icon(Icons.cancel),
                        ),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          if (onSelected != null) {
                            onSelected!(recordList[index]);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              left: left,
              top: top,
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