import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:intl/intl.dart'; // Import the intl package

import '../../../widgets/loader.dart';

class InventoryController extends BaseController {
  RxBool isShowprodList = false.obs;
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var farmerRatings = [].obs;
  var farmerProducts = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>>? allOrders = [];
  List<Map<String, dynamic>>? orderDetails = [];
  List<Map<String, dynamic>>? totalOrderDetails = [];
  RxString farmLogo = "".obs;
  RxString farmName = "".obs;
  RxDouble totalSaleAmount = 0.0.obs;
  RxDouble farmRatings = 0.0.obs;

  @override
  void onInit() {
    getFarmerRatings();
    getInventoryProducts();
    getOrdersList("farmerId", BaseController.firebaseAuth.getUid());
    super.onInit();
  }

  showMore() {
    getInventoryProducts();
    isShowprodList.value = !isShowprodList.value;
  }

  Future<void> getOrdersList(fieldName, String uId) async {
  try {
    LoadingIndicator.loadingWithBackgroundDisabled();
    final response = await BaseController.firebaseAuth.fetchOrders(fieldName, uId);
    if (response != null) {
      allOrders?.assignAll(response.cast<Map<String, dynamic>>());
      totalSaleAmount.value = 0.0; // Resetting total sale amount before recalculating

      allOrders?.forEach((element) {
        var value = double.tryParse(element["totalAmount"].toString());
        if (value != null) {
          value -= 15; // Subtract delivery price (15) from the total amount
          totalSaleAmount.value += value;
        }
      });

      print("All Orders: $allOrders"); // Debugging line
      print("Total Sale Amount: ${totalSaleAmount.value}"); // Debugging line
    }
    LoadingIndicator.stopLoading();
  } catch (e) {
    LoadingIndicator.stopLoading();
    print("Error fetching orders: $e"); // Debugging line
  } finally {
    LoadingIndicator.stopLoading();
  }
}


  String fetchTotalQuantity(productName) {
    RxInt totalSaleQuantity = 0.obs;
    orderDetails?.clear();
    allOrders?.forEach((element) {
      orderDetails?.assignAll(element["orderDetails"].cast<Map<String, dynamic>>());
      orderDetails?.forEach((orderValue) {
        if (productName == orderValue["name"]) {
          var value = int.tryParse(orderValue["qty"].toString());
          totalSaleQuantity.value = totalSaleQuantity.value + value!;
        }
      });
    });
    print("Total Sale Quantity for $productName: ${totalSaleQuantity.value}"); // Debugging line
    return totalSaleQuantity.value.toString() ?? "0";
  }

  Future<void> getFarmerRatings() async {
    try {
      final details = await BaseController.firebaseAuth.getCurrentUserInfoById(
        BaseController.firebaseAuth.getUid(),
        BaseController.storageService.getLogInType(),
      );
      farmLogo.value = details?["farm_logo"] ?? "";
      farmName.value = details?["username"] ?? "";

      final results = await BaseController.firebaseAuth.fetchFarmerRatings(
        BaseController.firebaseAuth.getUid(),
      );
      if (results != null) {
        farmerRatings.value = results;
        RxDouble farmRating = 0.0.obs;
        for (var element in farmerRatings) {
          farmRating.value = farmRating.value + element["rating"];
        }
        farmRatings.value = double.parse((farmRating.value / farmerRatings.length).toDouble().toStringAsFixed(1));
      }
    } catch (e) {
      print("Error fetching farmer ratings: $e"); // Debugging line
    }
  }

  String fetchRatingPercentage(rating) {
    RxString percentage = "".obs;
    if (farmerRatings.isNotEmpty) {
      List ratings = farmerRatings.where((element) => element["rating"] == rating).toList();
      percentage.value = ((ratings.length / farmerRatings.length) * 100).toStringAsFixed(0);
      print("Rating $rating Percentage: ${percentage.value}%"); // Debugging line
      return percentage.value;
    } else {
      return percentage.value = "0";
    }
  }

  Future<void> getInventoryProducts() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchFarmerProducts(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        farmerProducts.assignAll(response.cast<Map<String, dynamic>>());
        print("Farmer Products: $farmerProducts"); // Debugging line
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error fetching products: $e"); // Debugging line
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void deleteProduct(String productId) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.deleteFarmProduct(productId);
      farmerProducts.removeWhere((product) => product['id'] == productId);
      LoadingIndicator.stopLoading();
    } catch (e) {
      print("Error deleting product: $e"); // Debugging line
      LoadingIndicator.stopLoading();
    }
  }

  // Get total sales for a specific day of the week (Sun, Mon, etc)
double getSaleForDay(DateTime date) {
  double total = 0.0;

  // Iterate over orders and match deliveryDate with the last 7 days
  if (allOrders != null && allOrders!.isNotEmpty) {
    for (var order in allOrders!) {
      var deliveryDate = order["deliveryDate"];
      if (deliveryDate != null) {
        DateTime orderDate = _parseDate(deliveryDate);

        // If the order's delivery date matches the current date, calculate its sale
        if (orderDate.year == date.year && orderDate.month == date.month && orderDate.day == date.day) {
          double orderAmount = double.tryParse(order["totalAmount"].toString()) ?? 0.0;
          orderAmount -= 15; // Subtract delivery price (15) from the total amount
          total += orderAmount;
        }
      }
    }
  }

  return total;
}

// Helper method to check if the date is within the last 7 days including today
bool _isWithinLast7Days(DateTime today, DateTime date) {
  int differenceInDays = today.difference(date).inDays;
  return differenceInDays >= 0 && differenceInDays <= 6; // Checks if the date is within the last 7 days (including today)
}




// Get total sales for a specific month (1 to 12 for Jan to Dec)
double getSaleForMonth(int monthIndex) {
  double total = 0.0;

  if (allOrders != null && allOrders!.isNotEmpty) {
    for (var order in allOrders!) {
      var deliveryDate = order["deliveryDate"]; // Using deliveryDate instead of orderDate
      if (deliveryDate != null) {
        // Parse the deliveryDate into a DateTime object
        DateTime date = _parseDate(deliveryDate);

        // Debugging: Check parsed date and the resulting month
        print("Parsed Delivery Date: $date, Delivery Date: $deliveryDate");

        // Check if the order's delivery month matches the given monthIndex (months in DateTime are 1-based, so monthIndex+1)
        if (date.month == (monthIndex + 1)) {
          double orderAmount = double.tryParse(order["totalAmount"].toString()) ?? 0.0;
          orderAmount -= 15; // Subtract delivery price (15) from the total amount
          total += orderAmount;
        }
      }
    }
  }

  // Debugging: Print the total sales for the month
  print("Total sales for month ${monthIndex + 1} (after subtracting delivery price): $total");

  return total;
}


double getSaleForYear(int year) {
  double total = 0.0;

  if (allOrders != null && allOrders!.isNotEmpty) {
    for (var order in allOrders!) {
      var deliveryDate = order["deliveryDate"]; // Using deliveryDate instead of orderDate
      if (deliveryDate != null) {
        // Parse the deliveryDate into a DateTime object
        DateTime date = _parseDate(deliveryDate);

        // Debugging: Check parsed date and the resulting year
        print("Parsed Delivery Date: $date, Delivery Date: $deliveryDate");

        // Check if the order's delivery year matches the given year
        if (date.year == year) {
          double orderAmount = double.tryParse(order["totalAmount"].toString()) ?? 0.0;
          orderAmount -= 15; // Subtract delivery price (15) from the total amount
          total += orderAmount;
        }
      }
    }
  }

  // Debugging: Print the total sales for the year
  print("Total sales for year $year (after subtracting delivery price): $total");

  return total;
}




// Helper Functions for Date Comparison
bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
}

bool _isSameYear(DateTime date1, DateTime date2) {
  return date1.year == date2.year;
}

// Parse different types of orderDate (String or Timestamp or DateTime)
DateTime _parseDate(dynamic orderDate) {
  if (orderDate is String) {
    try {
      DateFormat format = DateFormat("dd-MM-yyyy");
      return format.parse(orderDate); // Parse the date string
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now(); // Return the current date if parsing fails
    }
  } else if (orderDate is DateTime) {
    return orderDate;
  } else if (orderDate is Map && orderDate.containsKey('_seconds')) {
    // If coming from Firestore timestamp
    return DateTime.fromMillisecondsSinceEpoch(orderDate['_seconds'] * 1000);
  } else {
    return DateTime.now();
  }
}

// Convert weekday number to string
String _getDayName(int weekday) {
  switch (weekday) {
    case DateTime.sunday:
      return 'Sun';
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    default:
      return '';
  }
}
}