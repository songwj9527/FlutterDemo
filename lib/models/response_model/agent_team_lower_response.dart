import 'package:flutter_demo_app/models/base/base_response.dart';

class AgentTeamLowerResponse extends BaseResponse<AgentTeamLowerResult> {
  AgentTeamLowerResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? AgentTeamLowerResult.fromJson(json['Result']) : null;
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
/// lowers : [{"organization_id":10012,"organization_name":"zz","level_id":900000000000,"upper_id":10011,"create_time":1602985001600,"level_name":"市代","level_val":20,"GUID":800000000012,"TXID":null,"YHXM":"zz","logistic_qty":0}]
class AgentTeamLowerResult {
  List<AgentLowerBean>? lowers;

  AgentTeamLowerResult.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.lowers = ((map['lowers'] != null && map['lowers'] is List)) ? ((map['lowers'] as List).map((o) => AgentLowerBean.fromJson(o)).toList()) : null;
  }

  Map<String, dynamic> toJson() => {
    "lowers": lowers != null ? lowers?.map((e) => e.toJson()).toList() : null,
  };
}

/// organization_id : 10012
/// organization_name : "zz"
/// level_id : 900000000000
/// upper_id : 10011
/// create_time : 1602985001600
/// level_name : "市代"
/// level_val : 20
/// GUID : 800000000012
/// TXID : null
/// YHXM : "zz"
/// logistic_qty : 0

class AgentLowerBean {
  num? organizationId;
  String? organizationName;
  num? levelId;
  num? upperId;
  num? createTime;
  String? levelName;
  num? levelVal;
  num? GUID;
  num? TXID;
  String? YHXM;
  num? logisticQty;

  AgentLowerBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.organizationId = map['organization_id'];
    this.organizationName = map['organization_name'];
    this.levelId = map['level_id'];
    this.upperId = map['upper_id'];
    this.createTime = map['create_time'];
    this.levelName = map['level_name'];
    this.levelVal = map['level_val'];
    this.GUID = map['GUID'];
    this.TXID = map['TXID'];
    this.YHXM = map['YHXM'];
    this.logisticQty = map['logistic_qty'];
  }

  Map<String, dynamic> toJson() => {
    "organization_id": organizationId,
    "organization_name": organizationName,
    "level_id": levelId,
    "upper_id": upperId,
    "create_time": createTime,
    "level_name": levelName,
    "level_val": levelVal,
    "GUID": GUID,
    "TXID": TXID,
    "YHXM": YHXM,
    "logistic_qty": logisticQty,
  };
}