import 'package:flutter/material.dart';

import 'base_refresh_and_load_more_grid_view_state.dart';
import 'base_search_refresh_and_load_more_page.dart';

abstract class BaseSearchRefreshLoadMoreGridViewState<T extends BaseSearchRefreshAndLoadMorePage> extends BaseRefreshLoadMoreGridViewState<T> {

  BaseSearchRefreshLoadMoreGridViewState(int crossAxisCount, double mainAxisSpacing, double crossAxisSpacing, double childAspectRatio, {
    bool initialRefresh = false,
    bool enableRefresh = true,
    bool enableLoad = true,
    double initOffset = 0.0,
  }) : super(
    crossAxisCount, mainAxisSpacing, crossAxisSpacing, childAspectRatio,
    initialRefresh: initialRefresh,
    enableRefresh: enableRefresh,
    enableLoad: enableLoad,
    initOffset: initOffset,
  );

  @override
  Widget build(BuildContext context) {
    return buildRefresher(context);
  }

  /// 构建GridView item组件
  Widget buildItemView(BuildContext context, int index);

  /// 是否可以搜索
  bool toSearchEnable = false;
  void enableToSearch(bool enable) {
    toSearchEnable = enable;
  }
  /// 搜索
  void search(String key) {
    if (toSearchEnable) {
      if (refreshController.isRefresh || refreshController.isLoading || isSearching) {
        return;
      }
      isSearching = true;
      if (mounted) {
        showLoadingDialog(outsideDismiss: true);
      }
      toSearch(key);
      toSearchEnable = false;
      widget.enableToSearch = false;
    }
  }
  /// 搜索的具体实现方法
  void toSearch(String key);
}