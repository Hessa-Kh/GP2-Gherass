import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/widgets/loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/location_picker.dart';

class EventController extends BaseController {
  var isEdit = false.obs;
  RxInt maxNumberOfVisit = 1.obs;
  var enableToEdit = false.obs;
  var eventNameController = TextEditingController();
  var startDateController = TextEditingController();
  var eventDescriptionController = TextEditingController();
  var eventLocationController = TextEditingController();
  var eventMinimumNumberController = TextEditingController();
  var eventId = "".obs;
  var remainingTickets = "".obs;
  var maxMembersForTickets = "".obs;
  var farmerEvents = <Map<String, dynamic>>[].obs;
  final selectedLatLng = Rxn<LatLng>();
  var address = ''.obs;


  @override
  void onInit() {
    super.onInit();
    getEventList();
  }

  void updateFields(arguments) {
    isEdit.value = true;
    enableToEdit.value = false;
    eventNameController.text = arguments["name"].toString();
    startDateController.text = arguments["start_date"].toString();
    eventMinimumNumberController.text = arguments["max_numbers"].toString();
    maxMembersForTickets.value = arguments["max_numbers"].toString();
    eventDescriptionController.text = arguments["description"].toString();
    eventLocationController.text = arguments["location"].toString();
    remainingTickets.value =  arguments["remaining_tickets"].toString();
    maxNumberOfVisit.value = int.tryParse(maxMembersForTickets.value)??0;
    eventId.value = arguments["id"].toString();
  }

  Future<void> getEventList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.removeExpiredDoc(
        "events",
        "start_date",
        formatDateTime(DateTime.now().toString()),
      );
      final response = await BaseController.firebaseAuth.fetchFarmerEvents(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        farmerEvents.assignAll(response.cast<Map<String, dynamic>>());
      }
      print(farmerEvents);
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat outputFormat = DateFormat("dd MMM h:mm a");
    DateTime customDate = dateTime;
    return outputFormat.format(customDate);
  }

  void postEvents() async {
    if (eventNameController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Event name cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (startDateController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Date is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (eventDescriptionController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Description type cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (eventLocationController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }
    if (eventMinimumNumberController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    Map<String, dynamic> eventData = {
      "name": eventNameController.text,
      "start_date": startDateController.text,
      "max_numbers": eventMinimumNumberController.text,
      "remaining_tickets": eventMinimumNumberController.text,
      "description": eventDescriptionController.text,
      "lat": selectedLatLng.value?.latitude,
      "lng": selectedLatLng.value?.longitude,
      "location": address.value,
    };

    log(eventData.toString());

    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.addEventsToFarmer(eventData);
      Get.back();
      Get.snackbar(
        "Success",
        "Even added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );
      getEventList();
      eventNameController.clear();
      startDateController.clear();
      eventMinimumNumberController.clear();
      eventDescriptionController.clear();
      eventLocationController.clear();
      maxNumberOfVisit.value = 1;
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar(
        "Error",
        "Failed to add product: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
    }
  }

  void updateEvents() async {
    if (eventNameController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Event name cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (startDateController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Date is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (eventDescriptionController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Description type cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (eventLocationController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }
    if (eventMinimumNumberController.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    Map<String, dynamic> eventData = {
      "name": eventNameController.text,
      "start_date": startDateController.text,
      "max_numbers": eventMinimumNumberController.text,
      "remaining_tickets":updateRemainTickets(),
      "description": eventDescriptionController.text,
      "lat": selectedLatLng.value?.latitude,
      "lng": selectedLatLng.value?.longitude,
      "location": address.value,
    };

    log(eventData.toString());

    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.updateEventsToFarmer(
        eventId.value,
        eventData,
      );
      Get.back();
      Get.snackbar(
        "Success",
        "Event updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );
      getEventList();
      eventNameController.clear();
      startDateController.clear();
      eventMinimumNumberController.clear();
      eventDescriptionController.clear();
      eventLocationController.clear();
      maxNumberOfVisit.value = 1;
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar(
        "Error",
        "Failed to add Event: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
    }
  }
String updateRemainTickets(){
    RxString remainingValue = "".obs;
  if (maxMembersForTickets.value.isNotEmpty||remainingTickets.value.isNotEmpty) {
    int balance = (int.parse(remainingTickets.value)+ (int.parse(eventMinimumNumberController.text)-int.parse(maxMembersForTickets.value)));
    if(balance >= 0){
      remainingValue.value =balance.toString();
    }else{
      remainingValue.value = "0";
    }
  }
  return remainingValue.value??"";
}
  void deleteEvent() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      await BaseController.firebaseAuth.deleteFarmEvent(eventId.value);

      farmerEvents.removeWhere((product) => product['id'] == eventId.value);
      Get.back();
      getEventList();
      LoadingIndicator.stopLoading();
    } catch (e) {
      print("Error deleting product: $e");
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
        address.value =
        "${place.locality}, ${place.subLocality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
        eventLocationController.text = address.value;
      }
    } catch (e) {
      print("Error getting address: $e");
      address.value = "Unknown location";
    }
  }

}
