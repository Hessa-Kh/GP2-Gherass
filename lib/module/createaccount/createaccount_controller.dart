import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/widgets/loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../widgets/location_picker.dart';

class CreateaccountController extends BaseController {
  var loginUser = "".obs;
  RxInt pageNumber = 0.obs;
  var appVersion = "".obs;
  RxString createAccountType = "".obs;
  RxString customerAccountType = "".obs;
  var obscureText = true.obs;

  var emailError = ''.obs;
  var passwordError = ''.obs;
  var nameError = ''.obs;
  var idError = ''.obs;
  var phoneNumberError = ''.obs;
  var farmNameError = ''.obs;
  var farmLocationError = ''.obs;
  var farmCertificateError = ''.obs;
  var workingHoursError = ''.obs;
  var farmDescriptionError = ''.obs;
  RxString selectedImagePath = "".obs;
  var storage = Get.find<StorageService>();
  File? imageFile;
  String base64Image = "";
  String base64File = "";
  final selectedLatLng = Rxn<LatLng>();

  var emailTextfield = TextEditingController();
  var passwordTextfield = TextEditingController();
  var nameTextfield = TextEditingController();
  var idTextfield = TextEditingController();
  var phonenumberTextfield = TextEditingController();
  var farmNameTextfield = TextEditingController();
  var farmLocationTextfield = TextEditingController();
  var farmCertificateTextfield = TextEditingController();
  var workingHoursTextfield = TextEditingController();
  var farmDescriptionTextfield = TextEditingController();
  RxBool passwordVisibility = false.obs;
  //var forgotPassword = TextEditingController();

  @override
  void onInit() {
    createAccountType.value = Get.arguments[0];
    getData();
  }

  bool validationForPersonalInformation() {
    bool isValid = true;

    if (emailTextfield.text.isEmpty) {
      emailError.value = 'please enter valid email'.tr;
      isValid = false;
    } else {
      emailError.value = '';
    }
    if (nameTextfield.text.isEmpty) {
      nameError.value = 'Please enter your full name'.tr;
      isValid = false;
    } else {
      nameError.value = '';
    }
    if (idTextfield.text.isEmpty) {
      idError.value = 'ID or residence number'.tr;
      isValid = false;
    } else {
      idError.value = '';
    }
    if (phonenumberTextfield.text.isEmpty) {
      phoneNumberError.value = 'please enter your phone number'.tr;
      isValid = false;
    } else {
      phoneNumberError.value = '';
    }
    if (passwordTextfield.text.isEmpty) {
      passwordError.value = 'Please enter password'.tr;
      isValid = false;
    } else {
      passwordError.value = '';
    }
    return isValid;
  }

  bool validationForFormInformation() {
    bool isValid = true;

    if (farmNameTextfield.text.isEmpty) {
      farmNameError.value = 'please enter Your Farm Name'.tr;
      isValid = false;
    } else {
      farmNameError.value = '';
    }
    if (farmLocationTextfield.text.isEmpty) {
      farmLocationError.value = 'Please enter your farm location'.tr;
      isValid = false;
    } else {
      farmLocationError.value = '';
    }
    if (farmCertificateTextfield.text.isEmpty) {
      farmCertificateError.value = 'please select certificate'.tr;
      isValid = false;
    } else {
      farmCertificateError.value = '';
    }
    if (workingHoursTextfield.text.isEmpty) {
      workingHoursError.value = 'please enter working hours'.tr;
      isValid = false;
    } else {
      workingHoursError.value = '';
    }
    if (farmDescriptionTextfield.text.isEmpty) {
      farmDescriptionError.value = 'Please enter your farms description'.tr;
      isValid = false;
    } else {
      farmDescriptionError.value = '';
    }
    return isValid;
  }

  bool validationForCustomer() {
    bool isValid = true;

    if (emailTextfield.text.isEmpty) {
      emailError.value = 'please enter valid email'.tr;
      isValid = false;
    } else {
      emailError.value = '';
    }
    if (nameTextfield.text.isEmpty) {
      nameError.value = 'Please enter your full name'.tr;
      isValid = false;
    } else {
      nameError.value = '';
    }
    if (phonenumberTextfield.text.isEmpty) {
      phoneNumberError.value = 'please enter your phone number'.tr;
      isValid = false;
    } else {
      phoneNumberError.value = '';
    }
    if (passwordTextfield.text.isEmpty) {
      passwordError.value = 'Please enter password'.tr;
      isValid = false;
    } else {
      passwordError.value = '';
    }
    return isValid;
  }

  getData() async {
    numberFormating();
  }

  Future<void> pickImagesFromGallery() async {
    final image = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (image != null && image.paths.isNotEmpty) {
      final filePath = image.paths.first;
      selectedImagePath.value = filePath ?? "";
      if (filePath != null) {
        imageFile = File(filePath);
        List<int> imageBytes = await imageFile!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
    } else {
      print('No file selected');
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

  Future<void> pickFilesFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      final selectedFile = result.files.single;

      farmCertificateTextfield.text = selectedFile.name;

      print("Selected file: ${selectedFile.name}");

      if (selectedFile.path != null) {
        try {
          File file = File(selectedFile.path!);
          List<int> fileBytes = await file.readAsBytes();

          base64File = base64Encode(fileBytes);

          print("Base64 File: $base64File");
        } catch (e) {
          print("Error converting file to base64: $e");
        }
      }
    } else {
      print("No file selected");
    }
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

    final timeFormat = DateFormat('HH:mm a');

    String startFormatted = timeFormat.format(startDateTime);
    String endFormatted = timeFormat.format(endDateTime);

    return '$startFormatted - $endFormatted';
  }

  String numberFormating() {
    final number =
        (passwordTextfield.text.isEmpty) ? "XXXXXXXXX" : passwordTextfield.text;
    final result =
        (passwordTextfield.text.isEmpty || passwordTextfield.text.length < 9)
            ? "XX"
            : number.substring(7, 9);
    return result;
  }

  createAccount(context) async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      Map<String, dynamic> registerForm = {};
      var email = emailTextfield.value.text.toString();
      var password = passwordTextfield.value.text.toString();
      var name = nameTextfield.value.text.toString();
      var residenceId = idTextfield.value.text.toString();
      var phonenumber = phonenumberTextfield.value.text.toString();
      var farmLocation = farmLocationTextfield.value.text.toString();
      var farmDescription = farmDescriptionTextfield.value.text.toString();
      var farmName = farmNameTextfield.value.text.toString();
      var workingHours = workingHoursTextfield.value.text.toString();

      createAccountType.value = BaseController.storageService.getLogInType();

      log("createAccountType:${createAccountType.value}");

      switch (createAccountType.value) {
        case "farmer":
          registerForm = {
            "username": name,
            "residenceId": residenceId,
            "email": email,
            "phoneNumber": phonenumber,
            "password": password,
            "farmName": farmName,
            "farmLocation": farmLocation,
            "farmCertificateName": farmCertificateTextfield.text.toString(),
            "farmCertificate": base64File,
            "farmDescription": farmDescription,
            "workingHour": workingHours,
            "userType": BaseController.storageService.getLogInType(),
            "farm_logo": base64Image,
            "lat": selectedLatLng.value?.latitude,
            "lng": selectedLatLng.value?.longitude,
          };

        case "customer":
          registerForm = {
            "username": name,
            "email": email,
            "phoneNumber": phonenumber,
            "password": password,
            "accountType": customerAccountType.value,
            "userType": BaseController.storageService.getLogInType(),
          };

        case "driver":
          registerForm = {};

          break;
        default:
      }

      BaseController.firebaseAuth.signUp(registerUser: registerForm);
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  @override
  void dispose() {
    emailTextfield.dispose();
    passwordTextfield.dispose();
    super.dispose();
  }
}
