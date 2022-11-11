import 'package:fluro/fluro.dart';
import 'package:flutter_template/routes/router_handle.dart';

import '../utils/global.dart';

class RouterManager {
  static FluroRouter? router;
  static void initRouter() {
    if (router == null) {
      router = FluroRouter();
      _defineRoutes();
    }
    Global.router = router;
  }

  static void _defineRoutes() {
    router?.define("/", handler: indexHandler, transitionType: TransitionType.inFromRight);
    router?.define("/login", handler: loginHandler, transitionType: TransitionType.inFromRight);
    router?.notFoundHandler = notFoundHandler;
  }
}
