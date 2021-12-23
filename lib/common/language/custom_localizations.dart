import 'package:flutter/material.dart';

import 'string_base.dart';
import 'string_en.dart';
import 'string_zh.dart';

class CustomLocalizations {
  final Locale locale;

  CustomLocalizations(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  static Map<String, StringBase> _localizedValues = {
    'en': StringEn(),
    'zh': StringZh(),
  };

  StringBase? get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  ///通过 Localizations 加载当前的 DefaultLocalizations
  ///获取对应的 StringBase
  static CustomLocalizations of(BuildContext context) {
    return Localizations.of(context, CustomLocalizations);
  }
}