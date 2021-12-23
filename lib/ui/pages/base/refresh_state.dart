import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/widgets/circular_progress_bar.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:rxdart/rxdart.dart';

import 'task_controller_state.dart';

abstract class RefreshState<T extends StatefulWidget> extends TaskControllerState<T> {

  late EasyRefreshController controller;
  late ScrollController scrollController;
  double initOffset = 0.0;
  static final int maxCount = 100000000;
  // 当前条目总数
  int _count = 0;
  // 反向
  bool _reverse = false;
  // 方向
  Axis _direction = Axis.vertical;
  // Header浮动
  bool headerFloat = false;
  // 无限加载
  bool enableInfiniteLoad = true;
  // 控制结束
  bool enableControlFinish = false;
  // 任务独立
  bool taskIndependence = false;
  // 震动
  bool vibration = true;
  // 是否开启刷新
  bool enableRefresh = true;
  // 是否开启加载
  bool enableLoad = true;
  // 顶部回弹
  bool topBouncing = true;
  // 底部回弹
  bool bottomBouncing = true;
  // 是否初始化刷新
  bool isFirstRefresh = false;
  // 背景颜色
  Color? backgroundColor;

  // 是否首item上方添加分割线
  final double? dividerHeight;
  final double? dividerIndent;
  final double? dividerEndIndent;
  final Color? dividerColor;
  // 是否首item上方添加分割线
  bool isDividerTop = false;
  // 是否正在刷新或加载更多
  bool isLoading = false;

  BehaviorSubject<int> _itemController = BehaviorSubject<int>();

  RefreshState({
    this.initOffset: 0.0,
    this.headerFloat: false,
    this.enableInfiniteLoad: true,
    this.taskIndependence: false,
    this.vibration: true,
    this.enableRefresh: true,
    this.enableLoad: true,
    this.topBouncing: true,
    this.bottomBouncing: true,
    this.isFirstRefresh: false,
    this.backgroundColor,
    this.dividerHeight,
    this.dividerIndent,
    this.dividerEndIndent,
    this.dividerColor: ResourceColors.divider,
    this.isDividerTop: false
  });

  @override
  void initState() {
    super.initState();
    LogUtil.e("RefreshState: initState()");
    controller = EasyRefreshController();
    scrollController = ScrollController(initialScrollOffset: initOffset);
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    _itemController.close();
    super.dispose();
    LogUtil.e("RefreshState: dispose()");
  }

  Widget buildRefresh(BuildContext context) {
    LogUtil.e("RefreshState: buildRefresh() $isFirstRefresh");
    return Center(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: backgroundColor??Colors.transparent,
        child: StreamBuilder<int>(
          initialData: _count,
          stream: _itemController.stream,
          builder: (BuildContext ctx, AsyncSnapshot<int> snapshot) {
            LogUtil.e("RefreshState: EasyRefresh() $isFirstRefresh");
            return new EasyRefresh.custom(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              taskIndependence: taskIndependence,
              controller: controller,
              scrollController: scrollController,
              reverse: _reverse,
              scrollDirection: _direction,
              topBouncing: topBouncing,
              bottomBouncing: bottomBouncing,
              header: enableRefresh ? ClassicalHeader(
                enableInfiniteRefresh: false,
                bgColor: headerFloat ? Theme.of(context).primaryColor : Colors.transparent,
                infoColor: headerFloat ? Colors.black87 : Colors.teal,
                float: headerFloat,
                enableHapticFeedback: vibration,
                refreshText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.pullToRefresh : "",
                refreshReadyText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.releaseToRefresh : "",
                refreshingText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.refreshing : "",
                refreshedText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.refreshed : "",
                refreshFailedText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.refreshFailed : "",
                noMoreText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.noMore : "",
                infoText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.updateAt : "",
              ) : null,
              footer: enableLoad ? ClassicalFooter(
                enableInfiniteLoad: enableInfiniteLoad,
                enableHapticFeedback: vibration,
                loadText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.pushToLoad : "",
                loadReadyText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.releaseToLoad : "",
                loadingText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.loading : "",
                loadedText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.loaded : "",
                loadFailedText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.loadFailed : "",
                noMoreText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.noMore : "",
                infoText: (ResourceUtil.getLocale(context) != null) ? ResourceUtil.getLocale(context)!.updateAt : "",
              ) : null,
              onRefresh: enableRefresh && !isLoading ? () async {
                LogUtil.e(">>>> refresh begin.");
                if (isLoading) {
                  return;
                }
                isLoading = true;
                isFirstRefresh = false;

                Stream<LoadResult> refreshStream = refresh();
                if (refreshStream != null) {
                  removeTask("refresh");
                  StreamSubscription refresh = refreshStream.listen((result) {
                    removeTask("refresh");
                    if (result == null || result.count == null || result.count < 0) {
                      _refreshFailed(result == null ? 0 : result.count < 0 ? 0 : result.count);
                    } else {
                      _refreshComplete(result.count);
                    }
                  });
                  addTask("refresh", refresh);
                } else {
                  _refreshComplete(0);
                }
              } : null,
              onLoad: enableLoad && !isLoading ? () async {
                LogUtil.e(">>>> load begin.");
                if (isLoading) {
                  return;
                }
                isLoading = true;
                Stream<LoadResult> loadStream = loadMore();
                if (loadStream != null) {
                  removeTask("load");
                  StreamSubscription load = loadStream.listen((result) {
                    removeTask("load");
                    if (result == null || result.count == null || result.count < 0) {
                      _loadFailed();
                    } else {
                      _loadComplete(result);
                    }
                  });
                  addTask("load", load);
                } else {
                  _loadComplete(LoadResult(count: 0, maxCount: maxCount));
                }
              } : null,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    _dividerItemBuilder,
                    childCount: (snapshot == null || !snapshot.hasData) ?  0 : snapshot.data,
                  ),
                ),
              ],
              firstRefresh: isFirstRefresh,
              firstRefreshWidget: isFirstRefresh ? Center(
                child: CircularProgressBar(
                  width: ScreenUtil.getInstance().getWidth(26.0),
                  height: ScreenUtil.getInstance().getWidth(26.0),
                ),
              ) : null,
              emptyWidget: (snapshot != null && snapshot.hasData && snapshot.data == 0 && !isLoading) ? Container(
                height: double.infinity,
                child: Column(
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
                ),
              ) : null,
            );
          },
        ),
      ),
    );
  }

  Widget _dividerItemBuilder(BuildContext context, int index) {
    if (dividerHeight != null && (index != 0 || isDividerTop)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: dividerHeight??0,
            margin: EdgeInsets.only(left: dividerIndent??0, right: dividerEndIndent??0),
            color: dividerColor??Colors.transparent,
          ),
          itemBuilder(context, index),
        ],
      );
    }
    return itemBuilder(context, index);
  }

  // Item Widget构造器
  Widget itemBuilder(BuildContext context, int index);

  // 刷新执行方法
  Stream<LoadResult> refresh();

  // 加载更多执行方法
  Stream<LoadResult> loadMore();

  // 获取当前数据条数和状态
  LoadResult getLoadResult();

  void _refreshFailed(int count) {
    if (mounted) {
      isLoading = false;
      _itemController.sink.add(_count = count);
      if (!enableControlFinish) {
        controller.resetLoadState();
        controller.finishRefresh();
      }
      LogUtil.e(">>>> refresh failed.");
    }
  }

  void _refreshComplete(int count) {
    if (mounted) {
      isLoading = false;
      _itemController.sink.add(_count = count);
      if (!enableControlFinish) {
        controller.resetLoadState();
        controller.finishRefresh();
      }
      LogUtil.e(">>>> refresh over.");
    }
  }

  void _loadFailed() {
    if (mounted) {
      isLoading = false;
      _itemController.sink.add(_count);
      if (!enableControlFinish) {
        controller.resetRefreshState();
        controller.finishLoad();
      }
      LogUtil.e(">>>> load failed.");
    }
  }

  void _loadComplete(LoadResult result) {
    if (mounted) {
      isLoading = false;
      _itemController.sink.add(_count = result.count);
      if (!enableControlFinish) {
        controller.resetRefreshState();
        controller.finishLoad(noMore: _count >= (result != null ? result.maxCount : maxCount));
      }
      LogUtil.e(">>>> load over.");
    }
  }

  void refreshItems(LoadResult result) {
    LogUtil.e(">>>> refreshItems begin.");
    if (mounted) {
      _itemController.sink.add(_count = result.count);
      if (!enableControlFinish) {
        controller.resetRefreshState();
        controller.finishLoad(noMore: _count >= (result != null ? result.maxCount : maxCount));
      }
      LogUtil.e(">>>> refreshItems over.");
    }
  }

  void searchRefresh(LoadResult result) {
    LogUtil.e(">>>> search begin.");
    Stream<LoadResult> refreshStream = refresh();
    if (refreshStream != null) {
      removeTask("search");
      StreamSubscription refresh = refreshStream.listen((event) {
        removeTask("search");
        if (event == null || event.count == null || event.count < 0) {
          _refreshFailed(event == null ? 0 : event.count < 0 ? 0 : result.count);
        } else {
          _refreshComplete(event.count);
        }
        dismissLoadingDialog();
      });
      addTask("search", refresh);
    } else {
      _refreshComplete(0);
      dismissLoadingDialog();
    }
    LogUtil.e(">>>> search over.");
  }
}

class LoadResult {
  int count;
  int maxCount;

  LoadResult({this.count: 0, this.maxCount: 0});
}