import 'package:flutter/cupertino.dart';
import 'package:gherass/util/image_util.dart';
import 'package:get/get.dart';
import 'error_page.dart';

class NoInternetPage extends StatelessWidget {
  final bool retryEnabled;
  final String retryText;
  final String image;
  final double buttonRadius;
  final void Function()? onPressed;

  const NoInternetPage({
    super.key,
    this.retryEnabled = false,
    this.retryText = "Retry",
    this.image = ImageUtil.logo,
    this.buttonRadius = 8,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorPage(
      title: "no_internet".tr,
      description: "no_internet_desc".tr,
      image: image,
      retryEnabled: retryEnabled,
      retryText: retryText,
      buttonRadius: buttonRadius,
      onPressed: onPressed,
    );
  }
}
