import 'package:flutter_demo_app/models/base/base_response.dart';

class FileUploadResponse extends BaseResponse<FileUploadResult> {

  FileUploadResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.Message = json['Message'];
    this.Code = json['Code'];
    this.Result = json['Result'] != null ? FileUploadResult.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() =>
      {
        "Code": Code,
        "Message": Message,
        "Result": Result != null ? Result?.toJson() : null,
      };
}

class FileUploadResult {
  num? fileId;

  FileUploadResult({this.fileId});

  FileUploadResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return;
    }
    this.fileId = json['file_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['file_id'] = this.fileId;
    return data;
  }

}
