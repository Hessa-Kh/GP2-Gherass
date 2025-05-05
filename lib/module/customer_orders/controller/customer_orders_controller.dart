import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../widgets/loader.dart';
import '../view/customer_order_details_view.dart';

class CustomerOrdersController extends BaseController {
  var customerOrderList = <Map<String, dynamic>>[].obs;
  var orderedProductList = <Map<String, dynamic>>[].obs;
  var customerList = <Map<String, dynamic>>[].obs;
  var selectedOrder = <String, dynamic>{}.obs;
  var driverList = <Map<String, dynamic>>[].obs;
  var farmList = <Map<String, dynamic>>[].obs;
  var farmerProducts = <Map<String, dynamic>>[].obs;
  final Map<String, Color> statusColors = {
    "delivery": Colors.yellow[100]!,
    "pending": Colors.orange[100]!,
    "completed": Colors.green[100]!,
    "cancelled": Colors.red[100]!,
    "Order Processing": Colors.lightBlue[100]!,
  };

  @override
  void onInit() {
    super.onInit();
    getCustomerOrderList();
  }

  void setSelectedOrder(Map<String, dynamic> order, int index) {
    selectedOrder.value = order;
    print(">> selectedOrder.value$selectedOrder");
    getFarmerProducts(order["farmerId"].toString());
    orderedProductList.clear();
    orderedProductList.assignAll(
      customerOrderList[index]["orderDetails"].cast<Map<String, dynamic>>(),
    );
  }
  getFarmerProducts(farmerId) async {
    try {
      final response = await BaseController.firebaseAuth.fetchFarmerProducts(
        farmerId,
      );
      if (response != null) {
        farmerProducts.assignAll(response);
      }
    } catch (e) {
      LoadingIndicator.stopLoading();
    }
  }
  RxString getProductImage(productId){
    RxString imageUrl="".obs;
    for (var element in farmerProducts) {
      if(element["id"]==productId){
        imageUrl.value = element["image"];
        break;
      }
    }
    return imageUrl;
  }
  navigateToDetail(ordersData) {
    print(">> navigateToDetail selectedOrder.value  $ordersData");
    getDetailsById("farmer", ordersData["farmerId"]);
    getDetailsById("driver", ordersData["driverId"]);
    getDetailsById("customer", ordersData["customerId"]);
    orderedProductList.clear();
    orderedProductList.assignAll(
      ordersData["orderDetails"].cast<Map<String, dynamic>>(),
    );
    Get.to(CustomerOrderDetailsView());
  }

  Future<void> getCustomerOrderList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchOrders(
        "customerId",
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        customerOrderList.assignAll(response.cast<Map<String, dynamic>>());
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void getDetailsById(String collection, String userId) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchDetailsById(
        collection,
        userId,
      );
      if (response != null) {
        if (collection == "farmer") {
          farmList.clear();
          farmList.add(response);
        } else if (collection == "customer") {
          customerList.clear();
          customerList.add(response);
        } else if (collection == "driver") {
          driverList.clear();
          driverList.add(response);
        }
        LoadingIndicator.stopLoading();
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error fetching details from $collection: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
}
