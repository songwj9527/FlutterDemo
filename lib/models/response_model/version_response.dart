import 'package:flutter_demo_app/models/base/base_response.dart';

class VersionResponse extends BaseResponse<VersionResultBean> {

  VersionResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? VersionResultBean.fromJson(json['Result']) : null;
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

class VersionResultBean {
  ClientBean? client;

  VersionResultBean({this.client});

  VersionResultBean.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.client = json['client'] != null ? ClientBean.fromJson(json['client']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['client'] = this.client != null ? this.client?.toJson() : null;
    return data;
  }
}

class ClientBean {
  num? GUID;
  String? YYCXM;
  String? XBBH;
  String? ZDBBH;
  String? XZDZ;
  ApplicationBean? android;
  ApplicationBean? ios;

  ClientBean({this.GUID, this.YYCXM, this.XBBH, this.ZDBBH, this.XZDZ, this.android, this.ios});

  ClientBean.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.GUID = json['GUID'];
    this.YYCXM= json['YYCXM'];
    this.XBBH = json['XBBH'];
    this.ZDBBH = json['ZDBBH'];
    this.XZDZ = json['XZDZ'];
    this.android = json['android'] != null ? ApplicationBean.fromJson(json['android']) : null;
    this.ios = json['ios'] != null ? ApplicationBean.fromJson(json['ios']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['GUID'] = this.GUID;
    data['YYCXM'] = this.YYCXM;
    data['XBBH'] = this.XBBH;
    data['ZDBBH'] = this.ZDBBH;
    data['XZDZ'] = this.XZDZ;
    data['android'] = this.android != null ? this.android?.toJson() : null;
    data['ios'] = this.ios != null ? this.ios?.toJson() : null;
    return data;
  }
}

class ApplicationBean {
  String? XBBH;
  String? ZDBBH;
  String? XZDZ;

  ApplicationBean({this.XBBH, this.ZDBBH, this.XZDZ});

  ApplicationBean.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.XBBH = json['XBBH'];
    this.ZDBBH = json['ZDBBH'];
    this.XZDZ = json['XZDZ'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['XBBH'] = this.XBBH;
    data['ZDBBH'] = this.ZDBBH;
    data['XZDZ'] = this.XZDZ;
    return data;
  }
}