// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gherass/apiservice/firebase_helper.dart';

import '../helper/routes.dart';
import '../locale/locale_service.dart';
import '../storage/storage_service.dart';
import '../util/constants.dart';

class BaseController extends GetxController {
  // StreamSubscription? networkState;
  RxBool isConnected = true.obs;
  static StorageService storageService = Get.find<StorageService>();
  static RxString languageName = "english".obs;
  static RxString logInType = "".obs;

  static FirebaseHelper firebaseAuth = Get.find<FirebaseHelper>();

  @override
  void onInit() async {
    try {
      super.onInit();
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
      );

      // networkState = Connectivity()
      //     .onConnectivityChanged
      //     .listen((ConnectivityResult connectivityResult) {
      //   if (connectivityResult == ConnectivityResult.mobile) {
      //     isConnected.value = true;
      //   } else if (connectivityResult == ConnectivityResult.wifi) {
      //     isConnected.value = true;
      //   } else {
      //     print('No Connection');
      //     isConnected.value = false;
      //   }
      // });
    } catch (e) {
      print(e);
    }
    getLanguageType();
  }

  getLanguageType() {
    String langCode = storageService.getLanguageCode();
    if (langCode == "ar") {
      languageName.value = "arabic";
    } else {
      languageName.value = "english";
    }
  }

  changeLanguage() async {
    if (languageName.value == "arabic") {
      await storageService.write(Constants.langCode, "en");
      await storageService.write(Constants.appLanguage, Constants.english);
      LocaleService().changeLocale("english");
      languageName.value = "english";
      Get.offAllNamed(Routes.splash);
    } else {
      await storageService.write(Constants.langCode, "ar");
      await storageService.write(Constants.appLanguage, Constants.arabic);
      LocaleService().changeLocale("arabic");
      languageName.value = "arabic";
      Get.offAllNamed(Routes.splash);
    }
  }

  // Future<bool> checkConnection() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return isConnected.value = true;
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     return isConnected.value = true;
  //   } else {
  //     return isConnected.value = false;
  //   }
  // }

  @override
  void onClose() {
    // networkState?.cancel();
    super.onClose();
  }
}
