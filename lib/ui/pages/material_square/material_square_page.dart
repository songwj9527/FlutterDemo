import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/common/event_bus/event_bus_helper.dart';
import 'package:flutter_demo_app/models/response_model/get_labels_response.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

import '../base/task_controller_state.dart';
import 'material_tab_content_page.dart';
import 'refresh_material_tab_event.dart';

enum TabType {
  MY, // 我的
  COMMON, // 素材圈
  COLLECTION // 收藏
}
const titles = ['我的', '素材圈', '收藏'];

class MaterialSquarePage extends StatefulWidget {
  List<MaterialTabContentPage>? tabBarView;
  int tabIndex = 0;

  bool initLabelListForSearch = false;
  bool loadLabelListSuccess = false;
  List<LabelsBean>? labelListForSearch;

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("MaterialSquarePage: createState()");
    return _MaterialSquarePageState();
  }

}

class _MaterialSquarePageState extends TaskControllerState<MaterialSquarePage> with SingleTickerProviderStateMixin {
  double _statusBarHeight = ScreenUtil.getInstance().statusBarHeight;
  TabController? _tabController;
  StreamSubscription<RefreshMaterialTabEvent>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    LogUtil.e("_MaterialSquarePageState: initState()");
    _loadLabels();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("_MaterialSquarePageState: build()");
    if (_statusBarHeight < 20.0) {
      _statusBarHeight = ScreenUtil.getInstance().getHeight(30.0);
    }

    return Scaffold(
      backgroundColor: ResourceColors.gray_background,
      body: widget.initLabelListForSearch ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: _statusBarHeight + ScreenUtil.getInstance().appBarHeight,
            color: ResourceColors.theme_background,
            child: Container(
              margin: EdgeInsets.only(
                top: _statusBarHeight,
                left: ScreenUtil.getInstance().getAdapterSize(14.0),
                // right: ScreenUtil.getInstance().getAdapterSize(6.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TabBar(
                      tabs: [Tab(text: titles[0]), Tab(text: titles[1]), Tab(text: titles[2])],
                      labelColor: Colors.white,
                      labelStyle: TextStyle(
                        fontSize: ScreenUtil.getInstance().getSp(15.0),
                        color: Colors.white,
                      ),
                      unselectedLabelColor: ResourceColors.gray_f0,
                      unselectedLabelStyle: TextStyle(
                        fontSize: ScreenUtil.getInstance().getSp(15.0),
                        color: ResourceColors.gray_f0,
                      ),
                      indicatorColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorPadding: EdgeInsets.only(bottom: ScreenUtil.getInstance().getAdapterSize(1.0)),
                      controller: _tabController,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(14.0)),
                    icon: Icon(Icons.add_circle, color: Colors.white,),
                    color: Colors.white,
                    iconSize: ScreenUtil.getInstance().getAdapterSize(26.0),
                    onPressed: () {

                    },
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabBarView!,
            ),
          ),
        ],
      ) : Container(),
    );
  }

  void _initTabViews() {
    widget.tabBarView = [
      MaterialTabContentPage(TabType.MY, labelList: widget.labelListForSearch),
      MaterialTabContentPage(TabType.COMMON, labelList: widget.labelListForSearch),
      MaterialTabContentPage(TabType.COLLECTION, labelList: widget.labelListForSearch),
    ];
    _tabController = TabController(vsync: this, length: widget.tabBarView!.length, initialIndex: widget.tabIndex);
    _tabController?.addListener(() {
      widget.tabIndex = _tabController!.index;
    });
    _streamSubscription = EventBusHelper.instance.on<RefreshMaterialTabEvent>().listen((event) {
      if (event != null) {
        if (event.isScrollTo) {
          _tabController!.animateTo(event.index);
        }
        widget.tabBarView![event.index].refresh();
      }
    });
  }

  void _loadLabels() {
    if (!widget.loadLabelListSuccess) {
      widget.initLabelListForSearch = false;
    }
    if (widget.initLabelListForSearch && widget.loadLabelListSuccess) {
      _initTabViews();
      return;
    }
    widget.loadLabelListSuccess = true;
    widget.initLabelListForSearch = true;
    _initTabViews();
    if (mounted) {
      setState(() {});
    }
  }
}