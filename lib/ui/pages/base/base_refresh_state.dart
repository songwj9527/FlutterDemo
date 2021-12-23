import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'task_controller_state.dart';

abstract class BaseRefreshState<T extends StatefulWidget> extends TaskControllerState<T> {
  // 刷新控制器
  late RefreshController refreshController;
  // 是否初始化刷新
  bool initialRefresh = false;
  // 是否开启刷新
  bool enableRefresh = true;
  // 是否开启加载
  bool enableLoad = true;
  // 是否正在搜索
  bool isSearching = false;

  BaseRefreshState({
    this.initialRefresh = false,
    this.enableRefresh = true,
    this.enableLoad = true,
  });

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: initialRefresh);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Widget _buildOnlyRefresh() {
    return SmartRefresher(
      enablePullDown: enableRefresh,
      enablePullUp: enableLoad,
      header: enableRefresh ? WaterDropHeader(
        refresh: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 25.0,
              height: 25.0,
              child: CupertinoActivityIndicator(),
            ),
            Container(
              width: 15.0,
            ),
            Text("正在刷新...",
              style: TextStyle(
                color: ResourceColors.gray_33,
                fontSize: ScreenUtil.getInstance().getSp(14.0),
              ),
            )
          ],
        ),
        complete: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.done,
              color: ResourceColors.gray_33,
            ),
            Container(
              width: 15.0,
            ),
            Text("刷新完成",
              style: TextStyle(
                color: ResourceColors.gray_33,
                fontSize: ScreenUtil.getInstance().getSp(14.0),
              ),
            )
          ],
        ),
      ) : null,
      footer: enableLoad ? CustomFooter(
        builder: (context, mode) {
          Widget body;
          if(mode != null && mode == LoadStatus.idle){
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.arrow_upward,
                  color: ResourceColors.gray_33,
                ),
                Container(
                  width: 15.0,
                ),
                Text("上拉加载更多",
                  style: TextStyle(
                    color: ResourceColors.gray_33,
                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                  ),
                )
              ],
            );
          }
          else if(mode != null && mode == LoadStatus.loading){
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: CupertinoActivityIndicator(),
                ),
                Container(
                  width: 15.0,
                ),
                Text("正在加载...",
                  style: TextStyle(
                    color: ResourceColors.gray_33,
                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                  ),
                )
              ],
            );
          }
          else if(mode != null && mode == LoadStatus.failed){
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: ResourceColors.gray_33,
                ),
                Container(
                  width: 15.0,
                ),
                Text("加载失败，点击重试",
                  style: TextStyle(
                    color: ResourceColors.gray_33,
                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                  ),
                )
              ],
            );
          }
          else if(mode != null && mode == LoadStatus.canLoading){
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.arrow_upward,
                  color: ResourceColors.gray_33,
                ),
                Container(
                  width: 15.0,
                ),
                Text("松手加载",
                  style: TextStyle(
                    color: ResourceColors.gray_33,
                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                  ),
                )
              ],
            );
          }
          else{
            body = Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.done,
                  color: ResourceColors.gray_33,
                ),
                Container(
                  width: 15.0,
                ),
                Text("已全部加载",
                  style: TextStyle(
                    color: ResourceColors.gray_33,
                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                  ),
                )
              ],
            );
          }
          return Container(
            height: ScreenUtil.getInstance().getAdapterSize(60.0),
            child: Center(child:body),
          );
        },
      ) : null,
      controller: refreshController,
      onRefresh: enableRefresh ? _onRefresh : null,
      onLoading: enableLoad ? _onLoading : null,
      child: buildRefresherContentView(),
    );
  }

  /// 构建上拉下拉刷新的组件
  Widget buildRefresher(BuildContext context) {
    Widget? _headerView = buildHeaderView();
    Widget? _footerView = buildFooterView();
    if (_headerView != null || _footerView != null) {
      List<Widget> _allViews = <Widget>[];
      if (_headerView != null) {
        _allViews.add(_headerView);
      }
      _allViews.add(Expanded(child: _buildOnlyRefresh()));
      if (_footerView != null) {
        _allViews.add(_footerView);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _allViews,
      );
    }
    return _buildOnlyRefresh();
  }

  /// 刷新
  void _onRefresh() {
    if (refreshController.isLoading) {
      refreshController.refreshToIdle();
      if(mounted) {
        setState(() {

        });
      }
      return;
    }
    if (isSearching) {
      refreshController.refreshToIdle();
      return;
    }
    onLoadData(isLoadMore: false);
  }

  /// 加载更多
  void _onLoading() {
    if (refreshController.isRefresh) {
      refreshController.refreshCompleted();
      if(mounted) {
        setState(() {

        });
      }
      return;
    }
    if (isSearching) {
      refreshController.refreshCompleted();
      return;
    }
    onLoadData(isLoadMore: true);
  }

  /// 是否正在刷新数据
  bool isRefreshing() {
    return refreshController.isRefresh;
  }

  /// 是否正在加载更多
  bool isLoading() {
    return refreshController.isLoading;
  }

  /// 自定义添加头部和底部控件
  Widget? buildHeaderView();
  Widget? buildFooterView();

  /// 构建上拉下拉所要刷新的组件（自定义）：ListView、GridView等
  Widget buildRefresherContentView();
  /// 具体加载数据方法（刷新和加载更多统一处理）
  void onLoadData({bool isLoadMore = false});
}