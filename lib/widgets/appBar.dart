import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../baseclass/basecontroller.dart';
import '../theme/app_theme.dart';
import '../theme/styles.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CommonAppBar({super.key, this.title = "", this.showBackButton = true,this.onBackPressed,});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title.tr,
        style: Styles.boldTextView(20, AppTheme.black),
      ),
      leading: showBackButton
          ? Directionality(
              textDirection: BaseController.languageName.value == "english"
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: IconButton(
                color: Colors.black,
                onPressed: onBackPressed ?? Get.back,
                icon: Icon(Icons.arrow_back_ios),
              ),
            )
          : null,
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
