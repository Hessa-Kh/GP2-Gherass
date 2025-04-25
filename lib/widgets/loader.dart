import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class LoadingIndicator {
  static void loadingWithBackgroundDisabled([String? message]) {
    String loadingMessage = message ?? "Loading".tr;

    EasyLoading.show(
      status: '$loadingMessage...',
      maskType: EasyLoadingMaskType.black,
      indicator: const CircularProgressIndicator(
        backgroundColor: Colors.black,
      ),
    );
  }

  static void stopLoading() {
    EasyLoading.dismiss();
  }
}
