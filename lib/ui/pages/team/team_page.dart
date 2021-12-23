import 'dart:collection';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_app/models/response_model/agent_team_business_response.dart';
import 'package:flutter_demo_app/models/response_model/agent_team_lower_response.dart';
import 'package:flutter_demo_app/models/response_model/agent_team_response.dart';
import 'package:flutter_demo_app/network/api/file_api.dart';
import 'package:flutter_demo_app/res/resource_colors.dart';
import 'package:flutter_demo_app/ui/pages/base/base_refresh_state.dart';
import 'package:flutter_demo_app/ui/widgets/customer_app_bar.dart';
import 'package:flutter_demo_app/utils/resource_util.dart';
import 'package:rxdart/rxdart.dart';

enum BusinessType {
  WEEK,
  MONTH,
  YEAY
}

class TeamPage extends StatefulWidget {
  AgentTeamBean? agentTeam;
  BusinessType lowerType = BusinessType.WEEK;
  List<AgentLowerBean>? lowerListShow;
  List<AgentLowerBean>? lowerListWeek;
  List<AgentLowerBean>? lowerListMonth;
  List<AgentLowerBean>? lowerListYear;
  BusinessType businessType = BusinessType.WEEK;
  CountBean? countBeanWeek;
  CountBean? countBeanMonth;
  CountBean? countBeanYear;

  @override
  State<StatefulWidget> createState() {
    return _TeamPageState();
  }

}

class _TeamPageState extends BaseRefreshState<TeamPage> {
  int _pieTouchedIndex = -1;

  _TeamPageState() : super(initialRefresh: true, enableLoad: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerAppBar(
        backgroundColor: ResourceColors.theme_background,
        titleContent: '团队',
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            padding: EdgeInsets.all(ScreenUtil.getInstance().getAdapterSize(14.0)),
            icon: Icon(Icons.open_in_browser, color: Colors.white,),
            color: Colors.white,
            iconSize: ScreenUtil.getInstance().getAdapterSize(25.0),
            onPressed: () {

            },
          ),
        ],
      ),
      backgroundColor: ResourceColors.gray_background,
      body: buildRefresher(context),
    );
  }

  @override
  Widget? buildHeaderView() {
    return null;
  }

  @override
  Widget? buildFooterView() {
    return null;
  }

  @override
  Widget buildRefresherContentView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTeamCount(),
          _buildDownstreamMembers(),
          _buildTeamAchievement(),
        ],
      ),
    );
  }

  int loadCount = 0;
  @override
  void onLoadData({bool isLoadMore = false}) {
    if (isLoadLowerForTime) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
      return;
    }
    if (isLoadBusinessForTime) {
      if (refreshController.isRefresh) {
        refreshController.refreshCompleted();
      }
      return;
    }
    _clear();
    loadCount = 0;
    addTask("onLoadData", Future.delayed(Duration(milliseconds: 50)).asStream().listen((event) {
      _getAgentTeam();
      _getAgentTeamLower();
      _getAgentTeamBusiness();
    }));
  }

  void _clear() {
    widget.lowerListShow = null;
    widget.lowerListWeek = null;
    widget.lowerListMonth = null;
    widget.lowerListYear = null;
    widget.countBeanWeek = null;
    widget.countBeanMonth = null;
    widget.countBeanYear = null;
  }

  void _getAgentTeam() {
    removeTaskAndToken("getAgentTeam");
    // {"Code":0,"Message":"操作成功","Result":{"agents_sum":11,"levels":[{"level_id":900000000003,"level_name":"董事","level_val":80,"number":1},{"level_id":900000000004,"level_name":"联创","level_val":70,"number":1},{"level_id":900000000002,"level_name":"A经销商","level_val":60,"number":3},{"level_id":900000000001,"level_name":"B经销商","level_val":40,"number":3},{"level_id":900000000000,"level_name":"零售","level_val":20,"number":3}]}}
    var resultMap = {"Code":0,"Message":"操作成功","Result":{"agents_sum":11,"levels":[{"level_id":900000000003,"level_name":"董事","level_val":80,"number":1},{"level_id":900000000004,"level_name":"联创","level_val":70,"number":1},{"level_id":900000000002,"level_name":"A经销商","level_val":60,"number":3},{"level_id":900000000001,"level_name":"B经销商","level_val":40,"number":3},{"level_id":900000000000,"level_name":"零售","level_val":20,"number":3}]}};
    AgentTeamResponse resultModel = AgentTeamResponse.fromJson(resultMap);
    loadCount += 1;
    widget.agentTeam = resultModel.Result;
    _agentTeamController.sink.add(resultModel.Result);
    if (loadCount > 2 && refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }
  }

  void _getAgentTeamBusiness() {
    removeTaskAndToken("getAgentTeamBusiness");
    //{
    //    "condition": {
    //        "start_time": 10000, // 起始时间
    //        "end_time": 19000, // 截止时间
    //    }
    //}
    var paramsMap = HashMap<String, dynamic>();
    var condition = HashMap<String, dynamic>();
    paramsMap["condition"] = condition;
    if (widget.businessType == BusinessType.WEEK) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.weekday - 1) * 24 * 60 * 60 * 1000;
    } else if (widget.businessType == BusinessType.MONTH) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.day - 1) * 24 * 60 * 60 * 1000;
    } else {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: "yyyy")}-01-01 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch;
    }
    loadCount += 1;
    // {"Code":0,"Message":"操作成功","Result":{"count":{"new_agents":0,"new_upgrade":0,"purchase_amount":0,"sale_amount":0}}}
    var resultStr = {"Code":0,"Message":"操作成功","Result":{"count":{"new_agents":0,"new_upgrade":0,"purchase_amount":0,"sale_amount":0}}};
    AgentTeamBusinessResponse resultModel = AgentTeamBusinessResponse.fromJson(resultStr);
    if (widget.businessType == BusinessType.WEEK) {
      widget.countBeanWeek = resultModel.Result?.count;
    } else if (widget.businessType == BusinessType.MONTH) {
      widget.countBeanMonth = resultModel.Result?.count;
    } else {
      widget.countBeanYear = resultModel.Result?.count;
    }
    if (!_initTeamAchievement) {
      _initTeamAchievement = true;
    }
    _teamAchievementController.sink.add(true);
    if (loadCount > 2 && refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }
  }

  bool isLoadBusinessForTime = false;
  void _getAgentTeamBusinessForTime() {
    if (refreshController.isRefresh) {
      return;
    }
    if (isLoadBusinessForTime) {
      return;
    }
    isLoadBusinessForTime = true;
    showLoadingDialog(outsideDismiss: true);
    removeTaskAndToken("getAgentTeamBusiness");
    //{
    //    "condition": {
    //        "start_time": 10000, // 起始时间
    //        "end_time": 19000, // 截止时间
    //    }
    //}
    var paramsMap = HashMap<String, dynamic>();
    var condition = HashMap<String, dynamic>();
    paramsMap["condition"] = condition;
    if (widget.businessType == BusinessType.WEEK) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.weekday - 1) * 24 * 60 * 60 * 1000;
    } else if (widget.businessType == BusinessType.MONTH) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.day - 1) * 24 * 60 * 60 * 1000;
    } else {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: "yyyy")}-01-01 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch;
    }
    // {"Code":0,"Message":"操作成功","Result":{"count":{"new_agents":0,"new_upgrade":0,"purchase_amount":0,"sale_amount":0}}}
    var resultStr = {"Code":0,"Message":"操作成功","Result":{"count":{"new_agents":0,"new_upgrade":0,"purchase_amount":0,"sale_amount":0}}};
    AgentTeamBusinessResponse resultModel = AgentTeamBusinessResponse.fromJson(resultStr);
    if (widget.businessType == BusinessType.WEEK) {
      widget.countBeanWeek = resultModel.Result?.count;
    } else if (widget.businessType == BusinessType.MONTH) {
      widget.countBeanMonth = resultModel.Result?.count;
    } else {
      widget.countBeanYear = resultModel.Result?.count;
    }
    if (!_initTeamAchievement) {
      _initTeamAchievement = true;
    }
    _teamAchievementController.sink.add(true);
    dismissLoadingDialog();
    isLoadBusinessForTime = false;
  }

  void _getAgentTeamLower() {
    removeTaskAndToken("getAgentTeamLower");
    //{
    //    "condition": {
    //        "start_time": 10000, // 起始时间
    //        "end_time": 19000, // 截止时间
    //    }
    //}
    var paramsMap = HashMap<String, dynamic>();
    var condition = HashMap<String, dynamic>();
    paramsMap["condition"] = condition;
    if (widget.lowerType == BusinessType.WEEK) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.weekday - 1) * 24 * 60 * 60 * 1000;
    } else if (widget.lowerType == BusinessType.MONTH) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.day - 1) * 24 * 60 * 60 * 1000;
    } else {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: "yyyy")}-01-01 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch;
    }
    // {"Code":0,"Message":"操作成功","Result":{"agents_sum":11,"levels":[{"level_id":900000000003,"level_name":"董事","level_val":80,"number":1},{"level_id":900000000004,"level_name":"联创","level_val":70,"number":1},{"level_id":900000000002,"level_name":"A经销商","level_val":60,"number":3},{"level_id":900000000001,"level_name":"B经销商","level_val":40,"number":3},{"level_id":900000000000,"level_name":"零售","level_val":20,"number":3}]}}
    var resultStr = {"Code":0,"Message":"操作成功","Result":{"agents_sum":11,"levels":[{"level_id":900000000003,"level_name":"董事","level_val":80,"number":1},{"level_id":900000000004,"level_name":"联创","level_val":70,"number":1},{"level_id":900000000002,"level_name":"A经销商","level_val":60,"number":3},{"level_id":900000000001,"level_name":"B经销商","level_val":40,"number":3},{"level_id":900000000000,"level_name":"零售","level_val":20,"number":3}]}};
    AgentTeamLowerResponse resultModel = AgentTeamLowerResponse.fromJson(resultStr);
    loadCount += 1;
    if (widget.lowerType == BusinessType.WEEK) {
      widget.lowerListShow = resultModel.Result?.lowers;
      widget.lowerListWeek = resultModel.Result?.lowers;
    } else if (widget.lowerType == BusinessType.MONTH) {
      widget.lowerListShow = resultModel.Result?.lowers;
      widget.lowerListMonth = resultModel.Result?.lowers;
    } else {
      widget.lowerListShow = resultModel.Result?.lowers;
      widget.lowerListYear = resultModel.Result?.lowers;
    }
    if (!_initTeamLower) {
      _initTeamLower = true;
    }
    _agentLowersController.sink.add(resultModel.Result?.lowers);
    if (loadCount > 2 && refreshController.isRefresh) {
      refreshController.refreshCompleted();
    }
  }

  bool isLoadLowerForTime = false;
  void _getAgentTeamLowerForTime() {
    if (refreshController.isRefresh) {
      return;
    }
    if (isLoadLowerForTime) {
      return;
    }
    isLoadLowerForTime = true;
    showLoadingDialog(outsideDismiss: true);
    removeTaskAndToken("_getAgentTeamLowerForTime");
    //{
    //    "condition": {
    //        "start_time": 10000, // 起始时间
    //        "end_time": 19000, // 截止时间
    //    }
    //}
    var paramsMap = HashMap<String, dynamic>();
    var condition = HashMap<String, dynamic>();
    paramsMap["condition"] = condition;
    if (widget.lowerType == BusinessType.WEEK) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.weekday - 1) * 24 * 60 * 60 * 1000;
    } else if (widget.lowerType == BusinessType.MONTH) {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch - (todayDate.day - 1) * 24 * 60 * 60 * 1000;
    } else {
      DateTime todayDate = DateTime.now();
      DateTime? end_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: DateFormats.y_mo_d)} 23:59:59");
      DateTime? start_time = DateUtil.getDateTime("${DateUtil.formatDate(todayDate, format: "yyyy")}-01-01 00:00:00");
      condition["end_time"] = end_time!.millisecondsSinceEpoch;
      condition["start_time"] = start_time!.millisecondsSinceEpoch;
    }
    // {"Code":0,"Message":"操作成功","Result":{"agents_sum":11,"levels":[{"level_id":900000000003,"level_name":"董事","level_val":80,"number":1},{"level_id":900000000004,"level_name":"联创","level_val":70,"number":1},{"level_id":900000000002,"level_name":"A经销商","level_val":60,"number":3},{"level_id":900000000001,"level_name":"B经销商","level_val":40,"number":3},{"level_id":900000000000,"level_name":"零售","level_val":20,"number":3}]}}
    var resultStr = {"Code":0,"Message":"操作成功","Result":{"agents_sum":11,"levels":[{"level_id":900000000003,"level_name":"董事","level_val":80,"number":1},{"level_id":900000000004,"level_name":"联创","level_val":70,"number":1},{"level_id":900000000002,"level_name":"A经销商","level_val":60,"number":3},{"level_id":900000000001,"level_name":"B经销商","level_val":40,"number":3},{"level_id":900000000000,"level_name":"零售","level_val":20,"number":3}]}};
    AgentTeamLowerResponse resultModel = AgentTeamLowerResponse.fromJson(resultStr);
    if (widget.lowerType == BusinessType.WEEK) {
      widget.lowerListShow = resultModel.Result?.lowers;
      widget.lowerListWeek = resultModel.Result?.lowers;
    } else if (widget.lowerType == BusinessType.MONTH) {
      widget.lowerListShow = resultModel.Result?.lowers;
      widget.lowerListMonth = resultModel.Result?.lowers;
    } else {
      widget.lowerListShow = resultModel.Result?.lowers;
      widget.lowerListYear = resultModel.Result?.lowers;
    }
    if (!_initTeamLower) {
      _initTeamLower = true;
    }
    _agentLowersController.sink.add(resultModel.Result?.lowers);
    isLoadLowerForTime = false;
  }

  BehaviorSubject<AgentTeamBean?> _agentTeamController = BehaviorSubject<AgentTeamBean?>();
  final levelColors = [
    Color(0xFF512DA8),
    Color(0xFF7E57C2),
    Color(0xFF9575CD),
    Color(0xFFB39DDB),
    Color(0xFFD1C4E9),
  ];
  BehaviorSubject<int> _pieChartController = BehaviorSubject<int>();
  Widget _buildTeamCount() {
    return StreamBuilder<AgentTeamBean?>(
      initialData: widget.agentTeam,
      stream: _agentTeamController.stream,
      builder: (context, snapAgent) {
        if (snapAgent == null || !snapAgent.hasData || snapAgent.data == null || snapAgent.data!.levels == null || snapAgent.data!.levels!.length == 0) {
          return Container();
        }
        return Container(
          margin: EdgeInsets.only(
            left: ScreenUtil.getInstance().getWidth(12.0),
            right: ScreenUtil.getInstance().getWidth(12.0),
            top: ScreenUtil.getInstance().getWidth(12.0),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(10.0),
                  right: ScreenUtil.getInstance().getWidth(10.0),
                  top: ScreenUtil.getInstance().getWidth(10.0),
                  bottom: ScreenUtil.getInstance().getWidth(10.0),
                ),
                child: Text("总人数：${widget.agentTeam!.agentsSum}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black,fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(10.0),
                  right: ScreenUtil.getInstance().getWidth(10.0),
                  bottom: ScreenUtil.getInstance().getWidth(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                        physics: NeverScrollableScrollPhysics(),//禁用滑动事件
                        itemCount: widget.agentTeam!.levels!.length,
                        itemBuilder: (context, position) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: ScreenUtil.getInstance().getAdapterSize(6.0),
                                height: ScreenUtil.getInstance().getAdapterSize(6.0),
                                decoration: BoxDecoration(
                                  color: position < levelColors.length ? levelColors[position] : levelColors[levelColors.length - 1],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil.getInstance().getWidth(6.0),
                                  ),
                                  child: Text("（本人）",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ScreenUtil.getInstance().getSp(12.0),
                                      color: position < levelColors.length ? levelColors[position] : levelColors[levelColors.length - 1],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(
                                    left: ScreenUtil.getInstance().getWidth(6.0),
                                  ),
                                  child: Text("${widget.agentTeam!.levels![position].number}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: ScreenUtil.getInstance().getSp(12.0),
                                      color: position < levelColors.length ? levelColors[position] : levelColors[levelColors.length - 1],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      width: ScreenUtil.getInstance().getAdapterSize(120.0),
                      height: ScreenUtil.getInstance().getAdapterSize(120.0),
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().getWidth(10.0),
                      ),
                      child: AspectRatio(
                        aspectRatio: 1,
                        // child: Container(),
                        child: StreamBuilder<int>(
                          initialData: _pieTouchedIndex,
                          stream: _pieChartController.stream,
                          builder: (context, snap) {
                            return PieChart(
                              PieChartData(
                                pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                  final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                                      pieTouchResponse.touchInput is! PointerUpEvent;
                                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                    _pieTouchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                  } else {
                                    _pieTouchedIndex = -1;
                                  }
                                  _pieChartController.sink.add(_pieTouchedIndex);
                                }),
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: ScreenUtil.getInstance().getAdapterSize(20.0),
                                sections: List.generate(widget.agentTeam!.levels!.length, (index) {
                                  final isTouched = index == _pieTouchedIndex;
                                  final double fontSize = isTouched ? ScreenUtil.getInstance().getSp(14.0) : ScreenUtil.getInstance().getSp(10.0);
                                  final double radius = isTouched ? ScreenUtil.getInstance().getAdapterSize(40.0) : ScreenUtil.getInstance().getAdapterSize(30.0);
                                  return PieChartSectionData(
                                    color: index < levelColors.length ? levelColors[index] : levelColors[levelColors.length - 1],
                                    value: ((widget.agentTeam!.levels![index].number??0) * 100) / (widget.agentTeam!.agentsSum??0),
                                    title: '${widget.agentTeam!.levels![index].number}人',
                                    radius: radius,
                                    titleStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xffffffff),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _initTeamLower = false;
  BehaviorSubject<List<AgentLowerBean>?> _agentLowersController = BehaviorSubject<List<AgentLowerBean>?>();
  Widget _buildDownstreamMembers() {
    return StreamBuilder<List<AgentLowerBean>?>(
      initialData: widget.lowerListShow,
      stream: _agentLowersController.stream,
      builder: (context, snap) {
        if (!_initTeamLower) {
          return Container();
        }
        return Container(
          margin: EdgeInsets.only(
            left: ScreenUtil.getInstance().getWidth(12.0),
            right: ScreenUtil.getInstance().getWidth(12.0),
            top: ScreenUtil.getInstance().getWidth(12.0),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(10.0),
                  // right: ScreenUtil.getInstance().getWidth(10.0),
                  top: ScreenUtil.getInstance().getWidth(10.0),
                  bottom: ScreenUtil.getInstance().getWidth(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 标签
                    Container(
                      width: ScreenUtil.getInstance().getAdapterSize(4.0),
                      height: ScreenUtil.getInstance().getAdapterSize(16.0),
                      decoration: BoxDecoration(
                        color: ResourceColors.theme_background,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    // 标签名
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: ScreenUtil.getInstance().getWidth(8.0),
                          bottom: Platform.isIOS ? 0 : ScreenUtil.getInstance().getAdapterSize(1.0),
                        ),
                        child: Text("直属下游",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.getInstance().getSp(14.0),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    // 周、月、年
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   widget.lowerType = BusinessType.WEEK;
                                //   widget.lowerListShow = widget.lowerListWeek;
                                // });
                                widget.lowerType = BusinessType.WEEK;
                                widget.lowerListShow = widget.lowerListWeek;
                                _agentLowersController.sink.add(widget.lowerListShow);
                                if (widget.lowerListWeek == null) {
                                  _getAgentTeamLowerForTime();
                                }
                              },
                              child: Center(
                                child: Text("周",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.lowerType == BusinessType.WEEK ? Colors.deepPurpleAccent : ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   widget.lowerType = BusinessType.MONTH;
                                //   widget.lowerListShow = widget.lowerListMonth;
                                // });
                                widget.lowerType = BusinessType.MONTH;
                                widget.lowerListShow = widget.lowerListMonth;
                                _agentLowersController.sink.add(widget.lowerListShow);
                                if (widget.lowerListMonth == null) {
                                  _getAgentTeamLowerForTime();
                                }
                              },
                              child: Center(
                                child: Text("月",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.lowerType == BusinessType.MONTH ? Colors.deepPurpleAccent : ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   widget.lowerType = BusinessType.YEAY;
                                //   widget.lowerListShow = widget.lowerListYear;
                                // });
                                widget.lowerType = BusinessType.YEAY;
                                widget.lowerListShow = widget.lowerListYear;
                                _agentLowersController.sink.add(widget.lowerListShow);
                                if (widget.lowerListYear == null) {
                                  _getAgentTeamLowerForTime();
                                }
                              },
                              child: Center(
                                child: Text("年",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.lowerType == BusinessType.YEAY ? Colors.deepPurpleAccent : ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(10.0),
                  right: ScreenUtil.getInstance().getWidth(16.0),
                ),
                child: (widget.lowerListShow != null && widget.lowerListShow!.length > 3) ?
                ExpandableNotifier(
                  child: Expandable(
                    collapsed: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                          physics: NeverScrollableScrollPhysics(),//禁用滑动事件
                          itemCount: 3,
                          itemBuilder: (context, position) {
                            return InkWell(
                              onTap: () {

                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil.getInstance().getAdapterSize(position == 0 ? 0.0 : 8.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    widget.lowerListShow![position].TXID == null || widget.lowerListShow![position].TXID == 0 ? Container(
                                      width: ScreenUtil.getInstance().getWidth(42.0),
                                      height: ScreenUtil.getInstance().getWidth(42.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
//                            shape: BoxShape.circle,
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(ResourceUtil.getResourceImage('icon_default')),
                                        ),
                                      ),
                                    ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: CachedNetworkImage(
                                        imageUrl: FileApi.getFileUrl(widget.lowerListShow![position].TXID??0),
                                        width: ScreenUtil.getInstance().getWidth(42.0),
                                        height: ScreenUtil.getInstance().getWidth(42.0),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                        errorWidget: (context, url, error) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: ScreenUtil.getInstance().getWidth(16.0),
                                          right: ScreenUtil.getInstance().getWidth(16.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${widget.lowerListShow![position].YHXM}",
                                              style: TextStyle(
                                                fontSize: ScreenUtil.getInstance().getSp(14.0),
                                                color: ResourceColors.gray_33,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: ScreenUtil.getInstance().getAdapterSize(2.0),
                                              ),
                                              child: Text('${widget.lowerListShow![position].levelName}',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil.getInstance().getSp(12.0),
                                                  color: ResourceColors.gray_66,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text('${widget.lowerListShow![position].logisticQty}',
                                      style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().getSp(15.0),
                                        fontWeight: FontWeight.w400,
                                        color: ResourceColors.theme_background,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        ExpandableButton(
                          child: Container(
                            padding: EdgeInsets.only(
                              top: ScreenUtil.getInstance().getAdapterSize(8.0),
                              bottom: ScreenUtil.getInstance().getAdapterSize(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('点击查看更多',
                                  style: TextStyle(
                                    color: ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(13.0),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down, color: ResourceColors.gray_66,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListView.builder(
                          padding: const EdgeInsets.all(0.0),
                          shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                          physics: NeverScrollableScrollPhysics(),//禁用滑动事件
                          itemCount: widget.lowerListShow!.length,
                          itemBuilder: (context, position) {
                            return InkWell(
                              onTap: () {

                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: ScreenUtil.getInstance().getAdapterSize(position == 0 ? 0.0 : 8.0),
                                  bottom: ScreenUtil.getInstance().getAdapterSize(position != widget.lowerListShow!.length -1 ? 0.0 : 8.0),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    widget.lowerListShow![position].TXID == null || widget.lowerListShow![position].TXID == 0 ? Container(
                                      width: ScreenUtil.getInstance().getWidth(42.0),
                                      height: ScreenUtil.getInstance().getWidth(42.0),
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
//                            shape: BoxShape.circle,
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(ResourceUtil.getResourceImage('icon_default')),
                                        ),
                                      ),
                                    ) : ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: CachedNetworkImage(
                                        imageUrl: FileApi.getFileUrl(widget.lowerListShow![position].TXID??0),
                                        width: ScreenUtil.getInstance().getWidth(42.0),
                                        height: ScreenUtil.getInstance().getWidth(42.0),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                        errorWidget: (context, url, error) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: ScreenUtil.getInstance().getWidth(16.0),
                                          right: ScreenUtil.getInstance().getWidth(16.0),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("${widget.lowerListShow![position].YHXM}",
                                              style: TextStyle(
                                                fontSize: ScreenUtil.getInstance().getSp(14.0),
                                                color: ResourceColors.gray_33,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                bottom: ScreenUtil.getInstance().getAdapterSize(2.0),
                                              ),
                                              child: Text('${widget.lowerListShow![position].levelName}',
                                                style: TextStyle(
                                                  fontSize: ScreenUtil.getInstance().getSp(12.0),
                                                  color: ResourceColors.gray_66,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text("${widget.lowerListShow![position].logisticQty}",
                                      style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().getSp(15.0),
                                        fontWeight: FontWeight.w400,
                                        color: ResourceColors.theme_background,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        ExpandableButton(
                          child: Container(
                            padding: EdgeInsets.only(
                              top: ScreenUtil.getInstance().getAdapterSize(8.0),
                              bottom: ScreenUtil.getInstance().getAdapterSize(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('点击收起',
                                  style: TextStyle(
                                    color: ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(13.0),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_up, color: ResourceColors.gray_66,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : (widget.lowerListShow != null && widget.lowerListShow!.length > 0) ? ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  shrinkWrap: true, //为true可以解决子控件必须设置高度的问题
                  physics: NeverScrollableScrollPhysics(),//禁用滑动事件
                  itemCount: widget.lowerListShow!.length,
                  itemBuilder: (context, position) {
                    return InkWell(
                      onTap: () {

                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil.getInstance().getAdapterSize(position == 0 ? 0.0 : 8.0),
                          bottom: ScreenUtil.getInstance().getAdapterSize(position != widget.lowerListShow!.length -1 ? 0.0 : 8.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            widget.lowerListShow![position].TXID == null || widget.lowerListShow![position].TXID == 0 ? Container(
                              width: ScreenUtil.getInstance().getWidth(42.0),
                              height: ScreenUtil.getInstance().getWidth(42.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
//                            shape: BoxShape.circle,
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(ResourceUtil.getResourceImage('icon_default')),
                                ),
                              ),
                            ) : ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: CachedNetworkImage(
                                imageUrl: FileApi.getFileUrl(widget.lowerListShow![position].TXID??0),
                                width: ScreenUtil.getInstance().getWidth(42.0),
                                height: ScreenUtil.getInstance().getWidth(42.0),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                                errorWidget: (context, url, error) => Image.asset(ResourceUtil.getResourceImage('icon_default')),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil.getInstance().getWidth(16.0),
                                  right: ScreenUtil.getInstance().getWidth(16.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${widget.lowerListShow![position].YHXM}",
                                      style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().getSp(14.0),
                                        color: ResourceColors.gray_33,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        bottom: ScreenUtil.getInstance().getAdapterSize(2.0),
                                      ),
                                      child: Text('${widget.lowerListShow![position].levelName}',
                                        style: TextStyle(
                                          fontSize: ScreenUtil.getInstance().getSp(12.0),
                                          color: ResourceColors.gray_66,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text("${widget.lowerListShow![position].logisticQty}",
                              style: TextStyle(
                                fontSize: ScreenUtil.getInstance().getSp(15.0),
                                fontWeight: FontWeight.w400,
                                color: ResourceColors.theme_background,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ) : Container(
                  width: double.infinity,
                  height: ScreenUtil.getInstance().getHeight(100),
                  child: Center(
                    child: Text("暂无数据"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  bool _initTeamAchievement = false;
  BehaviorSubject<bool> _teamAchievementController = BehaviorSubject<bool>();
  Widget _buildTeamAchievement() {
    return StreamBuilder<bool>(
      initialData: _initTeamAchievement,
      stream: _teamAchievementController.stream,
      builder: (context, snap) {
        if (snap == null || !snap.hasData || !(snap.data??false)) {
          return Container();
        }
        return Container(
          margin: EdgeInsets.only(
            left: ScreenUtil.getInstance().getWidth(12.0),
            right: ScreenUtil.getInstance().getWidth(12.0),
            top: ScreenUtil.getInstance().getWidth(12.0),
            bottom: ScreenUtil.getInstance().getWidth(12.0),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: ScreenUtil.getInstance().getWidth(10.0),
//              right: ScreenUtil.getInstance().getWidth(10.0),
                  top: ScreenUtil.getInstance().getWidth(10.0),
                  bottom: ScreenUtil.getInstance().getWidth(10.0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 标签
                    Container(
                      width: ScreenUtil.getInstance().getAdapterSize(4.0),
                      height: ScreenUtil.getInstance().getAdapterSize(16.0),
                      decoration: BoxDecoration(
                        color: ResourceColors.theme_background,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      ),
                    ),
                    // 标签名
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.only(
                          left: ScreenUtil.getInstance().getWidth(8.0),
                          right: ScreenUtil.getInstance().getWidth(8.0),
                          bottom: Platform.isIOS ? 0 : ScreenUtil.getInstance().getAdapterSize(1.0),
                        ),
                        child: Text("团队业绩",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil.getInstance().getSp(14.0),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    // 周、月、年
                    Expanded(
                      flex: 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   widget.businessType = BusinessType.WEEK;
                                // });
                                widget.businessType = BusinessType.WEEK;
                                _teamAchievementController.sink.add(true);
                                if (widget.countBeanWeek == null) {
                                  _getAgentTeamBusinessForTime();
                                }
                              },
                              child: Center(
                                child: Text("周",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.businessType == BusinessType.WEEK ? Colors.deepPurpleAccent : ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   widget.businessType = BusinessType.MONTH;
                                // });
                                widget.businessType = BusinessType.MONTH;
                                _teamAchievementController.sink.add(true);
                                if (widget.countBeanMonth == null) {
                                  _getAgentTeamBusinessForTime();
                                }
                              },
                              child: Center(
                                child: Text("月",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.businessType == BusinessType.MONTH ? Colors.deepPurpleAccent : ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                // setState(() {
                                //   widget.businessType = BusinessType.YEAY;
                                // });
                                widget.businessType = BusinessType.YEAY;
                                _teamAchievementController.sink.add(true);
                                if (widget.countBeanYear == null) {
                                  _getAgentTeamBusinessForTime();
                                }
                              },
                              child: Center(
                                child: Text("年",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: widget.businessType == BusinessType.YEAY ? Colors.deepPurpleAccent : ResourceColors.gray_99,
                                    fontSize: ScreenUtil.getInstance().getSp(14.0),
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(10.0)),
                            decoration: BoxDecoration(
                                color: ResourceColors.theme_background,
                                shape: BoxShape.circle
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.account_balance_wallet, color: Colors.white, size: ScreenUtil.getInstance().getSp(18.0),),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: ScreenUtil.getInstance().getAdapterSize(8.0),
                                right: ScreenUtil.getInstance().getAdapterSize(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("进货额（元）"),
                                  Text(
                                      widget.businessType == BusinessType.WEEK ? TextUtil.formatComma3(widget.countBeanWeek != null ? "${widget.countBeanWeek!.purchaseAmount}" : "-")
                                          :
                                      widget.businessType == BusinessType.MONTH ? TextUtil.formatComma3(widget.countBeanMonth != null ? "${widget.countBeanMonth!.purchaseAmount}" : "-")
                                          :
                                      TextUtil.formatComma3(widget.countBeanYear != null ? "${widget.countBeanYear!.purchaseAmount}" : "-")
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    height: ScreenUtil.getInstance().getAdapterSize(50.0),
                    color: ResourceColors.divider,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(10.0)),
                            decoration: BoxDecoration(
                                color: ResourceColors.theme_background,
                                shape: BoxShape.circle
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.account_balance_wallet, color: Colors.white, size: ScreenUtil.getInstance().getSp(18.0),),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: ScreenUtil.getInstance().getAdapterSize(8.0),
                                right: ScreenUtil.getInstance().getAdapterSize(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("销售额（元）"),
                                  Text(
                                      widget.businessType == BusinessType.WEEK ? TextUtil.formatComma3(widget.countBeanWeek != null ? "${widget.countBeanWeek!.saleAmount}" : "-")
                                          :
                                      widget.businessType == BusinessType.MONTH ? TextUtil.formatComma3(widget.countBeanMonth != null ? "${widget.countBeanMonth!.saleAmount}" : "-")
                                          :
                                      TextUtil.formatComma3(widget.countBeanYear != null ? "${widget.countBeanYear!.saleAmount}" : "-")
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: ResourceColors.divider,
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().getAdapterSize(20.0),
                        right: ScreenUtil.getInstance().getAdapterSize(20.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.0,
                      color: ResourceColors.divider,
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().getAdapterSize(20.0),
                        right: ScreenUtil.getInstance().getAdapterSize(20.0),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(10.0)),
                            decoration: BoxDecoration(
                                color: ResourceColors.theme_background,
                                shape: BoxShape.circle
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.account_balance_wallet, color: Colors.white, size: ScreenUtil.getInstance().getSp(18.0),),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: ScreenUtil.getInstance().getAdapterSize(8.0),
                                right: ScreenUtil.getInstance().getAdapterSize(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("新代理（人）"),
                                  Text(
                                      widget.businessType == BusinessType.WEEK ? TextUtil.formatComma3(widget.countBeanWeek != null ? "${widget.countBeanWeek!.newAgents}" : "-")
                                          :
                                      widget.businessType == BusinessType.MONTH ? TextUtil.formatComma3(widget.countBeanMonth != null ? "${widget.countBeanMonth!.newAgents}" : "-")
                                          :
                                      TextUtil.formatComma3(widget.countBeanYear != null ? "${widget.countBeanYear!.newAgents}" : "-")
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 1.0,
                    height: ScreenUtil.getInstance().getAdapterSize(50.0),
                    color: ResourceColors.divider,
                  ),
                  Expanded(
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: ScreenUtil.getInstance().getAdapterSize(10.0)),
                            decoration: BoxDecoration(
                                color: ResourceColors.theme_background,
                                shape: BoxShape.circle
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.account_balance_wallet, color: Colors.white, size: ScreenUtil.getInstance().getSp(18.0),),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(
                                left: ScreenUtil.getInstance().getAdapterSize(8.0),
                                right: ScreenUtil.getInstance().getAdapterSize(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("新升级（人"),
                                  Text(
                                      widget.businessType == BusinessType.WEEK ? TextUtil.formatComma3(widget.countBeanWeek != null ? "${widget.countBeanWeek!.newUpgrade}" : "-")
                                          :
                                      widget.businessType == BusinessType.MONTH ? TextUtil.formatComma3(widget.countBeanMonth != null ? "${widget.countBeanMonth!.newUpgrade}" : "-")
                                          :
                                      TextUtil.formatComma3(widget.countBeanYear != null ? "${widget.countBeanYear!.newUpgrade}" : "-")
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}