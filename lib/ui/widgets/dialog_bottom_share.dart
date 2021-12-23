import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

enum SelectType {
  friends,
  square,
}

class BottomShareDialog extends StatelessWidget {
  ScreenUtil screenUtil = ScreenUtil.getInstance();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: screenUtil.getAdapterSize(140.0) + screenUtil.bottomBarHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().getAdapterSize(12.0),
                ScreenUtil.getInstance().getAdapterSize(18.0),
                ScreenUtil.getInstance().getAdapterSize(12.0),
                ScreenUtil.getInstance().getAdapterSize(18.0),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, SelectType.friends);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people, color: Colors.lightGreen, size: screenUtil.getSp(28.0),),
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil.getInstance().getAdapterSize(6.0)),
                            child: Text('微信好友',
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(13.0),
                                color: ResourceColors.gray_66,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, SelectType.square);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera, color: Colors.deepPurple, size: screenUtil.getSp(28.0),),
                          Container(
                            margin: EdgeInsets.only(top: ScreenUtil.getInstance().getAdapterSize(6.0)),
                            child: Text('朋友圈',
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(13.0),
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 0.8,
            color: ResourceColors.divider,
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: ScreenUtil.getInstance().bottomBarHeight),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().getAdapterSize(12.0),
                  ScreenUtil.getInstance().getAdapterSize(12.0),
                  ScreenUtil.getInstance().getAdapterSize(12.0),
                  ScreenUtil.getInstance().getAdapterSize(12.0),
                ),
                alignment: Alignment.center,
                child: Text('取消'),
              ),
            ),
          ),
        ],
      ),
    );
  }

}