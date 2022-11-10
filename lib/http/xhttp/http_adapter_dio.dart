import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'http_adapter.dart';
import 'http_exception.dart';
import 'http_localizations.dart';

class HttpAdapterDio extends HttpAdapter {
  static final BaseOptions _options = BaseOptions(
    // 连接服务器超时时间，单位是毫秒.
    connectTimeout: 30000,
    // 响应流上前后两次接受到数据的间隔，单位为毫秒。
    receiveTimeout: 30000,
    // 发送请求超时时间
    sendTimeout: 30000,
    // 期望接受响应格式。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`,
    responseType: ResponseType.plain,
  );

  @override
  Future<String?> getRequest(BuildContext context, String url, {Map<String, String>? headers}) async {
    try {
      var response = await Dio(_options).get(url, options: Options(headers: headers)).timeout(HttpAdapter.timeoutSeconds);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw MsgException(1001, HttpLocalizations.of(context).current.HttpError + response.statusCode.toString());
      }
    } on DioError {
      throw MsgException(1000, HttpLocalizations.of(context).current.NetError);
    }
  }

  @override
  Future<String?> multipartRequest(BuildContext context, String url, {Map<String, String>? headers, Map<String, dynamic>? bodyArgs, required List<String> files}) async {
    try {
      var uri = Uri.parse(url);
      var formData = FormData.fromMap(bodyArgs ?? {});
      formData.files.addAll(List.generate(files.length, (index) => MapEntry("files", MultipartFile.fromFileSync(files[index], filename: files[index].split("/").last))));
      var response = Dio(_options).postUri(uri, data: formData, options: Options(headers: headers)).timeout(HttpAdapter.timeoutSeconds);
      String result = "";
      await response.asStream().listen((value) => result = value.toString()).asFuture();
      return result;
    } on DioError {
      throw MsgException(1000, HttpLocalizations.of(context).current.HttpError);
    }
  }

  @override
  Future<String?> postRequest(BuildContext context, String url, {Map<String, String>? headers, String? body}) async {
    try {
      var response = await Dio(_options).postUri(
        Uri.parse(url),
        options: Options(headers: headers),
        data: body,
      );
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw MsgException(1001, HttpLocalizations.of(context).current.HttpError + response.statusCode.toString());
      }
    } on DioError catch (e) {
      throw MsgException(1000, HttpLocalizations.of(context).current.NetError);
    }
  }
}
