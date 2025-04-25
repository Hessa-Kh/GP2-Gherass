import 'package:flutter/material.dart';
import 'package:gherass/storage/storage_service.dart';
import 'package:get/get.dart';

class ThemeService extends GetxController {
  final storageService = Get.find<StorageService>();
  final key = 'isDarkMode';
  late bool isDarkTheme;

  ThemeMode get themeState => getCurrentTheme();

  @override
  void onInit() {
    getCurrentTheme();
    super.onInit();
  }

  ThemeMode getCurrentTheme() {
    bool isDarkTheme = false;
    storageService
        .read(key)
        .then(
          (value) => () {
            isDarkTheme = value ?? false;
          },
        );
    if (isDarkTheme) {
      this.isDarkTheme = true;
      return ThemeMode.dark;
    } else {
      this.isDarkTheme = true;
      return ThemeMode.light;
    }
  }

  void updateTheme(bool isDarkMode) {
    storageService.write(key, isDarkMode);
  }

  void changeTheme() {
    if (Get.isDarkMode) {
      isDarkTheme = false;
      updateTheme(false);
      changeThemeMode(ThemeMode.light);
    } else {
      isDarkTheme = true;
      updateTheme(true);
      changeThemeMode(ThemeMode.dark);
    }
  }

  void changeThemeMode(ThemeMode themeMode) => Get.changeThemeMode(themeMode);
}
