import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../../widgets/loader.dart';
import '../../../widgets/location_picker.dart';
import '../../profile/controller/profile_controller.dart';

class EditProfileController extends BaseController {
  RxString logInType = "".obs;
  RxString editForInformationType = "1".obs;
  RxString userName = "".obs;
  var emailTextfield = TextEditingController();
  var locationTextfield = TextEditingController();
  var passwordTextfield = TextEditingController();
  var phoneNumberTextfield = TextEditingController();
  var workingHoursTextfield = TextEditingController();
  var farmDescriptionTextfield = TextEditingController();
  var farmNameTextfield = TextEditingController();
  var nameTextfield = TextEditingController();
  var farmLocationTextfield = TextEditingController();
  RxString farmLogo = "".obs;
  final selectedLatLng = Rxn<LatLng>();
  RxString selectedImagePath = "".obs;
  File? imageFile;
  String base64Image = "";
  @override
  void onInit() {
    super.onInit();
    logInType.value = BaseController.storageService.getLogInType();
    getData();
  }

  getData() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    final results = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      logInType.value,
    );
    userName.value = results?["username"] ?? "";
    emailTextfield.text = results?["email"] ?? "";
    phoneNumberTextfield.text = results?["phoneNumber"] ?? "";
    farmLocationTextfield.text = results?["farmLocation"] ?? "";
    farmDescriptionTextfield.text = results?["farmDescription"] ?? "";
    farmNameTextfield.text = results?["farmName"] ?? "";
    nameTextfield.text = results?["username"] ?? "";
    workingHoursTextfield.text = results?["workingHour"] ?? "";
    locationTextfield.text = results?["location"] ?? "";
    farmLogo.value = results?["farm_logo"] ?? "";
    LoadingIndicator.stopLoading();
  }

  updateProfile(context) async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      Map<String, dynamic> updateProfile = {};
      var email = emailTextfield.value.text.toString();
      // var password = passwordTextfield.value.text.toString();
      var name = nameTextfield.value.text.toString();
      var phonenumber = phoneNumberTextfield.value.text.toString();
      var farmLocation = farmLocationTextfield.value.text.toString();
      var farmDescription = farmDescriptionTextfield.value.text.toString();
      var farmName = farmNameTextfield.value.text.toString();
      var workingHours = workingHoursTextfield.value.text.toString();

      Map<String, dynamic> addressData = {
        "address": "",
        "address_type": "Home",
        "address_title": "",
        "street": "",
        "neighborhood": "",
        "houseNumber": "",
        "lng": 0.0,
        "lat": 0.0,
        "description": "",
      };
      switch (logInType.value) {
        case "farmer":
          updateProfile = {
            "username": name,
            "email": email,
            "phoneNumber": phonenumber,
            "farmName": farmName,
            "farmLocation": farmLocation,
            "farmDescription": farmDescription,
            "workingHour": workingHours,
            "userType": BaseController.storageService.getLogInType(),
            "farm_logo": base64Image,
            "lat": selectedLatLng.value?.latitude,
            "lng": selectedLatLng.value?.longitude,
          };
          print(updateProfile);
        case "customer":
          updateProfile = {
            "username": name,
            "email": email,
            "phoneNumber": phonenumber,
            "current_address": addressData,
            // "password": password,
            "accountType": logInType.value,
            "userType": BaseController.storageService.getLogInType(),
          };
          print(updateProfile);
        case "driver":
          updateProfile = {
            "email": email,
            "phoneNumber": phonenumber,
            // "password": password,
          };
          print(updateProfile);

          break;
        default:
      }

      BaseController.firebaseAuth.updateUserData(updateProfile: updateProfile,
          logInUserType: BaseController.storageService.getLogInType(),
        userId: BaseController.firebaseAuth.getUid()
      );
      BaseController.firebaseAuth.addAddressForCustomer(addressData);
      Get.back();
      Get.find<ProfileController>().getData();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
  void openGoogleMaps() async {
    final pickedLocation = await Get.to(() => LocationPickerScreen());
    if (pickedLocation != null && pickedLocation is LatLng) {
      selectedLatLng.value = pickedLocation;
      getAddressFromLatLng(
        LatLng(
          double.parse(selectedLatLng.value!.latitude.toString()),
          double.parse(selectedLatLng.value!.longitude.toString()),
        ),
      );
    }
  }
  Future<void> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks[0];
        farmLocationTextfield.text =
        "${place.subLocality},${place.locality},${place.administrativeArea},${place.country}";
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }
  Future<void> pickImagesFromGallery() async {
    final image = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (image != null && image.paths.isNotEmpty) {
      final filePath = image.paths.first;
      selectedImagePath.value = filePath??"";
      if (filePath != null) {
        imageFile = File(filePath);
        List<int> imageBytes = await imageFile!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
    } else {}
  }

  timeRangePicker(BuildContext context) async {
    TimeRange? result = await showTimeRangePicker(
      context: context,
      start: TimeOfDay.now(),
      disabledColor: Colors.red.withOpacity(0.5),
      strokeWidth: 4,
      ticks: 24,
      ticksOffset: -7,
      ticksLength: 15,
      ticksColor: Colors.grey,
      labels:
          [
            "12 am",
            "3 am",
            "6 am",
            "9 am",
            "12 pm",
            "3 pm",
            "6 pm",
            "9 pm",
          ].asMap().entries.map((e) {
            return ClockLabel.fromIndex(idx: e.key, length: 8, text: e.value);
          }).toList(),
      labelOffset: 35,
      rotateLabels: false,
      padding: 60,
    );
    if (result != null) {
      workingHoursTextfield.text = formatTimeRange(
        result.startTime,
        result.endTime,
      );
    }

    print("result $result");
  }

  String formatTimeRange(TimeOfDay startTime, TimeOfDay endTime) {
    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      endTime.hour,
      endTime.minute,
    );

    // Format DateTime using DateFormat
    final timeFormat = DateFormat('HH:mm a');

    String startFormatted = timeFormat.format(startDateTime);
    String endFormatted = timeFormat.format(endDateTime);

    // Combine them in the desired format
    return '$startFormatted - $endFormatted';
  }
}
