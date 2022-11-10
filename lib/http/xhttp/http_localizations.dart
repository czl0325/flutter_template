import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HttpLocalizations {
  final Locale locale;
  final Map<String, HttpStrings> values = {
    'en': HttpStrings(),
    'zh': HttpStringsZh(),
  };

  HttpLocalizations(this.locale);

  HttpStrings get current {
    if (values.containsKey(locale.languageCode)) {
      return values[locale.languageCode]!;
    }
    return values["en"]!;
  }

  static const HttpLocalizationsDelegate delegate = HttpLocalizationsDelegate();

  static HttpLocalizations of(BuildContext context) {
    return Localizations.of(context, HttpLocalizations);
  }
}

class HttpLocalizationsDelegate extends LocalizationsDelegate<HttpLocalizations> {
  const HttpLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<HttpLocalizations> load(Locale locale) {
    return SynchronousFuture<HttpLocalizations>(HttpLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<HttpLocalizations> old) {
    return false;
  }
}

class HttpStrings {
  String NetError = 'Requst data fail, please check network';
  String HttpError = 'Request network fail-%s';
  String UnknowError = 'Request network fail-%s';
  String Retry = 'Retry';
}

class HttpStringsZh extends HttpStrings {
  String NetError = '请求数据失败，请检查网络是否异常';
  String HttpError = '网络请求失败-%s';
  String UnknowError = '网络请求失败-%s';
  String Retry = '重试';
}
