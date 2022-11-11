import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/utils/toast_utils.dart';
import 'package:flutter_template/widgets/common_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double seconds = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.topAppBar("登录页面"),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Global.router?.navigateTo(context, "/");
            ToastUtils.showError(context, "错误");
            // ToastUtils.showProgress(context, "加载中...", seconds);
            // Timer.periodic(const Duration(seconds: 1), (timer) {
            //   if (seconds >= 100) {
            //     timer.cancel(); // 取消重复计时
            //     return;
            //   }
            //   seconds++;
            //   ToastUtils.showProgress(context, "加载中...", seconds);
            // });
          },
          child: const Text("跳转页面"),
        ),
      ),
    );
  }
}
