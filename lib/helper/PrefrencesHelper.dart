// import 'dart:convert';
//
// import 'package:invoice_simple/Constants.dart';
// import 'package:invoice_simple/models/AppLocale.dart';
// import 'package:invoice_simple/models/Currency.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class PrefrencesHelper {
//   static final String DEFAULT_DATEFORMAT = 'dateformat';
//   static final String DEFAULT_CURRENCY = 'currency';
//   static final String DEFAULT_LOCALE = 'locale';
//
//   Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
//   Future<bool> insertAppDateformateSettings(String dateFormat) async {
//     SharedPreferences prefs = await _prefs;
//     return await prefs.setString(DEFAULT_DATEFORMAT, dateFormat);
//   }
//
//   Future<String> getAppDateformatSetting() async {
//     SharedPreferences prefs = await _prefs;
//     return prefs.getString(DEFAULT_DATEFORMAT) ?? 'yyyy-MM-dd';
//   }
//
//   Future<bool> insertAppCurrencySettings(Currency currency) async {
//     SharedPreferences prefs = await _prefs;
//     return await prefs.setString(DEFAULT_CURRENCY, jsonEncode(currency.toMap()).toString());
//   }
//
//   Future<Currency> getAppCurrencySettings() async {
//     SharedPreferences prefs = await _prefs;
//     String currencyJson = prefs.getString(DEFAULT_CURRENCY) ?? null;
//     if (currencyJson == null) {
//       return Constants.getDefaultCurrency();
//     }
//     Map map = jsonDecode(currencyJson);
//     return Currency.fromMap(map);
//   }
//
//   Future<bool> insertAppLocaleSettings(AppLocale appLocale) async {
//     SharedPreferences prefs = await _prefs;
//     return await prefs.setString(DEFAULT_LOCALE, jsonEncode(appLocale.toMap()).toString());
//   }
//
//   Future<AppLocale> getAppLocaleSettings() async {
//     SharedPreferences prefs = await _prefs;
//     String appLocale = prefs.getString(DEFAULT_LOCALE) ?? null;
//     if (appLocale == null) {
//       return Constants.getDefaultLocale();
//     }
//     Map map = jsonDecode(appLocale);
//     return AppLocale.fromMap(map);
//   }
// }
