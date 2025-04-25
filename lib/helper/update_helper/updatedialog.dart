import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/app_theme.dart';
import '../../theme/styles.dart';
import '../../util/constants.dart';
import '../images.dart';

class ShowUpdateDialog extends StatelessWidget {
  const ShowUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<BaseController>();
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        body:
            controller.isConnected.value
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(Images.updateImage, width: 200, height: 200),
                    const SizedBox(height: 20),
                    Text(
                      Constants.updatePageTitle.tr,
                      style: Styles.boldTextView(22, Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      Constants.updatePageDescription.tr,
                      style: Styles.regularTextView(
                        14,
                        AppTheme.primaryTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: ElevatedButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            _launchStore(Constants.updatePageAndroidLink);
                          } else if (Platform.isIOS) {
                            _launchStore(Constants.updatePageIOSLink);
                          }
                        },
                        style: Styles.primaryButton(32.0),
                        child: Text(
                          "update".tr,
                          style: Styles.regularTextView(14, Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //TODO handle update button function
                  ],
                )
                : Container(),
        // const NoInternetPage() //TODO replace Container with NoInternetPage()
      ),
    );
  }

  void _launchStore(String storeLink) async {
    print(storeLink);
    try {
      if (await canLaunch(storeLink)) {
        await launch(storeLink);
      } else {
        throw 'Could not launch';
      }
    } catch (e) {
      Get.snackbar("message".tr, 'something_went_wrong'.tr);
    }
  }
}
