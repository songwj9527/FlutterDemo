import 'package:flutter_demo_app/models/base/base_response.dart';

class AgentTeamResponse extends BaseResponse<AgentTeamBean> {

  AgentTeamResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? AgentTeamBean.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Message'] = this.Message;
    data['Code'] = this.Code;
    if (this.Result != null) {
      data['Result'] = this.Result?.toJson();
    }
    return data;
  }
}

class AgentTeamBean {
  num? agentsSum;
  List<LevelsListBean>? levels;

  AgentTeamBean({this.agentsSum, this.levels});

  AgentTeamBean.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.agentsSum = json['agents_sum'];
    this.levels = (json['levels'] != null && json['levels'] is List) ? (json['levels'] as List).map((i) => LevelsListBean.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['agents_sum'] = this.agentsSum;
    data['levels'] = this.levels != null ? this.levels?.map((i) => i.toJson()).toList() : null;
    return data;
  }

}

class LevelsListBean {
  String? levelName;
  num? levelVal;
  int? number;
  num? levelId;

  LevelsListBean({this.levelName, this.levelVal, this.number, this.levelId});

  LevelsListBean.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.levelName = json['level_name'];
    this.levelVal = json['level_val'];
    this.number = json['number'];
    this.levelId = json['level_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['level_name'] = this.levelName;
    data['level_val'] = this.levelVal;
    data['number'] = this.number;
    data['level_id'] = this.levelId;
    return data;
  }
}
