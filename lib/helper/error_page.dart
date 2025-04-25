import 'package:flutter/material.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/extensions.dart';

class ErrorPage extends StatelessWidget {
  final String title;
  final String? description;
  final String? image;
  final bool retryEnabled;
  final String retryText;
  final Color secondaryTextColor;
  final Color primaryTextColor;
  final double buttonRadius;
  final double titleTextSize;
  final double descriptionTextSize;
  final double buttonTextSize;
  final double buttonPadding;
  final void Function()? onPressed;

  const ErrorPage({
    super.key,
    required this.title,
    this.titleTextSize = 16,
    this.primaryTextColor = AppTheme.primaryColor,
    this.secondaryTextColor = AppTheme.secondaryTextColor,
    this.description = "",
    this.descriptionTextSize = 14,
    this.buttonRadius = 8,
    this.image,
    this.retryText = "Retry",
    this.retryEnabled = true,
    this.buttonTextSize = 14,
    this.buttonPadding = 16,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getImageWidget(image),
            const SizedBox(height: 16),
            Text(
              title,
              style: Styles.semiBoldTextView(titleTextSize, primaryTextColor),
            ),
            const SizedBox(height: 8),
            Text(
              description ?? "",
              style: Styles.regularTextView(
                descriptionTextSize,
                secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),
            retryEnabled
                ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: buttonPadding),
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: Styles.primaryButton(buttonRadius),
                    child: Text(
                      retryText,
                      style: Styles.regularTextView(
                        buttonTextSize,
                        AppTheme.white,
                      ),
                    ),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }
}

Widget _getImageWidget(String? image) {
  if (image?.isEmpty ?? true) {
    return Container();
  } else if (image?.lastChars(3) == "svg") {
    return SvgPicture.asset(image!);
  } else {
    return Image.asset(image!);
  }
}
