import 'dart:convert';
import 'dart:io';

import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/editprofile/controller/edit_profile_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';

import '../../../util/image_util.dart';
import '../../../widgets/svg_icon_widget.dart';

class EditProfileWidgets {
  var controller = Get.find<EditProfileController>();
  Widget editProfileViewWidget(BuildContext context) {
    if (controller.logInType.value.contains("farmer") == true) {
      return editProfileForFarmer(context);
    } else if (controller.logInType.value.contains("customer") == true) {
      return editProfileForCustomer(context);
    } else {
      return editProfileForDriver(context);
    }
  }

  Widget editProfileForCustomer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Edit account information".tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                    controller.userName.value.tr,
                    style: Styles.boldTextView(20, AppTheme.black),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Phone Number".tr,
                style: Styles.mediumTextView(14, Colors.black),
              ),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.phoneNumberTextfield,
                  decoration: InputDecoration(
                    fillColor: AppTheme.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Phone Number".tr,
                    suffixIcon: IconButton(
                      icon: SvgIcon(ImageUtil.edit, size: 25),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text("Email".tr, style: Styles.mediumTextView(14, Colors.black)),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  controller: controller.emailTextfield,
                  decoration: InputDecoration(
                    fillColor: AppTheme.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Email".tr,
                    // suffixIcon: IconButton(
                    //   icon: SvgIcon(ImageUtil.edit, size: 25),
                    //   onPressed: () {},
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Password".tr,
                style: Styles.mediumTextView(14, Colors.black),
              ),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  controller: controller.passwordTextfield,
                  decoration: InputDecoration(
                    fillColor: AppTheme.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Password".tr,
                    // suffixIcon: IconButton(
                    //   icon: SvgIcon(ImageUtil.edit, size: 25),
                    //   onPressed: () {},
                    // ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Location".tr,
                style: Styles.mediumTextView(14, Colors.black),
              ),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.locationTextfield,
                  decoration: InputDecoration(
                    fillColor: AppTheme.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Location".tr,
                    suffixIcon: IconButton(
                      icon: SvgIcon(ImageUtil.edit, size: 25),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 190,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.updateProfile(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightPurple,
                    ),
                    child: Text("Confirm".tr, style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editProfileForDriver(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
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
                  controller.userName.value.tr,
                  style: Styles.boldTextView(20, AppTheme.black),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Phone Number".tr,
              style: Styles.mediumTextView(14, Colors.black),
            ),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                controller: controller.phoneNumberTextfield,
                decoration: InputDecoration(
                  fillColor: AppTheme.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Phone Number".tr,
                  suffixIcon: IconButton(
                    icon: SvgIcon(ImageUtil.edit, size: 25),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text("Email".tr, style: Styles.mediumTextView(14, Colors.black)),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                controller: controller.emailTextfield,
                decoration: InputDecoration(
                  fillColor: AppTheme.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Email".tr,
                  // suffixIcon: IconButton(
                  //   icon: SvgIcon(ImageUtil.edit, size: 25),
                  //   onPressed: () {},
                  // ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text("Password".tr, style: Styles.mediumTextView(14, Colors.black)),
            SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2.0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                controller: controller.passwordTextfield,
                decoration: InputDecoration(
                  fillColor: AppTheme.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Password".tr,
                  // suffixIcon: IconButton(
                  //   icon: SvgIcon(ImageUtil.edit, size: 25),
                  //   onPressed: () {},
                  // ),
                ),
              ),
            ),
            SizedBox(height: 80),
            Center(
              child: SizedBox(
                width: 190,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.updateProfile(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                  ),
                  child: Text("Confirm".tr, style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget editProfileForFarmer(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.editForInformationType.value == "1") ...[
                editPersonalInformationWidget(),
              ] else ...[
                editFarmInformationWidget(context),
              ],

              SizedBox(height: 40),
              CustomSlidingSegmentedControl(
                initialValue: 1,
                isStretch: true,
                height: 30,
                children: {
                  1: Text('Personal information'.tr),
                  2: Text('Farm information'.tr),
                },
                decoration: BoxDecoration(
                  color: CupertinoColors.lightBackgroundGray,
                  borderRadius: BorderRadius.circular(8),
                ),
                thumbDecoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInToLinear,
                onValueChanged: (v) {
                  controller.editForInformationType.value = v.toString();
                  print(v);
                },
              ),
              SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: 190,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await controller.updateProfile(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: Text("Confirm".tr, style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget editPersonalInformationWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible:
                (controller.selectedImagePath.value == "")
                    ? true
                    : false,
                replacement: InkWell(
                  onTap: () {
                    controller.pickImagesFromGallery();
                  },
                  child: ClipOval(
                    child: Image.file(
                      File(controller.selectedImagePath.value),
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
                child: Visibility(
                  visible: controller.farmLogo.isEmpty,
                  replacement: ClipOval(
                    child: InkWell(
                      onTap: () {
                        controller.pickImagesFromGallery();
                      },
                      child: Image.memory(
                        base64Decode(controller.farmLogo.value),
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  child: SvgIcon(ImageUtil.profile_circle, size: 75),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.userName.value.tr,
                style: Styles.boldTextView(20, AppTheme.black),
              ),
            ],
          ),
          SizedBox(height: 25),
          Text("Name".tr, style: Styles.mediumTextView(14, Colors.black)),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.nameTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Name".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Phone Number".tr,
            style: Styles.mediumTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.phoneNumberTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Phone Number".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text("Email".tr, style: Styles.mediumTextView(14, Colors.black)),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              readOnly: true,
              controller: controller.emailTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Email".tr,
                // suffixIcon: IconButton(
                //   icon: SvgIcon(ImageUtil.edit, size: 25),
                //   onPressed: () {},
                // ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text("Password".tr, style: Styles.mediumTextView(14, Colors.black)),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              readOnly: true,
              controller: controller.passwordTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Password".tr,
                // suffixIcon: IconButton(
                //   icon: SvgIcon(ImageUtil.edit, size: 25),
                //   onPressed: () {},
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget editFarmInformationWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Farm information".tr,
                style: Styles.boldTextView(20, AppTheme.black),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible:
                (controller.selectedImagePath.value == "")
                    ? true
                    : false,
                replacement: InkWell(
                  onTap: () {
                    controller.pickImagesFromGallery();
                  },
                  child: ClipOval(
                    child: Image.file(
                      File(controller.selectedImagePath.value),
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
                child: Visibility(
                  visible: controller.farmLogo.isEmpty,
                  replacement: ClipOval(
                    child: InkWell(
                      onTap: () {
                        controller.pickImagesFromGallery();
                      },
                      child: Image.memory(
                        base64Decode(controller.farmLogo.value),
                        height: 80,
                        width: 80,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  child: SvgIcon(ImageUtil.profile_circle, size: 75),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.userName.value.tr,
                style: Styles.boldTextView(20, AppTheme.black),
              ),
            ],
          ),
          SizedBox(height: 25),
          Text(
            "Farm Name".tr,
            style: Styles.mediumTextView(14, AppTheme.black),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.farmNameTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Farm Name".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Working Hours".tr,
            style: Styles.mediumTextView(14, AppTheme.black),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.workingHoursTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Working Hours".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () async {
                    controller.timeRangePicker(context);
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Farm Description".tr,
            style: Styles.mediumTextView(14, AppTheme.black),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.farmDescriptionTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Farm Description".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Farm Location".tr,
            style: Styles.mediumTextView(14, AppTheme.black),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.farmLocationTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Farm Location".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {controller.openGoogleMaps();},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text("Email".tr, style: Styles.mediumTextView(14, AppTheme.black)),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.emailTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Email".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          Text(
            "Phone Number".tr,
            style: Styles.mediumTextView(14, AppTheme.black),
          ),
          SizedBox(height: 5),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
              ],
            ),
            child: TextField(
              controller: controller.phoneNumberTextfield,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Phone Number".tr,
                suffixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
