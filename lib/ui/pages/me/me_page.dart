import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/wechat/wechat_helper.dart';
import 'package:flutter_demo_app/network/constants.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/base/task_controller_state.dart';
import 'package:flutter_demo_app/ui/widgets/customer_item_widget.dart';
import 'package:flutter_demo_app/ui/widgets/customer_sub_item_widget.dart';
import 'package:flutter_demo_app/utils/dialog_util.dart';
import 'package:flutter_demo_app/utils/navigator_util.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';
import 'package:wechat_kit/wechat_kit.dart';

import 'dialog_share_app.dart';
import 'person_info_page.dart';

class MePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("MePage: createState()");
    return _MePageState();
  }

}

class _MePageState extends TaskControllerState<MePage> {
  double statusBarHeight = ScreenUtil.getInstance().statusBarHeight;
  List<ItemData> itemData = [];

  @override
  void initState() {
    super.initState();
    LogUtil.e("_MePageState: initState()");
    if (statusBarHeight < 20) {
      statusBarHeight = ScreenUtil.getInstance().getHeight(30.0);
    }

    itemData = [
      ItemData(
        itemType: ItemType.DIVIDER,
        isShow: false,
        backgroundColor: ResourceColors.gray_background,
        divider: Divider(
          height: 1.0,
          indent: ScreenUtil.getInstance().getWidth(18.0),
          color: ResourceColors.divider,
        ),
        subItemData: [
          SubItemData(
            type: SubItemType.ENTER,
            backgroundColor: Colors.white,
            iconData: Icons.monetization_on,
            iconColor: Colors.cyan,
            title: 'XXXX-001',
          ),
          SubItemData(
            type: SubItemType.ENTER,
            backgroundColor: Colors.white,
            iconData: Icons.attach_money,
            iconColor: Colors.lightGreen,
            title: 'XXXX-002',
          ),
        ],
      ),
      ItemData(
        itemType: ItemType.DIVIDER,
        isShow: true,
        backgroundColor: ResourceColors.gray_background,
        subItemData: [
          SubItemData(
            type: SubItemType.ENTER,
            backgroundColor: Colors.white,
            iconData: Icons.verified_user,
            iconColor: Colors.redAccent,
            title: 'XXXX-003',
            content: "BABA",
          ),
          SubItemData(
            type: SubItemType.ENTER,
            backgroundColor: Colors.white,
            iconData: Icons.folder_open,
            iconColor: Colors.orangeAccent,
            title: 'XXXX-004',
          ),
          SubItemData(
            type: SubItemType.ENTER,
            backgroundColor: Colors.white,
            iconData: Icons.share,
            iconColor: Colors.green,
            title: '分享',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_MePageState: build()");

    return Scaffold(
      backgroundColor: ResourceColors.gray_background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: ResourceColors.theme_background,
            child: // 个人信息
            Container(
              margin: EdgeInsets.only(top: statusBarHeight + ScreenUtil.getInstance().getHeight(18.0), bottom: ScreenUtil.getInstance().getHeight(14.0)),
              height: ScreenUtil.getInstance().getWidth(50.0),
              child: InkWell(
                onTap: () {
                  NavigatorUtil.pushPage<bool>(context, PersonInfoPage())?.then((value) {
                    if (value != null && value) {
                      setState(() {

                      });
                    }
                  });
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(18.0)),
                      child: Container(
                        width: ScreenUtil.getInstance().getAdapterSize(50.0),
                        height: ScreenUtil.getInstance().getAdapterSize(50.0),
                        margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(18.0),),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(ScreenUtil.getInstance().getAdapterSize(50.0) / 2.0 - 0.5),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(ResourceUtil.getResourceImage('icon_default')),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil.getInstance().getWidth(10.0),
                              bottom: ScreenUtil.getInstance().getAdapterSize(2.0),
                            ),
                            child: Text("-",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(16.0),
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: ScreenUtil.getInstance().getWidth(10.0),
                            ),
                            child: Text('-',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(13.0),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(ScreenUtil.getInstance().getWidth(7.0)),
                      child: Icon(Icons.chevron_right, color: Colors.white, size: ScreenUtil.getInstance().getSp(26.0),),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemCount: itemData.length,
              itemBuilder: (context, position) {
                return CustomerItemWidget(itemData: itemData[position], onItemClick: onItemClick);
              },
            ),
          ),
        ],
      ),
    );
  }

  void onItemClick(SubItemData? subItemData) {
    if (subItemData == null) {
      return;
    }
    if ("${subItemData.title}".compareTo('分享') == 0) {
      // NavigatorUtil.pushPage(context, ShareToAgentPage());
      DialogUtil.showBottomDialog<ReturnType>(context, ShareAppDialog()).then((type) {
        if (type != null) {
          if (type == ReturnType.SHARE_FRIENDS) {
            _shareApp(scene: WechatScene.SESSION);
          }
          else if (type == ReturnType.SHARE_SQUARE) {
            _shareApp(scene: WechatScene.TIMELINE);
          }
        }
      });
    } else {
      ToastUtil.showToast(subItemData.title??"");
    }
  }

  StreamSubscription<WechatSdkResp>? shareAppSubscription;
  void _shareApp({scene: WechatScene.SESSION}) {
    // shareAppSubscription?.cancel();
    // if (shareAppSubscription != null) {
    //   shareAppSubscription?.cancel();
    //   removeTask("_shareApp");
    //   shareAppSubscription = null;
    // }
    // shareAppSubscription = WeChatHelper.getInstance().setShareListener((value) {
    //
    // });
    // addTask("_shareApp", shareAppSubscription!);
    // WeChatHelper.getInstance().shareWebPage(Constants.APP_H5_URL(), scene: scene, title: "梅之音代理APP");
  }
}