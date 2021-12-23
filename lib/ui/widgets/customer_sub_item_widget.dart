import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

enum SubItemType {
  DEFAULT,
  ENTER,
  EDIT,
  SWITCH,
  SELECT,
}

class SubItemData {
  SubItemData({
    this.type,
    this.backgroundColor,
    this.iconData,
    this.iconColor,
    this.iconSize,
    this.title,
    this.titleTextStyle,
    this.content,
    this.contentStyle,
  });
  SubItemType? type;
  Color? backgroundColor;
  IconData? iconData;
  Color? iconColor;
  double? iconSize;
  String? title;
  TextStyle? titleTextStyle;
  String? content;
  TextStyle? contentStyle;
}

class CustomerSubItemWidget extends StatelessWidget {
  final SubItemData? itemData;
  final void Function(SubItemData?)? onItemClick;
  const CustomerSubItemWidget({Key? key, this.itemData, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onItemClick != null) {
          onItemClick!(itemData);
        }
      },
      child: _buildItemWidget(),
    );
  }

  Widget _buildItemWidget() {
    if (itemData == null) {
      return Container();
    }
    if (itemData?.type != null && itemData?.type == SubItemType.ENTER) {
      if (itemData?.iconData == null) {
        return Container(
          color: itemData?.backgroundColor??Colors.transparent,
          padding: EdgeInsets.fromLTRB(
              ScreenUtil.getInstance().getWidth(18.0),
              ScreenUtil.getInstance().getAdapterSize(14.0),
              ScreenUtil.getInstance().getWidth(8.0),
              ScreenUtil.getInstance().getAdapterSize(14.0)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(itemData?.title??"",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: itemData?.titleTextStyle??TextStyle(
                      fontSize: ScreenUtil.getInstance().getSp(14.0),
                      color: ResourceColors.gray_33,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(itemData?.content??"",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: itemData?.contentStyle??TextStyle(
                            fontSize: ScreenUtil.getInstance().getSp(14.0),
                            color: ResourceColors.gray_99,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right, color: ResourceColors.divider),
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        color: itemData?.backgroundColor??Colors.transparent,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil.getInstance().getWidth(18.0),
            ScreenUtil.getInstance().getAdapterSize(14.0),
            ScreenUtil.getInstance().getWidth(8.0),
            ScreenUtil.getInstance().getAdapterSize(14.0)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Icon(itemData?.iconData,
                      size: itemData?.iconSize??ScreenUtil.getInstance().getSp(20.0),
                      color: itemData?.iconColor??ResourceColors.gray_66,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().getWidth(8.0),
                      ),
                      child: Text(itemData?.title??"",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: itemData?.titleTextStyle??TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_33,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(itemData?.content??"",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: itemData?.contentStyle??TextStyle(
                          fontSize: ScreenUtil.getInstance().getSp(14.0),
                          color: ResourceColors.gray_99,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: ResourceColors.divider),
                ],
              ),
            ),
          ],
        ),
      );
    }
    else {
      return Container(
        color: itemData?.backgroundColor??Colors.transparent,
        alignment: Alignment.center,
        padding: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(14.0)),
        child: Text(itemData?.title??"",
          style: itemData?.titleTextStyle??TextStyle(
            fontSize: ScreenUtil.getInstance().getSp(14.0),
            color: ResourceColors.gray_33,
          ),
        ),
      );
    }
  }

}