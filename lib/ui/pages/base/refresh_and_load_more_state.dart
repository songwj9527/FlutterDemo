import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';

import 'refresh_and_load_more_page.dart';
import 'refresh_state.dart';

abstract class RefreshAndLoadMorePageState<T extends RefreshAndLoadMorePage> extends RefreshState<T> {
  int pageSize = 15;

  RefreshAndLoadMorePageState({
    initOffset: 0.0,
    headerFloat: false,
    enableInfiniteLoad: true,
    taskIndependence: false,
    vibration: true,
    enableRefresh: true,
    enableLoad: true,
    topBouncing: true,
    bottomBouncing: true,
    isFirstRefresh: false,
    Color? backgroundColor,
    double? dividerHeight,
    double? dividerIndent,
    double? dividerEndIndent,
    dividerColor: ResourceColors.divider,
    isDividerTop: false,
    this.pageSize: 15
  }) : super(
      initOffset: initOffset,
      headerFloat: headerFloat,
      enableInfiniteLoad: enableInfiniteLoad,
      taskIndependence: taskIndependence,
      vibration: vibration,
      enableRefresh: enableRefresh,
      enableLoad: enableLoad,
      topBouncing: topBouncing,
      bottomBouncing: bottomBouncing,
      isFirstRefresh: isFirstRefresh,
      backgroundColor: backgroundColor,
      dividerHeight: dividerHeight,
      dividerIndent: dividerIndent,
      dividerEndIndent: dividerEndIndent,
      dividerColor: dividerColor,
      isDividerTop: isDividerTop
  );

  @override
  void initState() {
    super.initState();
    LogUtil.e("RefreshAndLoadMorePageState: initState()");
    enableLoad = widget.enableLoad;
    refreshItems(LoadResult(count: widget.dataList.length,
        maxCount: widget.enableLoad && !widget.loadAll ? widget.dataList.length < widget.totalCount ? widget.totalCount : widget.dataList.length : widget.dataList.length),
    );
    scrollController.addListener(() {
      widget.offset = scrollController.offset;
    });
  }

  @override
  LoadResult getLoadResult() {
    LogUtil.e("RefreshAndLoadMorePageState: getLoadResult()");
    return LoadResult(count: widget.dataList.length,
      maxCount: !widget.loadAll ? widget.dataList.length < widget.totalCount ? widget.totalCount : widget.dataList.length : widget.dataList.length,
    );
  }

}