import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_demo_app/models/response_model/version_response.dart';

import '../constants.dart';
import '../http_util.dart';
import '../net_client.dart';

class VersionApi {
  /// 线上app版本信息
  static Stream<VersionResponse> getAppOnlineVersion({CancelToken? cancelToken}) {
    String url = "${Constants.BASE_URL()}${Constants.GET_APP_ONLINE_VERSION}";
    var paramsMap = HttpUtil.combineApiCommonParamsWithCommonParamMap("", payload: false);
    var paramsUrl = "$url${HttpUtil.apiCommonParamsToString(paramsMap)}";
    return NetClient.instance.request(Method.get, paramsUrl, cancelToken: cancelToken)
        .asStream()
        .map((result) {
      VersionResponse model;
      try {
        model = VersionResponse.fromJson(result);
      } catch (e) {
        LogUtil.e(">>>> VersionResponse.fromJson error: ${e.toString()}");
        model = VersionResponse.fromJson({
          "Code": -100004,
          "Message": e.toString(),
          "Result": null,
        });
      }
      return model;
    });
  }
}