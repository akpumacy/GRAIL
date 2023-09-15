// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class LocalizationController extends Translations {
  // Default locale
  Locale locale = const Locale('en', 'US');
  static const String LANGUAGE_CODE = "language_code";
  static const String COUNTRY_CODE = "country_code";

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('de', 'DE');

  Future<Locale> fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(LANGUAGE_CODE) && !prefs.containsKey(COUNTRY_CODE)) {
      locale = const Locale('en', 'US');
      return locale;
    }
    String languageCode = prefs.getString(LANGUAGE_CODE)!;
    String countryCode = prefs.getString(COUNTRY_CODE)!;
    locale = Locale(languageCode, countryCode);
    return locale;
  }

  static final langs = [
    'English',
    'Deutsch',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    const Locale('en', 'US'),
    const Locale('de', 'DE'),
  ];

  Future<Map<String, String>> loadLang(String lang) async {
    String dataString = await rootBundle.loadString('assets/$lang.json');
    Map langDynamic = jsonDecode(dataString);
    Map<String, String> langString =
        langDynamic.map((key, value) => MapEntry(key, value.toString()));
    return langString;
  }

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en as Map<String, String>,
        'de_DE': de as Map<String, String>,
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) async {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
    var prefs = await SharedPreferences.getInstance();
    // bool languageCode =
    await prefs.setString(LANGUAGE_CODE, locale.languageCode);
    // bool countryCode =
    await prefs.setString(COUNTRY_CODE, locale.countryCode!);
    // print("lc=>$languageCode : cc=>$countryCode");
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }
}






























// // ignore_for_file: constant_identifier_names
//
// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../main.dart';
// import 'package:flutter/material.dart';
//
// import '../view/change_language_dialog.dart';
//
// class LocalizationController{
//
//   SharedPreferences prefs;
//   String _selectedLanguage = 'English';
//   Map<String, String> words;
//
//   String languageCode;
//
//   Future<void> fetchLocale() async {
//     prefs = await SharedPreferences.getInstance();
//     if(prefs.containsKey('lang')){
//       languageCode = prefs.getString('lang');
//     }
//     else {
//       languageCode = 'en';
//     }
//   }
//
//   Future<void> loadWords() async {
//     String jsonString = await rootBundle.loadString('assets/$languageCode.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//     words = jsonMap.map((key, value) => MapEntry(key, value.toString()));
//   }
//
//   Future<void> selectLanguage(BuildContext context) async {
//     prefs = await SharedPreferences.getInstance();
//     String selectedLanguage = await showDialog<String>(
//         context: context,
//         builder: (BuildContext context) {
//           return LanguageSelectionDialog(selectedLanguage: _selectedLanguage);
//         });
//     if (selectedLanguage != null) {
//       _selectedLanguage = selectedLanguage;
//       if(_selectedLanguage == 'English'){
//         languageCode = 'en';
//       }
//       else {
//         languageCode = 'de';
//       }
//       loadWords();
//       prefs.setString('lang', _selectedLanguage == 'English' ? 'en' : 'de');
//     }
//   }
//
// }































// import 'dart:async';
// import 'dart:convert';
//
// import 'package:flutter/widgets.dart';
// import 'package:flutter/services.dart';
//
//
//
//
//
// // class L10n {
// //   L10n(this.locale);
// //
// //   final Locale locale;
// //
// //   static L10n of(BuildContext context) {
// //     return Localizations.of<L10n>(context, L10n);
// //   }
// //
// //   Map<String, String> _sentences;
// //
// //   Future<bool> load() async {
// //     String data = await rootBundle.loadString('lib/l10n/${this.locale.languageCode}.json');
// //     Map<String, dynamic> _result = json.decode(data);
// //     _sentences = Map();
// //     _result.forEach((String key, dynamic value) {
// //       _sentences[key] = value.toString();
// //     });
// //     return true;
// //   }
// //
// //   String translate(String key) {
// //     return _sentences[key];
// //   }
// // }
// //
// // class L10nDelegate extends LocalizationsDelegate<L10n> {
// //   const L10nDelegate();
// //
// //   @override
// //   bool isSupported(Locale locale) {
// //     return ['en', 'fr'].contains(locale.languageCode);
// //   }
// //
// //   @override
// //   Future<L10n> load(Locale locale) async {
// //     L10n localizations = L10n(locale);
// //     await localizations.load();
// //     return localizations;
// //   }
// //
// //   @override
// //   bool shouldReload(L10nDelegate old) => false;
// // }
//
//
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String _selectedLanguage = 'English';
//   Map<String, String> _words;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadWords('en');
//   }
//
//   Future<void> _loadWords(String languageCode) async {
//     String jsonString = await rootBundle.loadString('assets/words_$languageCode.json');
//     Map<String, dynamic> jsonMap = json.decode(jsonString);
//     setState(() {
//       _words = jsonMap.map((key, value) => MapEntry(key, value.toString()));
//     });
//   }
//
//   Future<void> _selectLanguage() async {
//     String selectedLanguage = await showDialog<String>(
//         context: context,
//         builder: (BuildContext context) {
//           return LanguageSelectionDialog(selectedLanguage: _selectedLanguage);
//         });
//     if (selectedLanguage != null) {
//       setState(() {
//         _selectedLanguage = selectedLanguage;
//       });
//       _loadWords(_selectedLanguage == 'English' ? 'en' : 'de');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Localization Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(_words['hello']),
//             RaisedButton(
//               onPressed: _selectLanguage,
//               child: Text('Select Language'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LanguageSelectionDialog extends StatefulWidget {
//   final String selectedLanguage;
//
//   LanguageSelectionDialog({this.selectedLanguage});
//
//   @override
//   _LanguageSelectionDialogState createState() =>
//       _LanguageSelectionDialogState();
// }
//
// class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Language Selection'),
//       content: Container(
//         width: double.maxFinite,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             RadioListTile(
//               title: Text('English'),
//               value: 'English',
//               groupValue: widget.selectedLanguage,
//               onChanged: (value) {
//                 Navigator.of(context).pop(value);
//               },
//             ),
//             RadioListTile(
//               title: Text('German'),
//               value: 'German',
//               groupValue: widget.selectedLanguage,
//               onChanged: (value) {
//                 Navigator.of(context).pop(value);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//
//
//
