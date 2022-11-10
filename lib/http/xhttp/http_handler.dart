import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'http_adapter.dart';
import 'http_adapter_dio.dart';

/// HTTP请求工具
/// Created by czy on 2020/12/15.
class HttpUtils {
  static final HttpAdapter httpAdapter = HttpAdapterDio();
  static const String contentType = "content-type";

  static String buildUrl(String rootUrl, String callUrl, Map<String, dynamic>? urlArgs) {
    var url = StringBuffer(rootUrl.endsWith('/') ? rootUrl.substring(0, rootUrl.length - 1) : rootUrl);
    if (!callUrl.startsWith('/')) url.write('/');
    url.write(callUrl);
    if (urlArgs != null && urlArgs.isNotEmpty) {
      if (callUrl.contains('?')) {
        url.write('&');
      } else {
        url.write('?');
      }
      urlArgs.forEach((key, value) {
        url.write(key);
        url.write('=');
        url.write(value);
        url.write('&');
      });
    }
    return url.toString();
  }

  static Future<String?> getRequest(BuildContext context, String url, {Map<String, String>? headers}) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    String process = startTime.toString().substring(9);
    print("${process}-http-get-path: $url");
    print("${process}-http-get-head: Origin:${headers?['Origin']} token:${headers?['token']}  _ds:${headers?['_ds']}");
    return httpAdapter.getRequest(context, url, headers: headers).then((result) {
      print("${process}-http-get-resp: ${result}");
      print("${process}-http-get-time: ${DateTime.now().millisecondsSinceEpoch - startTime}ms");
      return result;
    });
  }

  static Future<String?> multipartRequest(BuildContext context, String url, {Map<String, String>? headers, Map<String, dynamic>? bodyArgs, required List<String> filePaths}) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    String process = startTime.toString().substring(9);
    // LogUtil.v("$process-http-multi-path: $url");
    // LogUtil.v("$process-http-multi-head: Origin:${headers?['Origin']} token:${headers?['token']}  _ds:${headers?['_ds']}");
    // LogUtil.v("$process-http-multi-body: " + json.encode(bodyArgs));
    return httpAdapter.multipartRequest(context, url, headers: headers, bodyArgs: bodyArgs, files: filePaths).then((result) {
      print("${process}-http-multi-resp: ${result}");
      print("${process}-http-multi-time: ${DateTime.now().millisecondsSinceEpoch - startTime}ms");
      return result;
    });
  }

  static Future<String?> postRequest(BuildContext context, String url, {Map<String, String>? headers, Object? bodyArgs}) {
    var body = bodyArgs != null ? json.encode(bodyArgs) : '{}';
    //if (!StringUtils.isEmpty(DConsts.headerDS)) headers!["_ds"] = DConsts.headerDS;
    int startTime = DateTime.now().millisecondsSinceEpoch;
    String process = startTime.toString().substring(9);
    print("${process}-http-post-path: $url");
    print("${process}-http-post-head: Origin:${headers?['Origin']} token:${headers?['token']}  _ds:${headers?['_ds']}");
    print("${process}-http-post-body: $body");
    return httpAdapter.postRequest(context, url, headers: headers, body: body).then((result) {
      print("${process}-http-post-resp: ${result}");
      print("${process}-http-post-time: ${DateTime.now().millisecondsSinceEpoch - startTime}ms");
      return result;
    });
    //     .onError((error, stackTrace) {
    //   // if (error is MsgException) _showError(error);
    //   return Future.error(error ?? MsgException(9000, HttpLocalizations.of(context).current.UnknowError));
    // });
  }
}
