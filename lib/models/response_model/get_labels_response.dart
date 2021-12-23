import 'package:flutter_demo_app/models/base/base_response.dart';

class GetLabelsResponse extends BaseResponse<GetLabelsResponseBean> {

  GetLabelsResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? GetLabelsResponseBean.fromJson(json['Result']) : null;
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


/// labels : [{"GUID":1,"BQLX":"0","BQMC":"标签1","BQYS":"#CCCCCFF","CJR":800000000000,"CJSJ":1598974892434,"update_user":800000000000,"update_time":1598975030986,"ZTBS":"E","create_name":"总部管理员","update_name":"总部管理员"}]
class GetLabelsResponseBean {
  List<LabelsBean>? labels;

  GetLabelsResponseBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.labels = (map['labels'] != null && map['labels'] is List) ? (map['labels'] as List).map((o) => LabelsBean.fromJson(o)).toList() : null;
  }

  Map<String, dynamic> toJson() => {
    "labels": labels != null ? labels?.map((e) => e.toJson()).toList() : null,
  };
}

/// GUID : 1
/// BQLX : "0"
/// BQMC : "标签1"
/// BQYS : "#CCCCCFF"
/// CJR : 800000000000
/// CJSJ : 1598974892434
/// update_user : 800000000000
/// update_time : 1598975030986
/// ZTBS : "E"
/// create_name : "总部管理员"
/// update_name : "总部管理员"

class LabelsBean {
  num? GUID;
  String? BQLX;
  String? BQMC;
  String? BQYS;
  num? CJR;
  num? CJSJ;
  num? updateUser;
  num? updateTime;
  String? ZTBS;
  String? createName;
  String? updateName;

  LabelsBean.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    this.GUID = json['GUID'];
    this.BQLX = json['BQLX'];
    this.BQMC = json['BQMC'];
    this.BQYS = json['BQYS'];
    this.CJR = json['CJR'];
    this.CJSJ = json['CJSJ'];
    this.updateUser = json['update_user'];
    this.updateTime = json['update_time'];
    this.ZTBS = json['ZTBS'];
    this.createName = json['create_name'];
    this.updateName = json['update_name'];
  }

  Map<String, dynamic> toJson() => {
    "GUID": GUID,
    "BQLX": BQLX,
    "BQMC": BQMC,
    "BQYS": BQYS,
    "CJR": CJR,
    "CJSJ": CJSJ,
    "update_user": updateUser,
    "update_time": updateTime,
    "ZTBS": ZTBS,
    "create_name": createName,
    "update_name": updateName,
  };
}