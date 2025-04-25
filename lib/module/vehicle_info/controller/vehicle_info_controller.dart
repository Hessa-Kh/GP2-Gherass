import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/loader.dart';

class VehicleInfoController extends BaseController {
  var licencePlateNumberTextField = TextEditingController();
  var makerCompanyTextField = TextEditingController();
  var carModelTextField = TextEditingController();
  var yearOfCarModelTextField = TextEditingController();
  var carColorTextField = TextEditingController();

  var isEditing = false.obs;
  var licensePlateEditing = false.obs;
  var makerCompanyEditing = false.obs;
  var carModelEditing = false.obs;
  var yearOfCarModelEditing = false.obs;
  var carColorEditing = false.obs;

  var vehicleInfo = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    getVehicleInfo();
  }

  Future<void> getVehicleInfo() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      final response = await BaseController.firebaseAuth
          .fetchVehicleInfo(BaseController.firebaseAuth.getUid());

      if (response != null && response.isNotEmpty) {
        vehicleInfo
          ..clear()
          ..assignAll(response.cast<Map<String, dynamic>>());

        final data = vehicleInfo.first;
        licencePlateNumberTextField.text = data['licence_plate_number'] ?? '';
        makerCompanyTextField.text = data['maker_company'] ?? '';
        carModelTextField.text = data['car_model'] ?? '';
        yearOfCarModelTextField.text = data['year_of_car_model'] ?? '';
        carColorTextField.text = data['car_color'] ?? '';
      } else {
        Get.snackbar("Error", "No vehicle information found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to Fetch Vehicle Info: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  Future<void> updateVehicleInfo() async {
    if (!validateFields()) return;

    final vehicleData = {
      "licence_plate_number": licencePlateNumberTextField.text.trim(),
      "maker_company": makerCompanyTextField.text.trim(),
      "car_model": carModelTextField.text.trim(),
      "year_of_car_model": yearOfCarModelTextField.text.trim(),
      "car_color": carColorTextField.text.trim(),
    };

    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      await BaseController.firebaseAuth
          .updateVehicleInfo(BaseController.firebaseAuth.getUid(), vehicleData);

      Get.snackbar("Success", "Vehicle Info updated successfully",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);

      await getVehicleInfo();
    } catch (e) {
      Get.snackbar("Error", "Failed to update Vehicle Info: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  bool validateFields() {
    final errors = {
      "Licence Plate Number": licencePlateNumberTextField.text.isEmpty,
      "Maker Company": makerCompanyTextField.text.isEmpty,
      "Car Model": carModelTextField.text.isEmpty,
      "Year of Car": yearOfCarModelTextField.text.isEmpty,
      "Car Color": carColorTextField.text.isEmpty,
    };

    for (var entry in errors.entries) {
      if (entry.value) {
        Get.snackbar("Validation Error", "${entry.key} cannot be empty",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose);
        return false;
      }
    }

    return true;
  }
}
