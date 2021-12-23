import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

class ModuleItem {
  String? name;
  Icon? icon;
  Color? color;
  int? count;
  void Function(ModuleItem)? onItemClick;
}

class ModuleItemWidget extends StatelessWidget {

  final ModuleItem itemData;

  const ModuleItemWidget({Key? key, required this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.e("ModuleItemWidget: build()");

    return InkWell(
      onTap: () {
        if (itemData.onItemClick != null) {
          itemData.onItemClick!(itemData);
        }
      },
      child: Container(
        child: Stack(
          children: (itemData.count != null && itemData.count! > 0) ?
          [
            Container(
              margin: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(4.0)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemData.icon??Container(),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(6.0)),
                    child: Text(itemData.name??"null",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().getSp(12.0),
                        color: ResourceColors.gray_33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4.0),
                child: Text('${itemData.count}', style: TextStyle(fontSize: ScreenUtil.getInstance().getSp(6), color: Colors.white)),
              ),
            ),
          ]
              :
          [
            Container(
              margin: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(4.0)),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemData.icon??Container(),
                  Container(
                    margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(6.0)),
                    child: Text(itemData.name??"null",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ScreenUtil.getInstance().getSp(12.0),
                        color: ResourceColors.gray_33,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}