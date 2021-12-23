import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_demo_app/models/response_model/file_upload_response.dart';

import '../constants.dart';
import '../http_util.dart';
import '../net_client.dart';

class FileApi {

  /// 文件上传
  static Future<Stream<FileUploadResponse>> uploadFile(File file,
      {
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    String path = file.path;
    var name = file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
    var imageType = name.substring(name.lastIndexOf(".") + 1, name.length);
    var postData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: name)
    });
    String url = "${Constants.BASE_URL()}${Constants.UPLOAD_FILE}";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("");
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return NetClient.instance.request(Method.post, paramsUrl, data: postData, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress)
        .asStream()
        .map((result) {
          FileUploadResponse model;
          try {
            model = FileUploadResponse.fromJson(result);
          } catch (e) {
            LogUtil.e(">>>> FileUploadResponse.fromJson error: ${e.toString()}");
            model = FileUploadResponse.fromJson({
              "Code": -100004,
              "Message": e.toString(),
              "Result": null,
            });
          }
          return model;
        });
  }

  /// 文件上传（不签名）
  static Future<Stream<FileUploadResponse>> uploadFileSpecial(File file,
      {
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    String path = file.path;
    var name = file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
    var imageType = name.substring(name.lastIndexOf(".") + 1, name.length);
    var postData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: name)
    });
    String url = "${Constants.BASE_URL()}${Constants.UPLOAD_FILE_SPECIAL}";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("");
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return NetClient.instance.request(Method.post, paramsUrl, data: postData, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress)
        .asStream()
        .map((result) {
          FileUploadResponse model;
          try {
            model = FileUploadResponse.fromJson(result);
          } catch (e) {
            LogUtil.e(">>>> FileUploadResponse.fromJson error: ${e.toString()}");
            model = FileUploadResponse.fromJson({
              "Code": -100004,
              "Message": e.toString(),
              "Result": null,
            });
          }
          return model;
        });
  }

  /// 获取文件地址
  static String getFileUrl(num fileId, {bool watermark: false}) {
    String url = "${Constants.BASE_URL()}${Constants.DOWNLOAD_FILE}$fileId${watermark ? "/1" : ""}";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("");
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return paramsUrl;
  }

  /// 获取文件地址
  static String getFileUrlSpecial(num fileId) {
    String url = "${Constants.BASE_URL()}${Constants.DOWNLOAD_FILE}$fileId${Constants.DOWNLOAD_FILE_SPECIAL}";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("");
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return paramsUrl;
  }

  /// 文件下载
  static String downloadFile(num fileId, String path, {CancelToken? cancelToken, ProgressCallback? onReceiveProgress}) {
    String url = "${Constants.BASE_URL()}${Constants.DOWNLOAD_FILE}$fileId";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("");
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return paramsUrl;
  }

  /// 文件下载（不签名）
  static String downloadFileSpecial(num fileId, String path, {CancelToken? cancelToken, ProgressCallback? onReceiveProgress}) {
    String url = "${Constants.BASE_URL()}${Constants.DOWNLOAD_FILE}$fileId${Constants.DOWNLOAD_FILE_SPECIAL}";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("");
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return paramsUrl;
  }
}