import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

import 'module_item_widget.dart';

class ModuleClassification {
  String? name;
  List<ModuleItem>? modules;
}

class ModuleClassificationWidget extends StatelessWidget {
  final double marginTop;
  final double marginBottom;
  final ModuleClassification? itemData;

  const ModuleClassificationWidget({Key? key, this.itemData, this.marginTop = 0.0, this.marginBottom = 0.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.e("ModuleClassificationWidget: build()");
    return Container(
      margin: EdgeInsets.only(
        top: marginTop > 0.0 ? marginTop : 0,
        bottom: marginBottom > 0.0 ? marginBottom : 0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 标签
              Container(
                width: ScreenUtil.getInstance().getAdapterSize(4.0),
                height: ScreenUtil.getInstance().getAdapterSize(16.0),
                margin: EdgeInsets.only(left: ScreenUtil.getInstance().getWidth(18.0)),
                decoration: BoxDecoration(
                  color: ResourceColors.theme_background,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
              ),
              // 标签名
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: ScreenUtil.getInstance().getWidth(8.0),
                      right: ScreenUtil.getInstance().getWidth(18.0),
                      bottom: Platform.isIOS ? 0 : ScreenUtil.getInstance().getAdapterSize(1.0),
                  ),
                  child: Text(
                    itemData == null ? 'title' : itemData?.name??'title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.getInstance().getSp(14.0),
                        fontWeight: FontWeight.w300
                    ),
                  ),
                ),
              ),

            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: ScreenUtil.getInstance().getAdapterSize(6.0),
              left: ScreenUtil.getInstance().getWidth(14.0),
              right: ScreenUtil.getInstance().getWidth(14.0),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // 横轴元素个数
                crossAxisCount: 3,
                  //纵轴间距
                    mainAxisSpacing: ScreenUtil.getInstance().getWidth(6.0),
                    //横轴间距
                    crossAxisSpacing: ScreenUtil.getInstance().getWidth(6.0),
                    //子组件宽高长度比例
                    childAspectRatio: 2.0,
              ),
              itemCount: itemData == null ? 0 : (itemData?.modules == null ? 0 : itemData?.modules?.length),
              itemBuilder: (context, position) {
                return ModuleItemWidget(itemData: itemData!.modules![position]);
              },
            ),
          ),
        ],
      ),
    );
  }

}