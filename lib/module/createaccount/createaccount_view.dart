import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';

import 'createaccount_controller.dart';
import 'createaccount_widgets.dart';

class CreateaccountView extends StatelessWidget {
  const CreateaccountView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CreateaccountController>();
    final double screenHeight = MediaQuery.of(context).size.height;
    final double containerHeight = screenHeight * 0.5;
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body:
            controller.createAccountType.value == "customer"
                ? Stack(
                  children: [
                    SvgPicture.asset(ImageUtil.blue_ellipse),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Image.asset(ImageUtil.logo),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CreateaccountWidgets()
                                  .createAccountCustomerWidget(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Align(
                        alignment:
                            BaseController.languageName.value == "english"
                                ? Alignment.topLeft
                                : Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                : Stack(
                  children: [
                    Visibility(
                      visible: controller.pageNumber.value == 0 ? true : false,
                      child: SvgPicture.asset(ImageUtil.greenEllipse),
                    ),
                    Visibility(
                      visible: controller.pageNumber.value == 1 ? true : false,
                      child: SvgPicture.asset(ImageUtil.small_elipse),
                    ),
                    Visibility(
                      visible: controller.pageNumber.value == 0 ? true : false,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Image.asset(ImageUtil.logo),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.pageNumber.value == 0 ? true : false,
                      child: Positioned(
                        top: containerHeight / 1.85,
                        right: containerHeight / 2.3,
                        child: Text(
                          "Farmer Information".tr,
                          style: Styles.boldTextView(20, AppTheme.white),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.pageNumber.value == 1 ? true : false,
                      child: Positioned(
                        top: containerHeight / 9,
                        right: containerHeight / 1.9,
                        child: Text(
                          "Farm Information".tr,
                          style: Styles.boldTextView(20, AppTheme.white),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: controller.pageNumber.value == 1 ? true : false,
                      child: Positioned(
                        top: containerHeight / 3,
                        right: containerHeight / 3,
                        child: Column(
                          children: [
                            Visibility(
                              visible:
                                  (controller.selectedImagePath.value == "")
                                      ? true
                                      : false,
                              child: InkWell(
                                onTap: () {
                                  controller.pickImagesFromGallery();
                                },
                                child: SvgPicture.asset(ImageUtil.gallery_add),
                              ),
                            ),
                            Visibility(
                              visible:
                                  (controller.selectedImagePath.value != "")
                                      ? true
                                      : false,
                              child: InkWell(
                                onTap: () {
                                  controller.pickImagesFromGallery();
                                },
                                child: Image.file(
                                  File(controller.selectedImagePath.value),
                                  height: 130,
                                  width: 130,
                                ),
                              ),
                            ),
                            Text(
                              "Add the Farms Logo".tr,
                              style: Styles.regularTextView(
                                14,
                                AppTheme.hintDarkGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 300.0),
                      child: SizedBox(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (controller.pageNumber.value == 1) ...[
                                CreateaccountWidgets()
                                    .createAccountFormInformationWidget(
                                      context,
                                    ),
                              ] else ...[
                                CreateaccountWidgets().createaccountWidget(
                                  context,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Align(
                        alignment:
                            BaseController.languageName.value == "english"
                                ? Alignment.topLeft
                                : Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
