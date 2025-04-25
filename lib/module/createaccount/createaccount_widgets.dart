
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';

import '../../theme/app_theme.dart';
import 'createaccount_controller.dart';

class CreateaccountWidgets {
  var controller = Get.find<CreateaccountController>();
  Widget createaccountWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("name".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.nameTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.nameError.value.isNotEmpty
                      ? controller.nameError.value
                      : null,
              hintText: "your_full_name".tr,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "id_resident_number".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller.idTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.idError.value.isNotEmpty
                      ? controller.idError.value
                      : null,
              hintText: "id_resident_number".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("email".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.emailTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.emailError.value.isNotEmpty
                      ? controller.emailError.value
                      : null,
              hintText: "your_email".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("phone_number".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.phonenumberTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.phoneNumberError.value.isNotEmpty
                      ? controller.phoneNumberError.value
                      : null,
              hintText: "your_phone_number".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("Password".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.passwordTextfield,
            obscureText: !controller.passwordVisibility.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.passwordError.value.isNotEmpty
                      ? controller.passwordError.value
                      : null,
              hintText: "Password".tr,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.passwordVisibility.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  controller.passwordVisibility.toggle();
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.validationForPersonalInformation()) {
                    controller.pageNumber.value = 1;
                  }
                  // controller.createAccount(context);
                }, //93C249
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(147, 194, 73, 1),
                ),
                child: Text("next".tr, style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createAccountFormInformationWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Farm Name".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.farmNameTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.farmNameError.value.isNotEmpty
                      ? controller.farmNameError.value
                      : null,
              hintText: "Your Farm Name".tr,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Farm Location".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller.farmLocationTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.farmLocationError.value.isNotEmpty
                      ? controller.farmLocationError.value
                      : null,
              hintText: "Your Farm Location".tr,
              suffixIcon: IconButton(
                icon: SvgPicture.asset(ImageUtil.location),
                onPressed: () async {controller.openGoogleMaps();},
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Farm Certificate".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller.farmCertificateTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.farmCertificateError.value.isNotEmpty
                      ? controller.farmCertificateError.value
                      : null,
              hintText: "Upload Your Farm Certificate".tr,
              suffixIcon: IconButton(
                icon: SvgPicture.asset(ImageUtil.upload),
                onPressed: () async {
                  await controller.pickFilesFromGallery();
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Working Hours".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller.workingHoursTextfield,
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.workingHoursError.value.isNotEmpty
                      ? controller.workingHoursError.value
                      : null,
              hintText: "Farms Working Hours".tr,
              suffixIcon: IconButton(
                icon: SvgPicture.asset(ImageUtil.time),
                onPressed: () async {
                  controller.timeRangePicker(context);
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Farm Description".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller.farmDescriptionTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.farmDescriptionError.value.isNotEmpty
                      ? controller.farmDescriptionError.value
                      : null,
              hintText: "Your Farms Description".tr,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.validationForFormInformation()) {
                    controller.pageNumber.value = 1;
                    controller.createAccount(context);
                  }
                }, //93C249
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(147, 194, 73, 1),
                ),
                child: Text("Confirm".tr, style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createAccountCustomerWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("name".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.nameTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.nameError.value.isNotEmpty
                      ? controller.nameError.value
                      : null,
              hintText: "your_full_name".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("email".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.emailTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.emailError.value.isNotEmpty
                      ? controller.emailError.value
                      : null,
              hintText: "your_email".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("phone_number".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.phonenumberTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.phoneNumberError.value.isNotEmpty
                      ? controller.phoneNumberError.value
                      : null,
              hintText: "your_phone_number".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("Password".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            controller: controller.passwordTextfield,
            obscureText: !controller.passwordVisibility.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.passwordError.value.isNotEmpty
                      ? controller.passwordError.value
                      : null,
              hintText: "Password".tr,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.passwordVisibility.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  controller.passwordVisibility.toggle();
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Please specify your account type:".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          CustomSlidingSegmentedControl(
            initialValue: 1,
            isStretch: true,
            height: 30,
            children: {
              1: Text('Personal account'.tr),
              2: Text('Business account'.tr),
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
              if (v == 1) {
                controller.customerAccountType.value = "Personal account";
              } else {
                controller.customerAccountType.value = "Business account";
              }
              print(v);
            },
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.validationForCustomer()) {
                    controller.createAccount(context);
                  }
                }, //93C249
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightPurple,
                ),
                child: Text(
                  "Create an account".tr,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Do you already have an account?".tr,
              style: Styles.boldTextView(10, AppTheme.lightPurple),
            ),
          ),
        ],
      ),
    );
  }
}
