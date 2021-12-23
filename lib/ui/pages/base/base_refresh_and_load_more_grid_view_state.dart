import 'package:flutter/material.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';

import 'base_refresh_and_load_more_page.dart';
import 'base_refresh_state.dart';

abstract class BaseRefreshLoadMoreGridViewState<T extends BaseRefreshAndLoadMorePage> extends BaseRefreshState<T> {
  // 滑动控制器
  late ScrollController scrollController;
  // 初始列表滚动位置
  double initOffset = 0.0;
  // 横轴元素个数
  final int crossAxisCount;
  //纵轴间距
  final double mainAxisSpacing;
  //横轴间距
  final double crossAxisSpacing;
  //子组件宽高长度比例
  final double childAspectRatio;

  BaseRefreshLoadMoreGridViewState(this.crossAxisCount, this.mainAxisSpacing, this.crossAxisSpacing, this.childAspectRatio, {
    bool initialRefresh = false,
    bool enableRefresh = true,
    bool enableLoad = true,
    this.initOffset = 0.0,
  }) : super(
    initialRefresh: initialRefresh,
    enableRefresh: enableRefresh,
    enableLoad: enableLoad,
  );

  @override
  void initState() {
    super.initState();
    enableLoad = widget.enableLoad;
    scrollController = ScrollController(initialScrollOffset: initOffset);
    scrollController.addListener(() {
      widget.offset = scrollController.offset;
    });
    enableLoad = widget.enableLoad;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildRefresher(context);
  }

  @override
  Widget buildRefresherContentView() {
    return (widget.dataList.length > 0) ? GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 横轴元素个数
        crossAxisCount: crossAxisCount,
        //纵轴间距
        mainAxisSpacing: mainAxisSpacing,
        //横轴间距
        crossAxisSpacing: crossAxisSpacing,
        //子组件宽高长度比例
        childAspectRatio: childAspectRatio,
      ),
      controller: scrollController,
      itemCount: widget.dataList.length,
      itemBuilder: (context, index) {
        return buildItemView(context, index);
      },
    ) : Center(
      child: (widget.init) ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          SizedBox(
            width: 100.0,
            height: 100.0,
            child: Image.asset(ResourceUtil.getResourceImage('icon_no_data')),
          ),
          Text(
            (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.noData : "",
            style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
          ),
          Expanded(
            child: SizedBox(),
            flex: 3,
          ),
        ],
      ) : Container(),
    );
  }

  /// 构建GridView item组件
  Widget buildItemView(BuildContext context, int index);
}