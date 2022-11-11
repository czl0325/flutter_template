import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import '../utils/global.dart';
import '../utils/themes.dart';

class CommonWidgets {
  static State? getState(BuildContext context) {
    try {
      return context.findAncestorStateOfType();
    } catch (e) {
      return null;
    }
  }

  static bool mounted(BuildContext context) {
    var state = getState(context);
    return state?.mounted ?? false;
  }

  static Widget empty() {
    return const SizedBox(height: 0, width: 0);
  }

  /// 分隔线
  static Divider divider({double height = 1, Color? color = DefaultStyles.dividerColor}) {
    return color != null
        ? Divider(
            color: color,
            thickness: height,
            height: height,
          )
        : Divider(
            thickness: height,
            height: height,
          );
  }

  static Widget appBarCustom(BuildContext context, Widget appBarWidget, Widget bodyWidget, {String? bgImage, Color bgColor = Colors.white, double height = 150}) {
    DecorationImage? decorationImage = bgImage != null
        ? DecorationImage(
            alignment: Alignment.topCenter,
            //fit: BoxFit.fitHeight,
            image: AssetImage(bgImage), //'images/bg_mine_head.png'
          )
        : null;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            image: decorationImage,
          ),
          child: appBarWidget,
        ),
      ),
      body: bodyWidget,
      backgroundColor: bgColor,
    );
  }

  static PreferredSizeWidget topAppBar(
    String title, {
    Brightness brightness = Brightness.light,
    bool centerTitle = true,
    List<Widget>? actions,
  }) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
      ),
      excludeHeaderSemantics: true,
      systemOverlayStyle: brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.dark,
      backgroundColor: brightness == Brightness.light ? Colors.white : null,
      foregroundColor: brightness == Brightness.light ? Colors.black : Colors.white,
      centerTitle: centerTitle,
      elevation: 0,
      actions: actions,
    );
  }

  /// 带返回图标-应用标题栏
  static PreferredSizeWidget backAppBar(
    String title, {
    double height = DefaultStyles.appBarHeight,
    Brightness brightness = Brightness.light,
    bool centerTitle = true,
    Color? backgroundColor,
    List<Widget>? actions,
  }) {
    return AppBar(
      leading: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Global.router?.pop(navigatorKey.currentState!.overlay!.context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(Icons.arrow_back_ios, size: 16, color: brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 18, color: brightness == Brightness.dark ? Colors.white : Colors.black, fontWeight: FontWeight.w500),
      ),
      backgroundColor: backgroundColor ?? (brightness == Brightness.light ? Colors.white : null),
      foregroundColor: brightness == Brightness.light ? Colors.black : Colors.white,
      centerTitle: centerTitle,
      elevation: 0,
      actions: actions,
    );
  }
}
