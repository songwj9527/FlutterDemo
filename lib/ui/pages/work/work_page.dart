import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/widgets/customer_app_bar.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_demo_app/utils/toast_util.dart';

import 'module_classification_widget.dart';
import 'module_item_widget.dart';

class WorkPage extends StatefulWidget {

  List<ModuleClassification> moduleClassificationList = <ModuleClassification>[];
  double offset = 0.0;

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("WorkPage: createState()");
    return _WorkPageState();
  }
}

class _WorkPageState extends State<WorkPage> {

  //滚动控制器
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(initialScrollOffset: widget.offset);
    _controller.addListener(() {
      widget.offset = _controller.offset;
    });

    widget.moduleClassificationList.clear();
    ModuleClassification moduleClassification = ModuleClassification();
    moduleClassification.name = '云仓储';
    moduleClassification.modules = <ModuleItem>[];
    ModuleItem moduleItem = ModuleItem();
    moduleItem.name = '发货';
    moduleItem.icon = Icon(Icons.account_balance_wallet, color: Colors.blueAccent, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.blueAccent;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("发货");
    };
    moduleClassification.modules?.add(moduleItem);
    moduleItem = ModuleItem();
    moduleItem.name = '进货';
    moduleItem.icon = Icon(Icons.business_center, color: Colors.orange, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.orange;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("进货");
    };
    moduleClassification.modules?.add(moduleItem);
    moduleItem = ModuleItem();
    moduleItem.name = '移仓';
    moduleItem.icon = Icon(Icons.local_car_wash, color: Colors.blueAccent, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.blueAccent;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("移仓");
    };
    moduleClassification.modules?.add(moduleItem);
    moduleItem = ModuleItem();
    moduleItem.name = '库存';
    moduleItem.icon = Icon(Icons.home, color: Colors.red, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.red;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("库存");
    };
    moduleClassification.modules?.add(moduleItem);
    widget.moduleClassificationList.add(moduleClassification);

    moduleClassification = ModuleClassification();
    moduleClassification.name = '客户管理';
    moduleClassification.modules = <ModuleItem>[];
    moduleItem = ModuleItem();
    moduleItem.name = '我的客户';
    moduleItem.icon = Icon(Icons.perm_contact_calendar, color: Colors.red, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.red;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("我的客户");
    };
    moduleClassification.modules?.add(moduleItem);
    widget.moduleClassificationList.add(moduleClassification);

    moduleClassification = ModuleClassification();
    moduleClassification.name = '公告';
    moduleClassification.modules = <ModuleItem>[];
    moduleItem = ModuleItem();
    moduleItem.name = '公告';
    moduleItem.icon = Icon(Icons.notifications, color: Colors.redAccent, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.redAccent;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("公告");
    };
    moduleClassification.modules?.add(moduleItem);
    moduleItem = ModuleItem();
    moduleItem.name = '帮助';
    moduleItem.icon = Icon(Icons.bookmark_border, color: Colors.blueAccent, size: ScreenUtil.getInstance().getSp(20.0));
    moduleItem.color = Colors.blueAccent;
    moduleItem.onItemClick = (value) {
      ToastUtil.showToast("帮助");
    };
    moduleClassification.modules?.add(moduleItem);
    widget.moduleClassificationList.add(moduleClassification);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_WorkPageState: build()");

    return Scaffold(
      appBar: CustomerAppBar(
        backgroundColor: ResourceColors.theme_background,
        automaticallyImplyLeading: false,//是否显示返回按钮
        titleContent: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.appCompanyName : "",
      ),
      backgroundColor: ResourceColors.gray_background,
      body: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: widget.moduleClassificationList.length,
        itemBuilder: (context, position) {
          if (position == 0) {
            return ModuleClassificationWidget(
                itemData: widget.moduleClassificationList[position],
                marginTop: ScreenUtil.getInstance().getAdapterSize(18)
            );
          }
          if (position == widget.moduleClassificationList.length - 1) {
            return ModuleClassificationWidget(
              itemData: widget.moduleClassificationList[position],
              marginTop: ScreenUtil.getInstance().getAdapterSize(18),
              marginBottom: ScreenUtil.getInstance().getAdapterSize(18),
            );
          }
          return ModuleClassificationWidget(itemData: widget.moduleClassificationList[position]);
        },
        separatorBuilder: (context, position) {
          return Container(
            width: double.infinity,
            height: ScreenUtil.getInstance().getAdapterSize(12),
//            color: Colors.transparent,
          );
        },
      ),
    );
  }

}