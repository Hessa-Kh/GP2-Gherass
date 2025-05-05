import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/styles.dart';
import '../../../widgets/loader.dart';

class ProductController extends BaseController {
  RxInt categorySelectedValue = 0.obs;
  RxInt selectedStars = 0.obs;
  RxInt eventSectionValue = 2.obs;
  RxInt productQuantity = 0.obs;
  RxString logInType = "".obs;
  final TextEditingController commentController = TextEditingController();
  var farmerProducts = <Map<String, dynamic>>[].obs;
  var fruits = <Map<String, dynamic>>[].obs;
  var vegetables = <Map<String, dynamic>>[].obs;
  var others = <Map<String, dynamic>>[].obs;
  var categoryList = ["All products", "Fruits", "Vegetables", "Others"];
  var farmerEvents = <Map<String, dynamic>>[].obs;
  var bookedEvents = <Map<String, dynamic>>[].obs;
  var farmerEventItem = <Map<String, dynamic>>[].obs;
  var farmerRatings = [].obs;
  RxString farmerId = "".obs;
  RxString farmerName = "".obs;
  RxString farmRating = "".obs;
  RxString accountType = "".obs;
  var farmData = {};
  var selectedProduct = {}.obs;

  RxList sectionList = ["Ratings", "Events", "Products"].obs;

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      try {
        farmerId.value = Get.arguments != null ? Get.arguments[0] : {};
        farmData = Get.arguments != null ? Get.arguments[1]["farmDetails"] : {};
        farmerName.value = farmData["farmName"].toString();
        if (farmData["farm_ratings"] != null) {
          farmRating.value = farmData["farm_ratings"].toString();
        } else {
          farmRating.value = "0.0";
        }
        selectedProduct.assignAll(Get.arguments[1]);
      } catch (e) {
        farmData = Get.arguments != null ? Get.arguments[1] : {};
        farmerName.value = farmData["farmName"].toString();
        if (farmData["farm_ratings"] != null) {
          farmRating.value = farmData["farm_ratings"].toString();
        } else {
          farmRating.value = "0.0";
        }
      }
      selectedProduct.assignAll(Get.arguments[1]);
    }

    getFarmerProducts();
    getEventList();
    getBookedEventsList();
    getFarmerRatings();
    logInType.value = BaseController.storageService.getLogInType();
  }

  void setSelectedProduct(Map<String, dynamic> product) async {
    selectedProduct.assignAll(product);
  }

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    DateFormat outputFormat = DateFormat("dd MMM h:mm a");
    DateTime customDate = dateTime;
    return outputFormat.format(customDate);
  }

  void getEventList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      await BaseController.firebaseAuth.removeExpiredDoc(
        "events",
        "start_date",
        formatDateTime(DateTime.now().toString()),
      );
      final response = await BaseController.firebaseAuth.fetchFarmerEvents(
        farmerId.value,
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

  bool isEventBooked(Map<String, dynamic> eventData) {
    return bookedEvents.any((event) => event['id'] == eventData['id']);
  }

  void getBookedEventsList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchBookedEvents(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        bookedEvents.assignAll(response.cast<Map<String, dynamic>>());
      }
      print(bookedEvents);
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void openInGoogleMaps() async {
    var lat = farmerEventItem.first["lat"];
    var lng = farmerEventItem.first["lng"];
    if (lat != null && lng != null) {
      final url = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
      );
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch Google Maps';
      }
    }
  }

  void bookEvents(BuildContext context, farmName) async {
    Map<String, dynamic> eventData = farmerEventItem.first;
    eventData["farmName"] = farmName;
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      int remainingTickets =
          int.tryParse(eventData["remaining_tickets"].toString()) ?? 0;
      eventData["remaining_ticket"] = remainingTickets.toString();

      if (remainingTickets <= 0) {
        Get.snackbar(
          "Sold Out",
          "No more tickets available for this event.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        return;
      }
      await BaseController.firebaseAuth.updateEventTicketCount(
        eventData["id"],
        remainingTickets - 1,
        farmerID: farmerId.value,
      );
      await BaseController.firebaseAuth.addToBookEvents(eventData);
      getBookedEventsList();
      getEventList();
      showDialog(
        context: context,
        builder:
            (BuildContext context) => Dialog(
              insetPadding: EdgeInsets.all(35),
              child: SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    "The event has been successfully booked.",
                    style: Styles.boldTextView(24, AppTheme.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
      );
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

  void filterProductsByCategory() {
    String selectedCategory = categoryList[categorySelectedValue.value];
    if (selectedCategory == "All products") {
      farmerProducts.assignAll([...fruits, ...vegetables, ...others]);
    } else if (selectedCategory == "Fruits") {
      farmerProducts.assignAll(fruits);
    } else if (selectedCategory == "Vegetables") {
      farmerProducts.assignAll(vegetables);
    } else if (selectedCategory == "Others") {
      farmerProducts.assignAll(others);
    }
  }

  void getFarmerProducts() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      if (farmerId.value.isEmpty) {
        return;
      }

      await getAccountType();

      await BaseController.firebaseAuth.removeExpiredFields(
        "products",
        "discount_end_date",
        DateFormat("yyyy-MM-dd").format(DateTime.now()),
      );

      final response = await BaseController.firebaseAuth.fetchFarmerProducts(
        farmerId.value,
      );

      if (response != null) {
        final filteredResponse =
            response.where((product) {
              final visibility = product['visibility'];
              final isHidden = product['isHidden'] ?? false;

              // ✅ Skip product if it's hidden
              if (isHidden == true) return false;

              // ✅ Visibility filter
              if (visibility == null) return false;

              final isVisible =
                  visibility == accountType.value ||
                  visibility == 'Both' ||
                  accountType.value == 'Both';

              return isVisible;
            }).toList();

        fruits.assignAll(
          filteredResponse
              .where(
                (p) =>
                    p['category']?.toString().trim().toLowerCase() == 'fruits',
              )
              .toList(),
        );

        vegetables.assignAll(
          filteredResponse
              .where(
                (p) =>
                    p['category']?.toString().trim().toLowerCase() ==
                    'vegetables',
              )
              .toList(),
        );

        others.assignAll(
          filteredResponse
              .where(
                (p) =>
                    p['category']?.toString().trim().toLowerCase() == 'others',
              )
              .toList(),
        );

        farmerProducts.assignAll([...fruits, ...vegetables, ...others]);
      }

      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    }
  }

  getFarmerRatings() async {
    final results = await BaseController.firebaseAuth.fetchFarmerRatings(
      farmerId.value,
    );
    if (results != null) {
      farmerRatings.value = results;
      RxDouble farmRating = 0.0.obs;
      for (var element in farmerRatings) {
        farmRating.value = farmRating.value + element["rating"];
      }
      if (farmRating.value != 0.0) {
        Map<String, dynamic> updateProfile = {
          "farm_ratings":
              double.parse(
                (farmRating.value / farmerRatings.length)
                    .toDouble()
                    .toStringAsFixed(1),
              ) ??
              0.0,
        };
        await BaseController.firebaseAuth.updateUserData(
          updateProfile: updateProfile,
          logInUserType: "farmer",
          userId: farmerId.value,
        );
      } else {
        Map<String, dynamic> updateProfile = {"farm_ratings": 0.0};
        await BaseController.firebaseAuth.updateUserData(
          updateProfile: updateProfile,
          logInUserType: "farmer",
          userId: farmerId.value,
        );
      }
      fetchFarmDetails();
    }
  }

  fetchFarmDetails() async {
    final results = await BaseController.firebaseAuth.fetchDetailsById(
      "farmer",
      farmerId.value,
    );
    if (results != null) {
      farmData = results;
      farmerName.value = results["farmName"].toString();
      if (results["farm_ratings"] != null) {
        farmRating.value = results["farm_ratings"].toString();
      } else {
        farmRating.value = "0.0";
      }
    }
  }

  postFarmerRatings() async {
    final data = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      logInType.value,
    );

    var userName = data?["username"] ?? "";

    var reviewData = {
      "reviewText": commentController.text,
      "rating": selectedStars.value.toDouble(),
      "name": userName,
    };

    await BaseController.firebaseAuth.postFarmerReview(
      farmerId.value,
      reviewData,
    );

    getFarmerRatings();
  }

  getAccountType() async {
    final data = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      BaseController.storageService.getLogInType(),
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
