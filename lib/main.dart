import 'package:flutter/material.dart';
import 'package:flutter_template/pages/login_page.dart';
import 'package:flutter_template/routes/router_manager.dart';

import 'utils/global.dart';

void main() {
  RouterManager.initRouter();
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Global.router?.generator,
      home: const LoginPage(),
    );
  }
}
