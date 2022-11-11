import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastUtils {
  static void showLoading(BuildContext context, String msg, {double progress = 0.0}) {
    EasyLoading.show(status: msg);
  }

  static void showProgress(BuildContext context, String msg, double progress) {
    EasyLoading.showProgress(progress, status: msg);
  }

  static void showTip(BuildContext context, String msg, {Function()? onAfterTip}) {
    EasyLoading.showToast(msg, duration: const Duration(seconds: 2), toastPosition: EasyLoadingToastPosition.bottom);
  }

  static void showError(BuildContext context, String msg) {
    EasyLoading.showError(msg, duration: const Duration(seconds: 2), dismissOnTap: false);
  }
}
