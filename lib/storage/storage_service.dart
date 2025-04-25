import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../util/constants.dart';

class StorageService {
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  Future<void> write(String key, dynamic value) async {
    await GetStorage().write(key, value);
  }

  Future<dynamic> read(String key) async {
    String? data = GetStorage().read(key);
    return data;
  }

  String getLanguageCode() {
    return GetStorage().read(Constants.langCode) ?? 'en';
  }

  String getFcmToken() {
    return GetStorage().read(Constants.fcmToken) ?? '';
  }

  bool getIsLogin() {
    return GetStorage().read(Constants.isLogin) ?? false;
  }

  String getLogInType() {
    return GetStorage().read(Constants.logType) ?? '';
  }


  Locale getLocale() {
    String? locale = GetStorage().read(Constants.appLanguage);
    if (locale != null && locale.isNotEmpty) {
      if (locale == Constants.arabic) {
        return const Locale('ar', 'SA');
      } else if (locale == Constants.english) {
        return const Locale('en', 'US');
      }
    }
    return Get.deviceLocale ?? const Locale('en', 'US');
  }
}
