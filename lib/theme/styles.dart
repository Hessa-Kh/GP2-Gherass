import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'package:flutter_svg/svg.dart';

class Styles {
  static TextStyle regularTextView(double fontSize, Color color) => TextStyle(
      color: color,
      fontFamily: '',
      fontSize: fontSize,
      fontWeight: FontWeight.w500);

  static TextStyle mediumTextView(double fontSize, Color color) => TextStyle(
      color: color,
      fontFamily: '',
      fontSize: fontSize,
      height: 1.2,
      fontWeight: FontWeight.w500);
  static TextStyle normalTextStyle(Color color, double fontSize) => TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: 'roboto',
      fontWeight: FontWeight.w400);

  static TextStyle regularTextStyle(Color color, double fontSize) => TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'roboto',
      );

  static TextStyle semiBoldTextView(double fontSize, Color color) => TextStyle(
      color: color,
      fontFamily: '',
      fontSize: fontSize,
      fontWeight: FontWeight.w600);

  static TextStyle boldTextView(double fontSize, Color color) => TextStyle(
      color: color,
      fontFamily: '',
      fontSize: fontSize,
      fontWeight: FontWeight.w700);

  static TextStyle linkTextView(double fontSize, Color color) => TextStyle(
      color: color,
      fontFamily: '',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.underline);

  static ButtonStyle primaryButton(double radius) => ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.primaryColor,
        elevation: 0,
        minimumSize: const Size(double.infinity, 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  static ButtonStyle regularButtonStyle(
          double radius, double elevation, Color color) =>
      ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: color,
        elevation: elevation,
        minimumSize: const Size(double.infinity, 50.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      );

  static InputDecoration outlinedInputBorderStyle(
          double radius, Color borderColor) =>
      InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          errorMaxLines: 3,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: BorderSide(
                color: borderColor,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: const BorderSide(
                color: Colors.red,
              )));

  static InputDecoration customRoundedTextFieldStyle(String label, String icon,
          {IconData? suffixIcon, Function? onTapSuffix}) =>
      InputDecoration(
          hoverColor: Colors.transparent,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              icon: SvgPicture.asset(icon, height: 16, width: 16),
              onPressed: null,
            ),
          ),
          hintText: label,
          hintStyle: regularTextStyle(AppTheme.hintDarkGray, 14),
          labelStyle: regularTextStyle(AppTheme.blackColor, 14),
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
                color: AppTheme.secondaryTextColor,
                icon: Icon(
                  suffixIcon,
                  color: AppTheme.lightGray,
                ),
                onPressed: () {
                  if (onTapSuffix != null) {
                    onTapSuffix();
                  }
                }),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide:
                const BorderSide(color: AppTheme.primaryColor, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 1),
          ));

  static InputDecoration roundedTextFieldStyle(String label, String icon,
          {IconData? suffixIcon, Function? onTapSuffix}) =>
      InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: SvgPicture.asset(icon, height: 16, width: 16),
              onPressed: null,
            ),
          ),
          hintText: label,
          hintStyle: regularTextStyle(AppTheme.secondaryTextColor, 14),
          labelStyle: regularTextStyle(AppTheme.primaryTextColor, 14),
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
              color: AppTheme.secondaryTextColor,
              icon: Icon(
                suffixIcon,
                color: AppTheme.lightGray,
              ),
              onPressed: () {
                if (onTapSuffix != null) {
                  onTapSuffix();
                }
              }),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ));

  static InputDecoration suffixTextField(String label, String icon) =>
      InputDecoration(
          contentPadding: const EdgeInsets.only(
              top: 10.0, bottom: 10, left: 20.0, right: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              icon: SvgPicture.asset(icon, height: 24, width: 24),
              onPressed: null,
            ),
          ),
          hintText: label,
          hintStyle: Styles.normalTextStyle(AppTheme.secondaryTextColor, 12),
          errorMaxLines: 3,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.0),
            borderSide: const BorderSide(color: AppTheme.borderColor, width: 2),
          ));

  static InputDecoration outlinedInputBorderWithHintStyle(
          String hint, double radius, Color borderColor) =>
      InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          errorMaxLines: 3,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: BorderSide(
                color: borderColor,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              borderSide: const BorderSide(
                color: Colors.red,
              )));

  static InputDecoration disabledInputBorderStyle(double radius) =>
      InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        errorMaxLines: 3,
        fillColor: AppTheme.borderColor,
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(
              color: AppTheme.borderColor,
            )),
      );
}
