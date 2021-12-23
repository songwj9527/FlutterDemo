import 'package:flutter/material.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';

import 'base_refresh_and_load_more_page.dart';
import 'base_refresh_state.dart';

abstract class BaseRefreshLoadMoreListViewState<T extends BaseRefreshAndLoadMorePage> extends BaseRefreshState<T> {
  // 滑动控制器
  late ScrollController scrollController;
  // 初始列表滚动位置
  double initOffset = 0.0;
  // 分割线
  Widget? divider;

  BaseRefreshLoadMoreListViewState({
    bool initialRefresh = false,
    bool enableRefresh = true,
    bool enableLoad = true,
    this.initOffset = 0.0,
    this.divider,
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
    return (widget.dataList.length > 0) ? (divider == null ? ListView.builder(
      padding: const EdgeInsets.all(0.0),
      controller: scrollController,
      itemCount: widget.dataList.length,
      itemBuilder: (context, index) {
        return buildItemView(context, index);
      },
    ) : ListView.separated(
      padding: const EdgeInsets.all(0.0),
      controller: scrollController,
      itemCount: widget.dataList.length,
      separatorBuilder: (context, index) {
        return divider!;
      },
      itemBuilder: (context, index) {
        return buildItemView(context, index);
      },
    )) : Center(
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

  /// 构建ListView item组件
  Widget buildItemView(BuildContext context, int index);
}