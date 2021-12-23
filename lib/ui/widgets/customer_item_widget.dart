import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

import 'customer_sub_item_widget.dart';

enum ItemType {
  TITLE,
  DIVIDER,
}

class ItemData {
  ItemData({
    this.itemType = ItemType.DIVIDER,
    this.isShow = false,
    this.iconData,
    this.title,
    this.titleTextStyle,
    this.backgroundColor,
    this.subItemData,
    this.divider,
  });
  ItemType? itemType;
  bool? isShow = false;
  IconData? iconData;
  String? title;
  TextStyle? titleTextStyle;
  Color? backgroundColor;
  List<SubItemData>? subItemData;
  Divider? divider;
}

class CustomerItemWidget extends StatelessWidget {

  final ItemData? itemData;
  final void Function(SubItemData?)? onItemClick;
  const CustomerItemWidget({Key? key, this.itemData, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.e("CustomerItemWidget: build()");
    if (itemData == null) {
      return Container();
    }
    if (itemData!.itemType != null && itemData!.itemType! == ItemType.DIVIDER) {
      if (itemData!.subItemData == null || itemData!.subItemData!.length == 0) {
        if (!((itemData!.isShow)??false)) {
          return Container();
        }
        return Container(
          color: (itemData!.backgroundColor)??Colors.transparent,
//              width: ScreenUtil.getInstance().screenWidth,
          height: ScreenUtil.getInstance().getAdapterSize(12.0),
        );
      }
      if (!((itemData!.isShow)??false)) {
        return Container(
          color: (itemData!.subItemData != null && itemData!.subItemData!.length > 0) ? ((itemData!.subItemData![0].backgroundColor)??Colors.transparent) : Colors.transparent,
          child: ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: (itemData!.subItemData == null) ? 0 : itemData!.subItemData!.length,
            itemBuilder: (context, position) {
              return CustomerSubItemWidget(itemData: itemData!.subItemData![position], onItemClick: onItemClick);
            },
            separatorBuilder: (context, position) {
              return (itemData!.divider) ?? Divider(
                height: 1.0,
                color: ResourceColors.divider,
              );
            },
          ),
        );
      }
      return Container(
        color: (itemData!.subItemData != null && itemData!.subItemData!.length > 0) ? ((itemData!.subItemData![0].backgroundColor)??Colors.transparent) : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: (itemData!.backgroundColor)??Colors.transparent,
              height: ScreenUtil.getInstance().getAdapterSize(12.0),
            ),
            ListView.separated(
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: itemData!.subItemData == null ? 0 : itemData!.subItemData!.length,
              itemBuilder: (context, position) {
                return CustomerSubItemWidget(itemData: itemData!.subItemData![position], onItemClick: onItemClick);
              },
              separatorBuilder: (context, position) {
                return (itemData!.divider) ?? Divider(
                  height: 1.0,
                  color: ResourceColors.divider,
                );
              },
            ),
          ],
        ),
      );
    }

    if (itemData!.subItemData == null || itemData!.subItemData!.length == 0) {
      if (!((itemData!.isShow)??false)) {
        return Container();
      }
      return Container(
        color: (itemData!.backgroundColor)??Colors.transparent,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil.getInstance().getWidth(16.0),
            ScreenUtil.getInstance().getAdapterSize(12.0),
            ScreenUtil.getInstance().getWidth(16.0),
            ScreenUtil.getInstance().getAdapterSize(6.0)
        ),
        child: Text(itemData!.title??"",
          style: itemData!.titleTextStyle??TextStyle(
            fontSize: ScreenUtil.getInstance().getSp(15.0),
            color: ResourceColors.gray_33,
          ),
        ),
      );
    }
    if (!((itemData!.isShow)??false)) {
      return Container(
        color: (itemData!.subItemData != null && itemData!.subItemData!.length > 0) ? ((itemData!.subItemData![0].backgroundColor)??Colors.transparent) : Colors.transparent,
        child: ListView.separated(
          padding: const EdgeInsets.all(0.0),
          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
          physics: NeverScrollableScrollPhysics(),//禁用滑动事件
          scrollDirection: Axis.vertical,
          itemCount: itemData!.subItemData == null ? 0 : itemData!.subItemData!.length,
          itemBuilder: (context, position) {
            return CustomerSubItemWidget(itemData: itemData!.subItemData![position], onItemClick: onItemClick);
          },
          separatorBuilder: (context, position) {
            return itemData!.divider ?? Divider(
              height: ScreenUtil.getInstance().getAdapterSize(0.6),
              color: ResourceColors.divider,
            );
          },
        ),
      );
    }
    return Container(
      color: (itemData!.subItemData != null && itemData!.subItemData!.length > 0) ? (itemData!.subItemData![0].backgroundColor??Colors.transparent) : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: itemData!.backgroundColor??Colors.transparent,
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().getWidth(16.0),
                ScreenUtil.getInstance().getAdapterSize(12.0),
                ScreenUtil.getInstance().getWidth(16.0),
                ScreenUtil.getInstance().getAdapterSize(6.0)
            ),
            child: Text(itemData!.title??"",
              style: itemData!.titleTextStyle??TextStyle(
                fontSize: ScreenUtil.getInstance().getSp(15.0),
                color: ResourceColors.gray_33,
              ),
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.all(0.0),
            shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
            physics: NeverScrollableScrollPhysics(),//禁用滑动事件
            scrollDirection: Axis.vertical,
            itemCount: itemData!.subItemData == null ? 0 : itemData!.subItemData!.length,
            itemBuilder: (context, position) {
              return CustomerSubItemWidget(itemData: itemData!.subItemData![position], onItemClick: onItemClick);
            },
            separatorBuilder: (context, position) {
              return itemData!.divider ?? Divider(
                height: ScreenUtil.getInstance().getAdapterSize(0.6),
                color: ResourceColors.divider,
              );
            },
          ),
        ],
      ),
    );
  }
}