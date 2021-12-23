import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:common_utils/common_utils.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/models/response_model/get_labels_response.dart';
import 'package:flutter_demo_app/models/response_model/material_response.dart';
import 'package:flutter_demo_app/network/page_params.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/base/base_refresh_and_load_more_list_view_state.dart';
import 'package:flutter_demo_app/ui/pages/base/base_refresh_and_load_more_page.dart';
import 'package:rxdart/rxdart.dart';

import 'material_item_widget.dart';
import 'material_square_page.dart';

class MaterialTabContentPage extends BaseRefreshAndLoadMorePage<MaterialsBean> {
  // 类型
  TabType tabType;
  bool initRefresh = true;
  _MaterialTabContentPageState? _state;
  int labelIndexForSearch = -1;
  List<LabelsBean>? labelListForSearch;
  final List<LabelsBean> labelListForShow = <LabelsBean>[];
  final int max_label_show_count = 4;

  MaterialTabContentPage(this.tabType, {List<LabelsBean>? labelList}) {
    this.labelListForSearch = labelList;
    if (labelListForSearch != null && labelListForSearch!.length > 0) {
      for (int i = 0; i < labelListForSearch!.length && i < max_label_show_count; i++) {
        labelListForShow.add(labelListForSearch![i]);
      }
    }

    // {
    //    "condition": { // 筛选条件，不选择不传对应参数
    //        "label_ids": [ 2, 3, 4, 5 ], // 标签ID，多个标签 或
    //        "state": "0", // 审核状态 0 待审 1 通过 2 退回, 默认通过
    //        "agent_id": 90000, // 代理商,
    //        "operation_type": "1", // 操作类型 1 点赞  2 评论 3 转发 4 收藏，若传1，表示 我点赞的，以此类推
    //        "my_onwer": "1", // 我的素材
    //    }
    //}
    LabelsBean? _labelsBean;
    if (labelIndexForSearch != -1 && labelIndexForSearch < labelListForShow.length) {
      _labelsBean = labelListForSearch![labelIndexForSearch];
    } else {
      labelIndexForSearch = -1;
    }
    requestParamsMap = Map<String, dynamic>();
    var condition = Map<String, dynamic>();
    if (tabType == TabType.MY) {
      condition["my_onwer"] = "1"; // 我的素材
      if (_labelsBean != null) {
        condition["label_ids"] = [_labelsBean.GUID];
      }
    } else if (tabType == TabType.COLLECTION) {
      condition["operation_type"] = "4"; // 操作类型 1 点赞  2 评论 3 转发 4 收藏，若传1，表示 我点赞的，以此类推
      if (_labelsBean != null) {
        condition["label_ids"] = [_labelsBean.GUID];
      }
    } else {
      if (_labelsBean != null) {
        condition["label_ids"] = [_labelsBean.GUID];
      }
    }
    requestParamsMap!["condition"] = condition;
  }

  void refresh() {
    LogUtil.e("MaterialTabContentPage: refresh()");
    init = false;
  }

  @override
  State<StatefulWidget> createState() {
    LogUtil.e("MaterialTabContentPage: createState()");
    _state = _MaterialTabContentPageState(initialRefresh: !init, initOffset: offset);
    return _state!;
  }
}

class _MaterialTabContentPageState extends BaseRefreshLoadMoreListViewState<MaterialTabContentPage> {

  _MaterialTabContentPageState({bool initialRefresh: false, double initOffset: 0.0}) : super(
    initialRefresh: initialRefresh,
    initOffset: initOffset,
    divider: Container(
      height: ScreenUtil.getInstance().getAdapterSize(6.0),
      color: ResourceColors.gray_background,
    ),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _selectLabelController.close();
  }

  final BehaviorSubject<bool> _selectLabelController = BehaviorSubject<bool>();
  @override
  Widget? buildHeaderView() {
    return widget.labelListForShow.length > 0 ? Container(
      color: Colors.white,
      margin: EdgeInsets.only(
        bottom: ScreenUtil.getInstance().getWidth(6.0),
      ),
      child: widget.labelListForSearch!.length > widget.max_label_show_count ?Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StreamBuilder<bool>(
                initialData: true,
                stream: _selectLabelController.stream,
                builder: (context, snap) {
                  return Container(
                    margin: EdgeInsets.only(
                      left: ScreenUtil.getInstance().getWidth(14.0),
                      right: ScreenUtil.getInstance().getWidth(4.0),
                    ),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: _buildLabelViews(widget.labelListForShow),
                    ),
                  );
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: ScreenUtil.getInstance().getAdapterSize(24.0),
            color: ResourceColors.gray_66,
            onPressed: () {

            },
          ),
        ],
      ) : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamBuilder<bool>(
          initialData: true,
          stream: _selectLabelController.stream,
          builder: (context, snap) {
            return Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: _buildLabelViews(widget.labelListForShow),
            );
          },
        ),
      ),
    ) : null;
  }

  @override
  Widget? buildFooterView() {
    return null;
  }

  List<Widget> _buildLabelViews(List<LabelsBean>? labels) {
    if (labels == null || labels.length == 0) {
      return <Widget>[];
    }
    List<Widget> labelViews = <Widget>[];
    Widget itemView = _buildLabelItemView(
      -1,
      widget.labelIndexForSearch == -1 ? ResourceColors.theme_background : ResourceColors.gray_ee,
      widget.labelIndexForSearch == -1 ? Colors.white : ResourceColors.gray_33,
      "推荐",
    );
    labelViews.add(itemView);
    labelViews.add(Container(
      width: ScreenUtil.getInstance().getAdapterSize(8.0),
      height: ScreenUtil.getInstance().getAdapterSize(4.0),
    ));
    for (int i = 0; i < labels.length && i < widget.max_label_show_count; i++) {
      var label = labels[i];
      Widget itemView = _buildLabelItemView(
        i,
        widget.labelIndexForSearch == i ? ResourceColors.theme_background : ResourceColors.gray_ee,
        widget.labelIndexForSearch == i ? Colors.white : ResourceColors.gray_33,
        label.BQMC??"",
      );
      labelViews.add(itemView);
      labelViews.add(Container(
        width: ScreenUtil.getInstance().getAdapterSize(6.0),
        height: ScreenUtil.getInstance().getAdapterSize(4.0),
      ));
    }
    return labelViews;
  }

  Widget _buildLabelItemView(final int index, final Color backgroud, final Color textColor, final String text) {
    return InkWell(
      onTap: () {
        if (widget.labelIndexForSearch != index) {
          if (refreshController.isRefresh || refreshController.isLoading) {
            return;
          }

          if (index == -1) {
            if ((widget.requestParamsMap!["condition"]).containsKey("label_ids")) {
              (widget.requestParamsMap!["condition"]).remove("label_ids");
            }
          } else {
            (widget.requestParamsMap!["condition"])["label_ids"] = [widget.labelListForShow[index].GUID];
          }
          widget.init = false;
          widget.enableLoad = enableLoad = false;
          widget.loadAll = false;
          widget.dataList.clear();
          if (mounted) {
            setState(() {

            });
          }
          widget.labelIndexForSearch = index;
          _selectLabelController.sink.add(true);
          refreshController.requestRefresh();
        }
      },
      child: Container(
        height: ScreenUtil.getInstance().getAdapterSize(24.5),
        padding: EdgeInsets.only(
          left: ScreenUtil.getInstance().getWidth(8.0),
          right: ScreenUtil.getInstance().getWidth(8.0),
        ),
        decoration: BoxDecoration(
          color: backgroud,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().getAdapterSize(12.0))),
        ),
        alignment: Alignment.center,
        child: Text(text,
          style: TextStyle(
            color: textColor,
            fontSize: ScreenUtil.getInstance().getSp(12.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildItemView(BuildContext context, int index) {
    return MaterialItemWidget(widget.tabType, widget.dataList[index]);
  }

  @override
  void onLoadData({bool isLoadMore = false}) {
    removeTaskAndToken("onLoadData");
    LogUtil.e("onLoadData: ${json.encode(widget.requestParamsMap)}");
    PageParams _pageParams;
    if (isLoadMore) {
      _pageParams = PageParams(Page: widget.page + 1, PageSize: widget.pageSize);
    } else {
      widget.page = 1;
      _pageParams = PageParams(Page: 1, PageSize: widget.pageSize);
    }
    // {"Code":0,"Message":"操作成功","Result":{"total":1,"materials":[{"GUID":560,"SCLX":"2","SCZY":null,"SCWA":"标签测试","GKLX":null,"SHZT":"1","CJR":800000000025,"CJSJ":1627391939593,"update_user":null,"update_time":null,"ZTBS":"E","create_name":"张磊（测试）","update_name":null,"avatar_id":900000003337,"create_user_des":null,"labels":[{"DXID":560,"BQID":5,"BQMC":"系统测试","BQYS":"1DC4A2"},{"DXID":560,"BQID":6,"BQMC":"青少年减脂","BQYS":"009FFE"}],"files":[900000003323,900000003324],"likes":0,"comments":0,"forwards":0,"collects":0,"is_like":false,"is_collect":false}]}}
    var resultMap = {"Code":0,"Message":"操作成功","Result":{"total":1,"materials":[{"GUID":560,"SCLX":"2","SCZY":null,"SCWA":"标签测试","GKLX":null,"SHZT":"1","CJR":800000000025,"CJSJ":1627391939593,"update_user":null,"update_time":null,"ZTBS":"E","create_name":"张磊（测试）","update_name":null,"avatar_id":900000003337,"create_user_des":null,"labels":[{"DXID":560,"BQID":5,"BQMC":"系统测试","BQYS":"1DC4A2"},{"DXID":560,"BQID":6,"BQMC":"青少年减脂","BQYS":"009FFE"}],"files":[900000003323,900000003324],"likes":0,"comments":0,"forwards":0,"collects":0,"is_like":false,"is_collect":false}]}};
    MaterialResponse resultModel = MaterialResponse.fromJson(resultMap);
    widget.init = true;
    if (!isLoadMore) {
      widget.dataList.clear();
    }

    if (resultModel.Result!.total != null) {
      widget.totalCount = resultModel.Result!.total!;
    }
    if (resultModel.Result!.materials == null || resultModel.Result!.materials!.length == 0) {
      widget.enableLoad = widget.loadAll = enableLoad = false;
      if(mounted) {
        setState(() {

        });
      }
      if (!isLoadMore) {
        refreshController.refreshCompleted();
      }
      refreshController.loadNoData();
      return;
    }
    widget.enableLoad = enableLoad = !(resultModel.Result!.materials!.length < widget.pageSize);
    widget.loadAll = (resultModel.Result!.materials!.length < widget.pageSize);
    widget.dataList.addAll(resultModel.Result!.materials!);
    if (isLoadMore) {
      widget.page += 1;
    }

    if(mounted) {
      setState(() {

      });
    }

    if (isLoadMore) {
      if (resultModel.Result!.materials!.length < widget.pageSize || widget.dataList.length == widget.totalCount) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    } else {
      refreshController.refreshCompleted();
      if (resultModel.Result!.materials!.length < widget.pageSize || widget.dataList.length == widget.totalCount) {
        refreshController.loadNoData();
      }
    }
  }

  /// 因为refreshCompleted()/loadComplete，立即setState刷新列表会报错，特此延时刷新
  void refreshContentView() {
    addTask("refreshControllerResult", Future.delayed(Duration(milliseconds: 1000)).asStream().listen((result) {
      if(mounted) {
        setState(() {

        });
      }
    }));
  }
}