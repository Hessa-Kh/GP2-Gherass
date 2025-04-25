import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:gherass/apiservice/dio_api.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/util/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../theme/app_theme.dart';
import '../../util/image_util.dart';
import '../../widgets/loader.dart';
import '../../widgets/location_picker.dart';

class HomeViewController extends BaseController {
  // final formKey = GlobalKey<FormBuilderState>();
  // final forgotPswdFormKey = GlobalKey<FormBuilderState>();
  var tabController = PersistentTabController(initialIndex: 0);
  var loginUser = "".obs;
  RxString logInType = "".obs;
  var appVersion = "".obs;
  var hasShownDialog = false.obs;

  var obscureText = true.obs;
  RxString userName = "".obs;
  RxString phoneNumber = "".obs;
  RxString farmName = "".obs;
  RxDouble farmRatings = 0.0.obs;
  RxString location = "".obs;
  RxString farmLogo = "".obs;
  RxList farmsList = [].obs;
  RxList productList = [].obs;
  RxList filteredFarmersList = [].obs;
  RxList farmerIdList = [].obs;
  RxList sortedDistancesList = [].obs;
  RxList searchedFarmsList = [].obs;
  RxList searchedProductList = [].obs;
  RxList filteredProducts = <dynamic>[].obs;
  var categoryList = <Map<String, dynamic>>[].obs;
  final selectedLatLng = Rxn<LatLng>();
  var address = ''.obs;
  var locationController = TextEditingController();
  var customerList = <Map<String, dynamic>>[].obs;
  List<double> distancesList = [];
  double? customerLat;
  double? customerLng;
  RxString accountType = "".obs;
  RxBool isFarmListVisible = true.obs;
  RxString selectedCategory = "".obs;

  // used for driver
  List<Map<String, dynamic>> driverOrdersHome =
      []; // this contains all the current and past orders
  List<Map<String, dynamic>> currentOrders =
      []; // This contains all current orders
  List<Map<String, dynamic>> pastOrders = []; // this contains all past orders
  var showCurrentOrders = false.obs;
  var showPastOrders = false.obs;
  var usernameError = ''.obs;
  var passwordError = ''.obs;

  var storage = Get.find<StorageService>();

  DioApi api = DioApi();

  var emailTextfield = TextEditingController();
  var passwordTextfield = TextEditingController();
  var forgotPassword = TextEditingController();
  var searchField = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    logInType.value = BaseController.storageService.getLogInType();
    getDetailsById();
    getData();
  }

  bool validate() {
    bool isValid = true;

    if (emailTextfield.text.isEmpty) {
      usernameError.value = 'please enter valid user name'.tr;
      isValid = false;
    } else {
      usernameError.value = '';
    }

    if (passwordTextfield.text.isEmpty) {
      passwordError.value = 'Please enter password';
      isValid = false;
    } else {
      passwordError.value = '';
    }
    return isValid;
  }

  getData() async {
  try {
    LoadingIndicator.loadingWithBackgroundDisabled();
    numberFormating();
    isFarmListVisible.value = false;

    final results = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      logInType.value,
    );
    farmRatings.value =
        double.tryParse(results!["farm_ratings"].toString()) ?? 0.0;
    userName.value = results["username"] ?? "";
    phoneNumber.value = results["phoneNumber"] ?? "";
    farmName.value = results["farmName"] ?? "";
    location.value = results["farmLocation"] ?? "";
    farmLogo.value = results["farm_logo"] ?? "";

    final categoryListResponse =
        await BaseController.firebaseAuth.getCategoryList();
    var allProducts = {"name": "All Products"};
    if (categoryListResponse != null) {
      categoryList.assignAll(
        categoryListResponse.cast<Map<String, dynamic>>(),
      );
      categoryList.add(allProducts);
    }

    final farmListResponse =
        await BaseController.firebaseAuth.getFarmsList();
    farmsList.addAll(farmListResponse[0]);
    farmerIdList.addAll(farmListResponse[1]);

    if (logInType.value == "driver") {
      await fetchDriverOrders();
    } else {
      await fetchAndAttachProductsToFarms();
      filterFarmersByCategoryAndSortByDistance("All Products");
      calculateAllDistances();
    }

    fetchOrdeStatusList();
  } catch (e) {
    LoadingIndicator.stopLoading();
  } finally {
    LoadingIndicator.stopLoading();
  }
}


  Future<List<Map<String, dynamic>>> fetchAndAttachProductsToFarms() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    List<Map<String, dynamic>> allProducts = [];

    try {
      if (farmerIdList.isNotEmpty) {
        for (var farmer in farmsList) {
          try {
            final response = await BaseController.firebaseAuth
                .fetchFarmerProducts(farmer["farmerId"].toString());

            if (response != null && response.isNotEmpty) {
              for (var farm in farmsList) {
                if (farmer["farmerId"].toString() ==
                    farm["farmerId"].toString()) {
                  Map<String, dynamic> farmDetails = Map<String, dynamic>.from(
                    farm,
                  );
                  farmDetails.remove("products");

                  for (var product in response) {
                    product["farmDetails"] = farmDetails;
                  }

                  farm["products"] = response;

                  break;
                }
              }

              allProducts.addAll(List<Map<String, dynamic>>.from(response));
            }
          } catch (e) {
            print(
              'Error fetching products for farmer $farmer["farmerId"].toString(): $e',
            );
          }
        }
      }

      productList.assignAll(allProducts);
    } catch (e) {
      print('Error in fetchAndAttachProductsToFarms: $e');
    } finally {
      LoadingIndicator.stopLoading();
    }

    return allProducts;
  }

  void filterProductsByVisibilityOnly() {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      isFarmListVisible.value = false;

      final visibleProducts =
          productList.where((product) {
            final visibility = product['visibility'];
            return visibility == accountType.value ||
                visibility == 'Both' ||
                accountType.value == 'Both';
          }).toList();

      filteredProducts.assignAll(visibleProducts);
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void filterFarmersByCategoryAndSortByDistance(String category) {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      sortedDistancesList.clear();

      final lowerCategory = category.trim().toLowerCase();
      final bool isAllCategory = lowerCategory == 'all products';
      final double startLat = customerLat ?? 0.0;
      final double startLng = customerLng ?? 0.0;

      final Map<String, Map<String, dynamic>> uniqueFarmersMap = {};

      for (var product in productList) {
        final productCategory =
            product['category']?.toString().trim().toLowerCase();

        final matchesCategory =
            isAllCategory || productCategory == lowerCategory;

        final visibility = product['visibility'];
        final isVisible =
            visibility == accountType.value ||
            visibility == 'Both' ||
            accountType.value == 'Both';

        if (matchesCategory && isVisible) {
          final farmDetails = product['farmDetails'];
          if (farmDetails != null && farmDetails is Map<String, dynamic>) {
            final farmerId = farmDetails['farmerId']?.toString();
            if (farmerId != null && !uniqueFarmersMap.containsKey(farmerId)) {
              final distance = calculateDistance(
                startLat,
                startLng,
                farmDetails["lat"] ?? 0.0,
                farmDetails["lng"] ?? 0.0,
              );
              final farmWithDistance = {...farmDetails, "distance": distance};
              uniqueFarmersMap[farmerId] = farmWithDistance;
            }
          }
        }
      }

      final sortedList =
          uniqueFarmersMap.values.toList()
            ..sort((a, b) => a["distance"].compareTo(b["distance"]));

      sortedDistancesList.assignAll(sortedList);
    } catch (e) {
      print("Error filtering farmers by category: $e");
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void getDistance() {
    try {
      sortedDistancesList.clear();

      final double startLat = customerLat ?? 0.0;
      final double startLng = customerLng ?? 0.0;

      for (var farm in farmsList) {
        if (farm is Map<String, dynamic>) {
          final double farmLat = farm["lat"] ?? 0.0;
          final double farmLng = farm["lng"] ?? 0.0;

          final double distance = calculateDistance(
            startLat,
            startLng,
            farmLat,
            farmLng,
          );

          final updatedFarm = {...farm, "distance": distance};
          sortedDistancesList.add(updatedFarm);
        }
      }

      sortedDistancesList.sort(
        (a, b) => a["distance"].compareTo(b["distance"]),
      );
    } catch (e) {
      print("Error in getDistance(): $e");
    }
  }

  fetchOrdeStatusList() async {
    try {
      final status = await BaseController.firebaseAuth.getOrderStatusFlowList(
        BaseController.firebaseAuth.getUid(),
      );
      if (status?["sellerStatus"] != null &&
          status?["sellerStatus"] is List<dynamic>) {
        Constants.orderStatusListOfFarmer.addAll(
          List<String>.from(status?["sellerStatus"]),
        );
      }

      if (status?["driverStatus"] != null &&
          status?["driverStatus"] is List<dynamic>) {
        Constants.orderStatusListOfDriver.addAll(
          List<String>.from(status?["driverStatus"]),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  fetchDriverOrders() async {
    pastOrders.clear();
    currentOrders.clear();
    driverOrdersHome =
        (await BaseController.firebaseAuth.fetchOrdersWithDriverId(
          BaseController.firebaseAuth.getUid(),
        )) ??
        [];
    if (driverOrdersHome.isNotEmpty) {
      for (var element in driverOrdersHome) {
        if (Constants.orderStatusListOfDriver.last == element["status"]) {
          pastOrders.add(element);
        } else if (Constants.orderStatusListOfDriver.contains(
          element["status"],
        )) {
          currentOrders.add(element);
        }
      }
    }
    showCurrentOrders.value = currentOrders.isNotEmpty;
    showPastOrders.value = pastOrders.isNotEmpty;
  }

  String getCategoryIcons(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case "dates":
        return ImageUtil.dates;
      case "fruits ":
        return ImageUtil.fruites;
      case "others":
        return ImageUtil.all_products;
      case "vegetables":
        return ImageUtil.vegetabels;
      case "all products":
        return ImageUtil.others;
      default:
        return ImageUtil.others;
    }
  }

  void searchData() {
    final query = searchField.text.trim().toLowerCase();

    searchedFarmsList.clear();
    searchedProductList.clear();

    if (query.isNotEmpty) {
      for (var farm in farmsList) {
        final farmName = (farm["farmName"] ?? "").toString().toLowerCase();
        if (farmName.contains(query)) {
          searchedFarmsList.add(farm);
        }
      }

      for (var product in productList) {
        final productName = (product["name"] ?? "").toString().toLowerCase();
        if (productName.contains(query)) {
          searchedProductList.add(product);
        }
      }
    }
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

  String formatDateTime(dynamic dateTime) {
    DateTime date;

    if (dateTime is Timestamp) {
      date = dateTime.toDate(); // Convert Firestore Timestamp to DateTime
    } else if (dateTime is int) {
      date = DateTime.fromMillisecondsSinceEpoch(dateTime * 1000);
    } else {
      throw ArgumentError("Invalid date type: ${dateTime.runtimeType}");
    }

    return DateFormat('dd MMMM yyyy hh:mm:ss a').format(date);
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
        locationController.text = address.value;
      }
    } catch (e) {
      print("Error getting address: $e");
      address.value = "Unknown location";
    }
  }

  Future<bool> saveLocation() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      if (selectedLatLng.value!.latitude.toString() != "0.0" &&
          selectedLatLng.value!.longitude.toString() != "0.0") {
        var addressData = {
          "address": address.value,
          "lat": selectedLatLng.value!.latitude,
          "lng": selectedLatLng.value!.longitude,
        };

        Map<String, dynamic> updateProfile = {"current_address": addressData};

        await BaseController.firebaseAuth.updateUserData(
          updateProfile: updateProfile,
          logInUserType: BaseController.storageService.getLogInType(),
          userId: BaseController.firebaseAuth.getUid(),
        );

        Get.snackbar(
          "Success",
          "Location updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.successBgColor,
        );

        return true;
      } else {
        Get.snackbar(
          "Error",
          "Please select a location on the map",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.errorTextColor,
        );
        return false;
      }
    } catch (e) {
      print("Error saving location: $e");
      Get.snackbar(
        "Error",
        "Failed to save location",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.errorTextColor,
      );
      return false;
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void getDetailsById() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchDetailsById(
        BaseController.storageService.getLogInType(),
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        customerList.clear();
        customerList.add(response);
        if (response['current_address'] != null) {
          customerLat = double.tryParse(
            response['current_address']['lat'].toString(),
          );
          customerLng = double.tryParse(
            response['current_address']['lng'].toString(),
          );
        } else {
          customerLat = double.tryParse(response['lat'].toString());
          customerLng = double.tryParse(response['lng'].toString());
        }
        print("Customer Lat: $customerLat, Lng: $customerLng");
        LoadingIndicator.stopLoading();
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error fetching details");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371;

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    final distance = earthRadius * c;
    return distance; // Distance in kilometers
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  void calculateAllDistances() {
    double startLat = customerLat ?? 0.0;
    double startLng = customerLng ?? 0.0;

    var currentList =
        searchedFarmsList.isNotEmpty ? searchedFarmsList : farmsList;

    distancesList =
        currentList.map((farm) {
          double farmLat =
              double.tryParse(farm['lat']?.toString() ?? '') ?? 0.0;
          double farmLng =
              double.tryParse(farm['lng']?.toString() ?? '') ?? 0.0;

          return calculateDistance(startLat, startLng, farmLat, farmLng);
        }).toList();
  }

  getAccountType() async {
    final data = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      logInType.value,
    );

    if (data?["accountType"] == "Personal account") {
      accountType.value = "Individuals";
    } else if (data?["accountType"] == "Business account") {
      accountType.value = "Orgnization";
    } else {
      accountType.value = data?["accountType"] ?? "";
    }
    print(' accountType.value:${accountType.value}');
  }
}
