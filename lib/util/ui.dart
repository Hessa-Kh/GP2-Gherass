import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

class UI {
  static showSnackBar(BuildContext context, String text) {
    toastification.show(
      context: context,
      title: Text(text),
      autoCloseDuration: const Duration(seconds: 5),
      type: ToastificationType.error,
      alignment: Alignment.bottomRight,
      showIcon: false,
      showProgressBar: false,
    );
  }
}