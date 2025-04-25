import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/widgets/loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../theme/app_theme.dart';

class DeliveryAddressController extends BaseController {
  var isAddingNewAddress = false.obs;
  var addressTitle = TextEditingController();
  var description = TextEditingController();
  var selectedIndex = 0.obs;
  var addressType = "";
  var markers = <Marker>{}.obs;
  final LatLng initialPosition = LatLng(24.4672, 39.6024);
  GoogleMapController? mapController;
  var currentLocation = Rxn<LatLng>();
  var address = ''.obs;
  var street = TextEditingController();
  var neighborhood = TextEditingController();
  var houseNumber = TextEditingController();
  var addressList = <Map<String, dynamic>>[].obs;
  var addressId = "".obs;
  var getVal = {};

  RxList sectionList = ["Home".tr, "Work".tr, "Other".tr].obs;
  var selectedAddress = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      getVal = Get.arguments;
      street.text = getVal["street"];
      neighborhood.text = getVal["neighborhood"];
      houseNumber.text = getVal["houseNumber"];
      final lat = double.parse(getVal["lat"].toString());
      final lng = double.parse(getVal["lng"].toString());
      LatLng newLocation = LatLng(lat, lng);
      updateMarkerPosition(newLocation);
    }

    getAddressList();
  }

  void getAddressList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchAddressList(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        addressList.assignAll(response.cast<Map<String, dynamic>>());
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void deleteAddress(String addressId, String addressType) async {
    Map<String, dynamic> addressData = {
      "address": "",
      "address_type":
          selectedIndex.value == 0
              ? "Home"
              : selectedIndex.value == 1
              ? "Work"
              : "other" ?? "",
      "address_title": "",
      "street": street.text,
      "neighborhood": neighborhood.text,
      "houseNumber": houseNumber.text,
      "lng": currentLocation.value?.longitude ?? 0.0,
      "lat": currentLocation.value?.latitude ?? 0.0,
      "description": description.text ?? "",
    };
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.deleteAddress(addressId);
      if (addressType == "Home") {
        await updateDeliveryAddress(addressData);
      }
      addressList.removeWhere((product) => product['id'] == addressId);
      LoadingIndicator.stopLoading();
    } catch (e) {
      print("Error deleting product: $e");
      LoadingIndicator.stopLoading();
    }
  }

  updateDeliveryAddress(Map<String, dynamic> addressData) async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      if (addressData["lat"].toString() != "0.0" &&
          addressData["lng"].toString() != "0.0") {
        Map<String, dynamic> updateProfile = {"current_address": addressData};

        await BaseController.firebaseAuth.updateUserData(
          updateProfile: updateProfile,
          logInUserType: BaseController.storageService.getLogInType(),
          userId: BaseController.firebaseAuth.getUid(),
        );
        getAddressFromLatLng(
          LatLng(
            double.parse(addressData["lat"].toString()),
            double.parse(addressData["lng"].toString()),
          ),
        );
        Get.snackbar(
          "Success",
          "changed Delivery Address",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.successTextColor,
        );
      } else {
        Get.snackbar(
          "Error",
          "please select location On Map",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.successTextColor,
        );
      }
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void postAddress() async {
    if (addressTitle.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Address title  cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    if (selectedIndex.value == 2 && description.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Description is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      return;
    }

    Map<String, dynamic> addressData = {
      "address": address.value ?? "",
      "address_type":
          selectedIndex.value == 0
              ? "Home"
              : selectedIndex.value == 1
              ? "Work"
              : "other" ?? "",
      "address_title": addressTitle.text ?? "",
      "street": street.text,
      "neighborhood": neighborhood.text,
      "houseNumber": houseNumber.text,
      "lng": currentLocation.value?.longitude ?? 0.0,
      "lat": currentLocation.value?.latitude ?? 0.0,
      "description": description.text ?? "",
    };

    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.addAddressForCustomer(addressData);
      if (addressData["address_type"] == "Home") {
        updateDeliveryAddress(addressData);
      }

      Get.snackbar(
        "Success",
        "Address added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );
      getAddressList();
      clearFields();
      isAddingNewAddress.value = false;
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

  void updateFields(Map<String, dynamic> addressItem) {
    if (addressItem.isEmpty) return;

    addressId.value = addressItem["id"] ?? "";
    addressTitle.text = addressItem["address_title"] ?? "";
    description.text = addressItem["description"] ?? "";
    addressType = addressItem["address_type"] ?? "Other";
    selectedIndex.value =
        addressItem["address_type"] == "Home"
            ? 0
            : addressItem["address_type"] == "Work"
            ? 1
            : 2;

    double lat = addressItem["lat"] ?? 0.0;
    double lng = addressItem["lng"] ?? 0.0;
    LatLng newLocation = LatLng(lat, lng);

    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId("current_location"),
        position: newLocation,
        infoWindow: InfoWindow(
          title: addressItem["address_title"] ?? "Location",
        ),
      ),
    );
    currentLocation.value = newLocation;

    if (mapController != null) {
      mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 15));
    } else {
      print("mapController is not initialized yet.");
    }

    isAddingNewAddress.value = true;
  }

  void updateAddress() async {
    try {
      // Set default addressId to Home if empty
      if (addressId.value.isEmpty) {
        for (var element in addressList) {
          if (element["address_type"] == "Home") {
            addressId.value = element["id"];
            log('Selected address ID: ${element["id"]}');
            break;
          }
        }
      }

      // Validate form fields
      if (selectedIndex.value == 2) {
        if (addressTitle.text.trim().isEmpty) {
          Get.snackbar(
            "Validation Error",
            "Address title cannot be empty",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          return;
        }

        if (description.text.trim().isEmpty) {
          Get.snackbar(
            "Validation Error",
            "Description is required",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          return;
        }
      }

      // Prepare address data
      final addressType =
          selectedIndex.value == 0
              ? "Home"
              : selectedIndex.value == 1
              ? "Work"
              : "Other";

      final lat = currentLocation.value?.latitude ?? 0.0;
      final lng = currentLocation.value?.longitude ?? 0.0;

      if (lat == 0.0 && lng == 0.0) {
        Get.snackbar(
          "Error",
          "Please select location on the map",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
        return;
      }

      final Map<String, dynamic> addressData = {
        "address": address.value ?? "",
        "address_type": addressType,
        "address_title": addressTitle.text.trim(),
        "street": street.text.trim(),
        "neighborhood": neighborhood.text.trim(),
        "houseNumber": houseNumber.text.trim(),
        "lat": lat,
        "lng": lng,
        "description": description.text.trim(),
      };

      // Start loading
      LoadingIndicator.loadingWithBackgroundDisabled();

      // Update address in Firebase
      await BaseController.firebaseAuth.updateAddress(
        addressId.value,
        addressData,
      );

      if (addressType == "Home") {
        updateDeliveryAddress(addressData);
      }

      Get.snackbar(
        "Success",
        "Address updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );

      isAddingNewAddress.value = true;
      getAddressList();
      clearFields();
      isAddingNewAddress.value = false;

      Get.back();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update address: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void clearFields() {
    addressTitle.text = "";
    description.text = "";
    addressType = "";
    addressId.value = "";
    currentLocation.value = null;
  }

  Future<void> getCurrentLocation() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled("Fetching Location");

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        LoadingIndicator.stopLoading();
        Get.snackbar("Error", "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          LoadingIndicator.stopLoading();
          Get.snackbar("Error", "Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        LoadingIndicator.stopLoading();

        Get.defaultDialog(
          title: "Permission Required",
          middleText:
              "Location permissions are permanently denied. Please enable them in settings.",
          textConfirm: "Open Settings",
          textCancel: "Cancel",
          confirmTextColor: Colors.white,
          onConfirm: () async {
            Get.back();

            await openAppSettings();
          },
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng newLocation = LatLng(position.latitude, position.longitude);
      updateMarkerPosition(newLocation);

      LoadingIndicator.stopLoading();

      mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 15));
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar("Error", "Failed to get location.");
      print("Location error: $e");
    }
  }

  void updateMarkerPosition(LatLng newLocation) {
    currentLocation.value = newLocation;
    getAddressFromLatLng(newLocation);

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("current_location"),
        position: newLocation,
        infoWindow: const InfoWindow(title: "Your Location"),
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          updateMarkerPosition(newPosition);
        },
      ),
    );
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
        street.text = '${place.street}';
        neighborhood.text = '${place.locality}';
      }
    } catch (e) {
      print("Error getting address: $e");
      address.value = "Unknown location";
    }
  }

  void onMapTap(LatLng position) {
    currentLocation.value = position;

    LatLng newLocation = LatLng(position.latitude, position.longitude);
    updateMarkerPosition(newLocation);

    LoadingIndicator.stopLoading();
    mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLocation, 15));

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("selected_location"),
        position: position,
        infoWindow: const InfoWindow(title: "Selected Location"),
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          onMapTap(newPosition);
        },
      ),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }
}
