import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/util/image_util.dart';

import '../../helper/routes.dart' show Routes;
import '../../theme/app_theme.dart';
import '../../theme/styles.dart';
import 'login_controller.dart';
import 'login_widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<LoginController>();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.5;
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            SvgPicture.asset(ImageUtil.greenEllipse),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(ImageUtil.logo),
              ),
            ),
            Positioned(
              top: containerHeight / 9,
              right:
                  BaseController.languageName.value == "english"
                      ? containerHeight / 20
                      : containerHeight / 1.2,
              child: GestureDetector(
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        BaseController.languageName.value == "arabic"
                            ? "En"
                            : "ع",
                        style: Styles.regularTextView(17, AppTheme.white),
                      ),
                    ),
                    Icon(CupertinoIcons.globe, color: AppTheme.black),
                  ],
                ),
                onTap: () async {
                  await controller.changeLanguage();
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        BaseController.logInType.value.tr,
                        style: Styles.boldTextView(18, AppTheme.black),
                      ),
                      LoginWidgets().loginWidget(context),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Align(
                alignment:
                    BaseController.languageName.value == "english"
                        ? Alignment.topLeft
                        : Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.loginTypeSelectionScreen);
                  },
                  icon: Icon(Icons.arrow_back_ios, color: AppTheme.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
