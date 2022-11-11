import 'package:flutter/material.dart';
import 'package:flutter_template/utils/global.dart';
import 'package:flutter_template/widgets/common_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.topAppBar("登录页面"),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Global.router?.navigateTo(context, "/");
          },
          child: const Text("跳转页面"),
        ),
      ),
    );
  }
}
