import 'package:flutter_demo_app/models/base/base_response.dart';

class MaterialResponse extends BaseResponse<MaterialResponseBean> {

  MaterialResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? MaterialResponseBean.fromJson(json['Result']) : null;
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
/// materials : [{"GUID":3,"SCLX":"1","SCZY":"素材2","SCWA":"素材圈第一条素材","GKLX":null,"SHZT":"1","CJR":800000000000,"CJSJ":1599064397970,"update_user":null,"update_time":null,"ZTBS":"E","create_name":"总部管理员","update_name":null,"avatar_id":null,"create_user_des":"用户描述","labels":[{"DXID":3,"BQID":4,"BQMC":"素材标签1","BQYS":"#98F5FF"}],"files":[900000000021],"likes":0,"comments":0,"forwards":0,"collects":0}]
class MaterialResponseBean {
  int? total;
  List<MaterialsBean>? materials;

  MaterialResponseBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.total = map['total'];
    this.materials = (map['materials'] != null && map['materials'] is List) ? (map['materials'] as List).map((o) => MaterialsBean.fromJson(o)).toList() : null;
  }

  Map<String, dynamic> toJson() => {
    "total": total,
    "materials": materials != null ? materials?.map((e) => e.toJson()).toList() : null,
  };
}

/// GUID : 3
/// SCLX : "1"
/// SCZY : "素材2"
/// SCWA : "素材圈第一条素材"
/// GKLX : null
/// SHZT : "1"
/// CJR : 800000000000
/// CJSJ : 1599064397970
/// update_user : null
/// update_time : null
/// ZTBS : "E"
/// create_name : "总部管理员"
/// update_name : null
/// avatar_id : null
/// create_user_des : "用户描述"
/// labels : [{"DXID":3,"BQID":4,"BQMC":"素材标签1","BQYS":"#98F5FF"}]
/// files : [900000000021]
/// likes : 0
/// comments : 0
/// forwards : 0
/// collects : 0

class MaterialsBean {
  num? GUID;
  String? SCLX;
  String? SCZY;
  String? SCWA;
  String? GKLX;
  String? SHZT;
  num? CJR;
  num? CJSJ;
  num? updateUser;
  num? updateTime;
  String? ZTBS;
  String? createName;
  String? updateName;
  num? avatarId;
  String? createUserDes;
  List<MeterialLabelsBean>? labels;
  List<num>? files;
  num? likes;
  num? comments;
  num? forwards;
  num? collects;
  bool? isLike;
  bool? isCollect;

  MaterialsBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.GUID = map['GUID'];
    this.SCLX = map['SCLX'];
    this.SCZY = map['SCZY'];
    this.SCWA = map['SCWA'];
    this.GKLX = map['GKLX'];
    this.SHZT = map['SHZT'];
    this.CJR = map['CJR'];
    this.CJSJ = map['CJSJ'];
    this.updateUser = map['update_user'];
    this.updateTime = map['update_time'];
    this.ZTBS = map['ZTBS'];
    this.createName = map['create_name'];
    this.updateName = map['update_name'];
    this.avatarId = map['avatar_id'];
    this.createUserDes = map['create_user_des'];
    this.labels = (map['labels'] != null && map['labels'] is List) ? (map['labels'] as List).map((o) => MeterialLabelsBean.fromJson(o)).toList() : null;
    this.files = (map['files'] != null && map['files'] is List) ? (map['files'] as List).map((o) => num.parse(o.toString())).toList() : null;
    this.likes = map['likes'];
    this.comments = map['comments'];
    this.forwards = map['forwards'];
    this.collects = map['collects'];
    this.isLike = map['is_like'];
    this.isCollect = map['is_collect'];
  }

  Map<String, dynamic> toJson() => {
    "GUID": GUID,
    "SCLX": SCLX,
    "SCZY": SCZY,
    "SCWA": SCWA,
    "GKLX": GKLX,
    "SHZT": SHZT,
    "CJR": CJR,
    "CJSJ": CJSJ,
    "update_user": updateUser,
    "update_time": updateTime,
    "ZTBS": ZTBS,
    "create_name": createName,
    "update_name": updateName,
    "avatar_id": avatarId,
    "create_user_des": createUserDes,
    "labels": labels != null ? labels?.map((e) => e.toJson()).toList() : null,
    "files": files,
    "likes": likes,
    "comments": comments,
    "forwards": forwards,
    "collects": collects,
    "is_like": isLike,
    "is_collect": isCollect,
  };
}

/// DXID : 3
/// BQID : 4
/// BQMC : "素材标签1"
/// BQYS : "#98F5FF"

class MeterialLabelsBean {
  num? DXID;
  num? BQID;
  String? BQMC;
  String? BQYS;

  MeterialLabelsBean.fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    this.DXID = map['DXID'];
    this.BQID = map['BQID'];
    this.BQMC = map['BQMC'];
    this.BQYS = map['BQYS'];
  }

  Map<String, dynamic> toJson() => {
    "DXID": DXID,
    "BQID": BQID,
    "BQMC": BQMC,
    "BQYS": BQYS,
  };
}