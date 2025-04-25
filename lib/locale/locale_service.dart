import 'dart:ui';
import 'package:gherass/locale/ar_sa.dart';
import 'package:gherass/locale/en_us.dart';
import 'package:get/get.dart';
import '../storage/storage_service.dart';
import '../util/constants.dart';

class LocaleService extends Translations {
  static Locale get locale => getAppLocale();
  static const fallbackLocale = Locale('en', 'US');

  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ar_SA': arSA};

  static getAppLocale() {
    var storageService = Get.find<StorageService>();
    return storageService.getLocale();
  }

  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < languages.length; i++) {
      if (lang == languages[i]) return locales[i];
    }
    return Get.locale ?? const Locale('en', 'US');
  }

  static final languages = [Constants.english, Constants.arabic];

  static final locales = [const Locale('en', 'US'), const Locale('ar', 'SA')];
}
