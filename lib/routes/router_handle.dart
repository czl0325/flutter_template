import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/pages/404_page.dart';
import 'package:flutter_template/pages/index_page.dart';
import 'package:flutter_template/pages/login_page.dart';

var notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const NotFoundPage();
});

var loginHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const LoginPage();
});

var indexHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> parameters) {
  return const IndexPage();
});
