import 'dart:convert';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter_demo_app/common/event_bus/event_bus_helper.dart';
import 'package:flutter_demo_app/common/event_bus/token_timeout_event.dart';

const CONNECTION_TIMEOUT = 1000 * 15;
const RECEIVE_TIMEOUT = 1000 * 30;
const SEND_TIMEOUT = 1000 * 35;
///Http配置.
class Configure {
  /// constructor.
  Configure({
    this.connectTimeout,
    this.receiveTimeout,
    this.sendTimeout,
    this.isLogPrint,
    this.pem,
    this.pkcsPath,
    this.plcsPassword
  });

  /// 连接超时时间
  int? connectTimeout = CONNECTION_TIMEOUT;
  /// 接收超时时间
  int? receiveTimeout = RECEIVE_TIMEOUT;
  /// 发送超时时间
  int? sendTimeout = SEND_TIMEOUT;

  /// 是否开启http日志
  bool? isLogPrint = true;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PEM证书内容.
  String? pem;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书路径.
  String? pkcsPath;

  /// 详细使用请查看dio官网 https://github.com/flutterchina/dio/blob/flutter/README-ZH.md#Https证书校验.
  /// PKCS12 证书密码.
  String? plcsPassword;
}

/// 请求方法.
class Method {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}

class NetClient {
  static final NetClient _singleton = NetClient._init();
  static Dio? _dio;

  static NetClient get instance => _singleton;

  factory NetClient() {
    return _singleton;
  }

  NetClient._init() {
    _dio = Dio();
  }

  /// 连接超时时间
  int _connectTimeout = CONNECTION_TIMEOUT;
  /// 接收超时时间
  int _receiveTimeout = RECEIVE_TIMEOUT;
  /// 发送超时时间
  int _sendTimeout = SEND_TIMEOUT;

  /// 是否开启http日志
  bool _isLogPrint = true;

  /// PEM证书内容.
  String? _pem;

  /// PKCS12 证书路径.
  String? _pkcsPath;

  /// PKCS12 证书密码.
  String? _plcsPassword;

  void build(Configure configure) {
    if (configure != null) {
      _connectTimeout = configure.connectTimeout??CONNECTION_TIMEOUT;
      _receiveTimeout = configure.receiveTimeout??RECEIVE_TIMEOUT;
      _sendTimeout = configure.sendTimeout??SEND_TIMEOUT;
      _isLogPrint = configure.isLogPrint??false;
      _pem = configure.pem??"";
      _pkcsPath = configure.pkcsPath??"";
      _plcsPassword = configure.pkcsPath??"";
    }

    if (_dio != null) {
      /// 开启请求日志
      _dio?.interceptors.add(LogInterceptor(
        requestHeader: _isLogPrint,
        requestBody: _isLogPrint,
        request: _isLogPrint,
        responseHeader: _isLogPrint,
        responseBody: _isLogPrint,)
      );

      /// PEM证书内容
      if (!TextUtil.isEmpty(_pem)) {
        ConnectionManager connectionManager = ConnectionManager(
            onClientCreate: (_, clientSetting) => {
              clientSetting.onBadCertificate = (X509Certificate certificate) {
                if (certificate.pem == _pem) {
                  // 证书一致，则放行
                  return true;
                }
                return false;
              }
            }
        );
        _dio?.httpClientAdapter = Http2Adapter(connectionManager);
      }

      /// PKCS12 证书
      if (!TextUtil.isEmpty(_pkcsPath)) {
        ConnectionManager connectionManager = ConnectionManager(
            onClientCreate: (_, clientSetting) {
              SecurityContext securityContext = new SecurityContext();
              //file为证书路径
              securityContext.setTrustedCertificates(_pkcsPath!, password: _plcsPassword);
              clientSetting.context = securityContext;
            }
        );
        _dio?.httpClientAdapter = Http2Adapter(connectionManager);
      }

      /// cookie
      /// cache

//      /// json string数据转换成 json map
//      dio.transformer = FlutterTransformer();

      _dio?.options = BaseOptions(
        connectTimeout: _connectTimeout,
        receiveTimeout: _receiveTimeout,
        sendTimeout: _sendTimeout,
        contentType: ContentType.parse("application/json").charset,
      );
    }
  }

  /// method：请求类型，GET、POST、PUT、HEAD、DELETE、PATCH
  /// path：请求路径，如果为全路径（https://www.devio.org/list/task?key=123），则options无需填充baseUrl；
  ///               如果为非域名路径/list/task?key=123，options需填充baseUrl：https://www.devio.org
  /// data：传入数据，一般为POST、PUT、DELETE、PATCH包体body数据
  /// options：配置信息，如请求类型、超时时间、contentType、baseUrl等
  /// contentType：contentType类型
  /// cancelToken：请求的取消token，可用于主动取消网络请求
  Future<Map<String, dynamic>> request(String method, String path,
      {
        String? baseUrl,
        data,
        Options? options,
        ContentType? contentType,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) {
    return _dio!.request(path,
      data: data,
      options: options??Options(
        method: method??'GET',
        sendTimeout: _sendTimeout,
        receiveTimeout: _receiveTimeout,
        contentType: (contentType != null) ? contentType.charset : (ContentType.parse("application/json").charset),//ContentType.parse("application/x-www-form-urlencoded;charset=utf-8").charset,
      ),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    ).then((response) {
        String _msg = "";
        Map<String, dynamic> _data;
        if (response.statusCode == HttpStatus.ok ||
            response.statusCode == HttpStatus.created) {
          try {
            if (response.data is Map) {
              LogUtil.e("NetClient", tag: "response data is map");
              _data = response.data;
            } else {
              LogUtil.e("NetClient", tag: "response data is string");
              _data = _decodeData(response);
            }
            if (cancelToken != null && !cancelToken.isCancelled) {
              cancelToken.cancel();
            }
            // token失效
            if (_data["Code"] != null && ("${_data["Code"]}").compareTo("-200") == 0) {
              EventBusHelper.instance.fire<TokenTimeoutEvent>(TokenTimeoutEvent());
            }
            return _data;
          } catch (e) {
            LogUtil.e("NetClient", tag: "DioError: ${e}");
            if (cancelToken != null && !cancelToken.isCancelled) {
              cancelToken.cancel();
            }
            _data = Map<String, dynamic>();
            _data["Code"] = -100000;
            _data["Message"] = _msg;
            return _data;
          }
        }
        if (cancelToken != null && !cancelToken.isCancelled) {
          cancelToken.cancel();
        }
        _data = Map<String, dynamic>();
        _data["Code"] = response.statusCode;
        _data["Message"] = _msg;
        return _data;
      },
      onError: (error) {
          LogUtil.e("NetClient", tag: "DioError: ${error.toString()}");
          if (error is DioError) {
            var _data = Map<String, dynamic>();
            _data["Code"] = -100001;
            switch (error.type) {
              case DioErrorType.connectTimeout:
                _data["Message"] = "CONNECT_TIMEOUT";
                break;
              case DioErrorType.sendTimeout:
                _data["Message"] = "SEND_TIMEOUT";
                break;
              case DioErrorType.receiveTimeout:
                _data["Message"] = "RECEIVE_TIMEOUT";
                break;
              case DioErrorType.response:
                _data["Message"] = "RESPONSE";
                break;
              case DioErrorType.cancel:
                _data["Message"] = "CANCEL";
                break;
              case DioErrorType.other:
                _data["Message"] = "OTHER";
                break;
            }
            return _data;
          } else {
            var _data = Map<String, dynamic>();
            _data["Code"] = -100002;
            _data["Message"] = error.toString();
            return _data;
          }
      },
    ).catchError((error) {
        var _data = Map<String, dynamic>();
        _data["Code"] = -100003;
        _data["Message"] = error.toString();
        return _data;
      },
    );
  }

  /// Download the file and save it in local. The default http method is "GET",you can custom it by [Options.method].
  /// [urlPath]: The file url.
  /// [savePath]: The path to save the downloading file later.
  /// [onProgress]: The callback to listen downloading progress.please refer to [OnDownloadProgress].
  Future<Response> download(
      String urlPath,
      savePath,
      {
        ProgressCallback? onProgress,
        CancelToken? cancelToken,
        data,
        Options? options,
      }) {
    return _dio!.download(
      urlPath,
      savePath,
      onReceiveProgress: onProgress,
      cancelToken: cancelToken,
      data: data,
      options: options??Options(
          // connectTimeout: _connectTimeout,
          sendTimeout: _sendTimeout,
          receiveTimeout: _receiveTimeout,
          contentType: ContentType.parse("application/json").charset
      ),
    );
  }

  Future<Response> getDownload(String urlPath,
      {
        ProgressCallback? onProgress,
        CancelToken? cancelToken,
        data,
        Options? options,
      }) {
    return _dio!.get(urlPath,
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
        options: options??Options(
            sendTimeout: _sendTimeout,
            receiveTimeout: _receiveTimeout,
            // contentType: ContentType.parse("application/json").charset
            responseType: ResponseType.bytes
        ));
  }

  /// 将response data转换成Map
  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null) {
      return Map<String, dynamic>();
    }
    if (response.data is Map<String, dynamic>) {
      return response.data;
    }
    if (response.data.toString().isEmpty) {
      return Map<String, dynamic>();
    }
    return json.decode(response.data.toString());
  }
}