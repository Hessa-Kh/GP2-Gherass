import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/app_theme.dart';
import '../../../../theme/styles.dart';
import '../../../../util/image_util.dart';
import '../../../../widgets/svg_icon_widget.dart';
import '../../controller/vehicle_info_controller.dart';

class VehicleInfoWidgets {
  var controller = Get.find<VehicleInfoController>();

  Widget vehicleInfoWidget() {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextControllerWidget(
              label: "License Plate Number".tr,
              controllers: controller.licencePlateNumberTextField,
              isEditing: controller.licensePlateEditing,
            ),
            customTextControllerWidget(
              label: "Maker Company".tr,
              controllers: controller.makerCompanyTextField,
              isEditing: controller.makerCompanyEditing,
            ),
            customTextControllerWidget(
              label: "Car Model".tr,
              controllers: controller.carModelTextField,
              isEditing: controller.carModelEditing,
            ),
            customTextControllerWidget(
              label: "Year of Car Model".tr,
              controllers: controller.yearOfCarModelTextField,
              isEditing: controller.yearOfCarModelEditing,
            ),
            customTextControllerWidget(
              label: "Car Color".tr,
              controllers: controller.carColorTextField,
              isEditing: controller.carColorEditing,
            ),
            Center(
              child: SizedBox(
                width: 190,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    controller.updateVehicleInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                  ),
                  child: Text("Confirm".tr, style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget customTextControllerWidget({
    required String label,
    required TextEditingController controllers,
    required RxBool isEditing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.mediumTextView(16, Color(0xff333333))),
        SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 6),
                blurRadius: 7,
              ),
            ],
          ),
          child: Obx(
            () => TextField(
              controller: controllers,
              readOnly: !isEditing.value,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                fillColor: AppTheme.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                hintText: label,
                hintStyle: Styles.mediumTextView(16, Color(0xff797D82)),
                prefixIcon: IconButton(
                  icon: SvgIcon(ImageUtil.edit, size: 25),
                  onPressed: () {
                    isEditing.value = !isEditing.value;
                  },
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 25),
      ],
    );
  }
}
