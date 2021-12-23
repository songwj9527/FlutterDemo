import 'package:flutter_demo_app/models/base/base_response.dart';

class AgentTeamBusinessResponse extends BaseResponse<AgentTeamBusinessResult> {

  AgentTeamBusinessResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? AgentTeamBusinessResult.fromJson(json['Result']) : null;
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

class AgentTeamBusinessResult {
  CountBean? count;

  AgentTeamBusinessResult({this.count});

  AgentTeamBusinessResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.count = json['count'] != null ? CountBean.fromJson(json['count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.count != null) {
      data['count'] = this.count?.toJson();
    }
    return data;
  }

}

class CountBean {
  num? purchaseAmount;
  num? newAgents;
  num? newUpgrade;
  num? saleAmount;

  CountBean({this.purchaseAmount, this.newAgents, this.newUpgrade, this.saleAmount});

  CountBean.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.purchaseAmount = json['purchase_amount'];
    this.newAgents = json['new_agents'];
    this.newUpgrade = json['new_upgrade'];
    this.saleAmount = json['sale_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['purchase_amount'] = this.purchaseAmount;
    data['new_agents'] = this.newAgents;
    data['new_upgrade'] = this.newUpgrade;
    data['sale_amount'] = this.saleAmount;
    return data;
  }
}
