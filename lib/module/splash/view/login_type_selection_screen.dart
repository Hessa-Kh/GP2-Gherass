import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gherass/theme/styles.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../helper/routes.dart';
import '../../../theme/app_theme.dart';
import '../../../util/constants.dart';
import '../../../util/image_util.dart';
import '../controller/splash_controller.dart';

class LoginTypeSelectionScreen extends StatelessWidget {
  const LoginTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.5;
    return Scaffold(
      backgroundColor: AppTheme.white,
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
                await BaseController().changeLanguage();
              },
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          BaseController.storageService.write(
                            Constants.logType,
                            "farmer",
                          );
                          Get.toNamed(Routes.login);
                          BaseController.logInType.value =
                              BaseController.storageService.getLogInType();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            147,
                            194,
                            73,
                            1,
                          ),
                        ),
                        child: Text(
                          "Log in as farmer".tr,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          BaseController.storageService.write(
                            Constants.logType,
                            "customer",
                          );
                          Get.toNamed(Routes.login);
                          BaseController.logInType.value =
                              BaseController.storageService.getLogInType();
                        }, //93C249
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            147,
                            194,
                            73,
                            1,
                          ),
                        ),
                        child: Text(
                          "Log in as customer".tr,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          BaseController.storageService.write(
                            Constants.logType,
                            "driver",
                          );
                          Get.toNamed(Routes.login);
                          BaseController.logInType.value =
                              BaseController.storageService.getLogInType();
                        }, //93C249
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            147,
                            194,
                            73,
                            1,
                          ),
                        ),
                        child: Text(
                          "Log in as driver".tr,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
