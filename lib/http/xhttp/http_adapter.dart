import 'dart:convert';

import 'package:flutter/cupertino.dart';

abstract class HttpAdapter {
  static const Duration timeoutSeconds = Duration(seconds: 30);
  static const Utf8Decoder utf8decoder = Utf8Decoder();

  Future<String?> getRequest(BuildContext context, String url, {Map<String, String>? headers});
  Future<String?> postRequest(BuildContext context, String url, {Map<String, String>? headers, String? body});
  Future<String?> multipartRequest(BuildContext context, String url, {Map<String, String>? headers, Map<String, dynamic>? bodyArgs, required List<String> files});
}
