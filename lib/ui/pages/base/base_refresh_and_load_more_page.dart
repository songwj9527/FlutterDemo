import 'package:flutter/material.dart';

abstract class BaseRefreshAndLoadMorePage<T> extends StatefulWidget {
  // 滑动组件滚动到的位置
  double offset = 0.0;

  bool init = false;
  // 请求参数
  Map<String, dynamic>? requestParamsMap;
  // 当前请求分页page值
  int page = 1;
  // 分页page size值
  int pageSize = 15;
  // 是否显示加载更多
  bool enableLoad = true;
  // 是否已加载全部
  bool loadAll = false;
  // 最大显示数量
  int totalCount = 0;
  // 数据列表
  List<T> dataList = <T>[];

  BaseRefreshAndLoadMorePage({this.pageSize = 15});
}