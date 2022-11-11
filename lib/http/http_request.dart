import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/http/xhttp/http_exception.dart';
import 'package:flutter_template/http/xhttp/http_handler.dart';
import 'package:flutter_template/utils/toast_utils.dart';

typedef EntityBuilder<T> = T Function(dynamic);

/// Api返回结果
class ApiResult {
  int code = 0;
  String? msg;
  dynamic data;

  ApiResult.fromJson(Map<String, dynamic>? data) {
    if (data != null) {
      code = data['code'] ?? 9;
      msg = data['msg'];
      this.data = data['data'];
    } else {
      code = 1001;
      msg = "Api返回Map转化错误";
    }
  }
}

class PageData<T> {
  int? importantCount = 0;
  int? total = 0;
  int? pageIndex = 0;
  int? pageSize = 10;
  List<T> list = [];

  PageData();

  PageData.fromJson(EntityBuilder<T> builder, dynamic data) {
    importantCount = data['importantCount'];
    total = data["total"];
    pageIndex = data["pageIndex"];
    pageSize = data["pageSize"];
    var listData = data['list'];
    list = [];
    if (listData is List) {
      for (var e in listData) {
        list.add(builder(e));
      }
    }
  }
}

/// 请求上下文环境
abstract class ServerOptions {
  String getRootUrl();

  Map<String, String> getHeaders();

  String getTokenUrl(String url);
}

class HttpRequest {
  static late ServerOptions _serverOptions;

  static void initialize(ServerOptions apiContext) {
    _serverOptions = apiContext;
  }

  static Map<String, String> get headers => _serverOptions.getHeaders();

  static String getTokenUrl(String url) => _serverOptions.getTokenUrl(url);

  static Map<String, String> prepareHeaders(ServerOptions context, Map<String, String>? headers) {
    var result = <String, String>{};
    Map<String, String> headers = context.getHeaders();
    headers.forEach((key, value) {
      result[key] = value;
    });
    result.addAll(headers);
    return result;
  }

  static String prepareUrl(ServerOptions context, String callUrl, Map<String, dynamic>? urlArgs, {bool addToken = false}) {
    var url = HttpUtils.buildUrl(context.getRootUrl(), callUrl, urlArgs);
    if (addToken) url = context.getTokenUrl(url);
    return url;
  }

  // 应用异常处理
  static Future<T> _failDeal<T>(
    BuildContext context,
    int code,
    String msg,
    Future<T> Function() redo, {
    bool hideLoading = true,
    bool autoLogin = true,
    Function(int code, String msg)? fail,
    Function()? finish,
  }) async {
    if (fail != null) {
      LogUtil.d("应用出现错误，code=$code,msg=$msg");
      fail(code, msg);
    } else if (!ObjectUtil.isEmptyString(msg)) {
      LogUtil.d("应用出现错误，code=$code,msg=$msg");
      ToastUtils.showError(context, msg);
    }
    if (finish != null) {
      finish();
    }
    return Future.error(SkipException());
  }

  static Future<T?> requestData<T>(
    BuildContext context,
    String url, {
    String method = "POST",
    Map<String, dynamic>? urlArgs,
    Object? bodyArgs,
    bool hideLoading = true,
    bool autoLogin = true,
    EntityBuilder<T>? builder,
    Map<String, String>? headers,
    Function(T?)? success,
    Function(int, String)? fail,
    Function()? finish,
  }) async {
    try {
      String? resultData = method == "POST"
          ? await HttpUtils.postRequest(
              context,
              prepareUrl(_serverOptions, url, urlArgs),
              bodyArgs: bodyArgs,
              headers: prepareHeaders(_serverOptions, headers),
            )
          : await HttpUtils.getRequest(context, prepareUrl(_serverOptions, url, urlArgs), headers: prepareHeaders(_serverOptions, headers));
      // LogUtil.e("请求=$url,参数=${method == 'POST' ? bodyArgs.toString() : urlArgs.toString()},token=${_serverOptions.getHeaders()["token"]}, 返回=${(resultData ?? "无数据")}");
      var apiRst = resultData != null ? ApiResult.fromJson(json.decode(resultData)) : null;
      if (apiRst != null && apiRst.code == 0) {
        dynamic result = builder != null ? builder(apiRst.data) : apiRst.data;
        if (success != null) success(result);
        if (finish != null) finish();
        return Future.value(result);
      } else {
        return await _failDeal(
          context,
          apiRst?.code ?? 9,
          apiRst?.msg ?? "",
          () async => await requestData(
            context,
            url,
            headers: headers,
            urlArgs: urlArgs,
            hideLoading: hideLoading,
            bodyArgs: bodyArgs,
            builder: builder,
            success: success,
          ),
          hideLoading: hideLoading,
          autoLogin: autoLogin,
          fail: fail,
          finish: finish,
        );
      }
    } on SkipException catch (e) {
    } catch (e) {
      LogUtil.d("请求出现错误:${e.toString()}");
      if (fail != null) {
        fail(500, e.toString());
      }
      if (finish != null) finish();
    }
    return null;
  }

  static Future<Map<String, dynamic>?> requestMap(
    BuildContext context,
    String url, {
    Map<String, dynamic>? urlArgs,
    Object? bodyArgs,
    Map<String, String>? headers,
  }) async {
    try {
      String? result = await HttpUtils.postRequest(
        context,
        prepareUrl(_serverOptions, url, urlArgs),
        bodyArgs: bodyArgs,
        headers: prepareHeaders(_serverOptions, headers),
      );
      // LogUtil.e("请求=$url,参数=${urlArgs.toString()},token=${_serverOptions.getHeaders()["token"]}, 返回=${(result ?? "无数据")}");
      var apiRst = result != null ? ApiResult.fromJson(json.decode(result)) : null;
      if (apiRst != null && apiRst.code == 0) {
        return apiRst.data;
      } else {
        return _failDeal(
          context,
          apiRst?.code ?? 9,
          apiRst?.msg ?? "",
          () => requestMap(
            context,
            url,
            headers: headers,
            urlArgs: urlArgs,
            bodyArgs: bodyArgs,
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<T>> requestList<T>(
    BuildContext context,
    String url, {
    Map<String, dynamic>? urlArgs,
    Object? bodyArgs,
    bool hideLoading = true,
    EntityBuilder<T>? builder,
    Map<String, String>? headers,
    Function(List<T>)? success,
    Function(int, String)? fail,
    Function()? finish,
  }) async {
    try {
      String? result = await HttpUtils.postRequest(
        context,
        prepareUrl(_serverOptions, url, urlArgs),
        bodyArgs: bodyArgs,
        headers: prepareHeaders(_serverOptions, headers),
      );
      LogUtil.e("请求接口=$url,参数=${bodyArgs.toString()},token=${_serverOptions.getHeaders()["token"]},返回=${(result ?? "无数据")}");
      List<T> list = [];
      var apiRst = ApiResult.fromJson(result is String ? json.decode(result) : result);
      if (apiRst.code == 0) {
        apiRst.data.forEach((v) => list.add(builder != null ? builder(v) : v));
        if (success != null) success(list);
        if (finish != null) finish();
      } else {
        return _failDeal(
          context,
          apiRst.code,
          apiRst.msg ?? "",
          () => requestList(
            context,
            url,
            headers: headers,
            urlArgs: urlArgs,
            hideLoading: hideLoading,
            bodyArgs: bodyArgs,
            builder: builder,
            success: success,
          ),
          fail: fail,
          finish: finish,
        );
      }
      return list;
    } catch (e) {
      if (finish != null) finish();
      rethrow;
    }
  }

  static Future<PageData<T>> requestPage<T>(
    BuildContext context,
    String url, {
    Map<String, dynamic>? urlArgs,
    Object? bodyArgs,
    bool hideLoading = true,
    EntityBuilder<T>? builder,
    Map<String, String>? headers,
    Function(PageData<T>)? success,
    Function(int, String)? fail,
    Function()? finish,
  }) async {
    try {
      String? result = await HttpUtils.postRequest(
        context,
        prepareUrl(_serverOptions, url, urlArgs),
        bodyArgs: bodyArgs,
        headers: prepareHeaders(_serverOptions, headers),
      );
      LogUtil.e("请求url=$url,请求参数=${bodyArgs.toString()},返回参数=$result");
      var apiRst = result != null ? ApiResult.fromJson(json.decode(result)) : null;
      PageData<T>? pageData;
      if (apiRst != null && apiRst.code == 0) {
        pageData = builder != null ? PageData.fromJson(builder, apiRst.data) : apiRst.data;
        pageData ??= PageData<T>();
        if (success != null) {
          success(pageData);
        }
        if (finish != null) {
          finish();
        }
        return pageData;
      } else {
        return _failDeal(
          context,
          apiRst?.code ?? 9,
          apiRst?.msg ?? "",
          () => requestPage(
            context,
            url,
            headers: headers,
            urlArgs: urlArgs,
            hideLoading: hideLoading,
            bodyArgs: bodyArgs,
            builder: builder,
            success: success,
          ),
          hideLoading: hideLoading,
          fail: fail,
          finish: finish,
        );
      }
    } catch (e) {
      if (finish != null) finish();
      rethrow;
    }
  }

  static Future requestMultipart(
    BuildContext context,
    String url,
    List<String> filePaths, {
    bool hideLoading = true,
    Map<String, dynamic>? urlArgs,
    Map<String, String>? headers,
    Map<String, dynamic>? bodyArgs,
    Function(int, String)? fail,
    Function(dynamic)? success,
    Function()? finish,
  }) async {
    try {
      var result = await HttpUtils.multipartRequest(
        context,
        prepareUrl(_serverOptions, url, urlArgs, addToken: true),
        headers: prepareHeaders(_serverOptions, headers),
        filePaths: filePaths,
        bodyArgs: bodyArgs,
      );
      var apiRst = result != null ? ApiResult.fromJson(json.decode(result)) : null;
      LogUtil.d("上传文件----,返回参数=$result");
      if (apiRst != null && apiRst.code == 0) {
        if (success != null) success(apiRst.data);
        if (finish != null) finish();
        return apiRst.data;
      } else {
        return _failDeal(
          context,
          apiRst?.code ?? 9,
          apiRst?.msg ?? "",
          () => requestMultipart(
            context,
            url,
            filePaths,
            hideLoading: hideLoading,
            urlArgs: urlArgs,
            bodyArgs: bodyArgs,
            success: success,
          ),
          hideLoading: hideLoading,
          fail: fail,
          finish: finish,
        );
      }
    } catch (e) {
      if (finish != null) finish();
      rethrow;
    }
  }
}
