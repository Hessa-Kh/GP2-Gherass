import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/orders/controller/orders_controller.dart';
import 'package:gherass/module/profile/controller/profile_controller.dart';
import 'package:gherass/theme/styles.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../helper/routes.dart';
import '../../../theme/app_theme.dart';
import '../../../util/image_util.dart';
import '../../../widgets/svg_icon_widget.dart';
import '../../orders/view/orders_view.dart';
import '../../vehicle_info/view/vehicle_info_view.dart';

class ProfileViewWidgets {
  var controller = Get.find<ProfileController>();

  Widget profileViewWidget(BuildContext context) {
    if (controller.logInType.value.contains("farmer") == true) {
      return profileViewWidgetForFormer(context);
    } else if (controller.logInType.value.contains("customer") == true) {
      return profileViewWidgetForCustomer(context);
    } else {
      return profileViewWidgetForDriver(context);
    }
  }

  Widget profileViewWidgetForFormer(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: controller.farmLogo.isEmpty,
                  replacement: ClipOval(
                    child: Image.memory(
                      base64Decode(controller.farmLogo.value),
                      height: 80,
                      width: 80,
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: SvgIcon(ImageUtil.profile_circle, size: 75),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userName.value ?? "",
                  style: Styles.boldTextView(20, AppTheme.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppTheme.hintDarkGray,
                ),
                Text(
                  controller.farmName.value ?? "",
                  style: Styles.boldTextView(12, AppTheme.hintDarkGray),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.phoneNumber.value ?? "",
                  style: Styles.boldTextView(12, AppTheme.hintDarkGray),
                ),
              ],
            ),
            // SizedBox(height: 50),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     CircleAvatar(
            //       backgroundColor: AppTheme.borderColor,
            //       child: SvgIcon(ImageUtil.building, size: 25),
            //     ),
            //     SizedBox(width: 20),
            //     Text("Farm".tr, style: Styles.boldTextView(20, AppTheme.black)),
            //   ],
            // ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.editProfile);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.setting, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Settings".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await BaseController().changeLanguage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.global, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "English".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                showCustomDialog(context, "Log out".tr, () async {
                  await BaseController.firebaseAuth.logout();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Log out".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.redAccent.shade100,
                    child: SvgIcon(ImageUtil.logout, size: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showCustomDialog(context, "Delete account".tr, () async {
                      await BaseController.firebaseAuth.deleteCurrentUser();
                    });
                  },
                  child: Text(
                    "Delete account".tr,
                    style: Styles.boldTextView(20, Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profileViewWidgetForCustomer(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SvgIcon(ImageUtil.profile_circle, size: 75)],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userName.value ?? "",
                  style: Styles.boldTextView(20, AppTheme.black),
                ),
              ],
            ),
            Visibility(
              visible: controller.location.isNotEmpty,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.location.value ?? "",
                    style: Styles.boldTextView(12, AppTheme.hintDarkGray),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.hintDarkGray,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.phoneNumber.value ?? "",
                  style: Styles.boldTextView(12, AppTheme.hintDarkGray),
                ),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.deliveryAddress);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.home, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Delivery address".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.editProfile);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.setting, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Settings".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await BaseController().changeLanguage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.global, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "English".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () async {
                showCustomDialog(context, "Log out".tr, () async {
                  await BaseController.firebaseAuth.logout();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Log out".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.redAccent.shade100,
                    child: SvgIcon(ImageUtil.logout, size: 25),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showCustomDialog(context, "Delete account".tr, () async {
                      await BaseController.firebaseAuth.deleteCurrentUser();
                    });
                  },
                  child: Text(
                    "Delete account".tr,
                    style: Styles.boldTextView(20, Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget profileViewWidgetForDriver(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SvgIcon(ImageUtil.profile_circle, size: 75)],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userName.value ?? "",
                  style: Styles.boldTextView(20, AppTheme.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.phoneNumber.value ?? "",
                  style: Styles.boldTextView(12, AppTheme.hintDarkGray),
                ),
              ],
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                Get.to(() => VehicleInfoView(showBackButton: true));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.car, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Vehicle".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.ordersPage);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.note, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Orders History".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.editProfile);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.setting, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Settings".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                await BaseController().changeLanguage();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.borderColor,
                    child: SvgIcon(ImageUtil.global, size: 25),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "English".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              onTap: () {
                showCustomDialog(context, "Log out".tr, () async {
                  await BaseController.firebaseAuth.logout();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Sign Out".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.redAccent.shade100,
                    child: SvgIcon(ImageUtil.logout, size: 25),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showCustomDialog(
    BuildContext context,
    String title,
    void Function()? onPressConfirm,
  ) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(35),
            child: SizedBox(
              height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(title, style: Styles.boldTextView(24, AppTheme.black)),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.lightGray,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Cancel".tr,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onPressConfirm,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.lightRose,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.lightGray,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Yes".tr,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
