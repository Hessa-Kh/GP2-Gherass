import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:intl/intl.dart';

import '../../../helper/notification.dart';
import '../../../util/constants.dart';
import '../../../widgets/loader.dart';

class OrdersController extends BaseController {
  RxString pageName = "".obs;
  RxString orderStatusSelectedName = "".obs;
  RxString logInType = "".obs;
  RxString customerAddress = "".obs;
  var farmerProducts = <Map<String, dynamic>>[].obs;
  var ordersList = <Map<String, dynamic>>[].obs;
  var ordersDetailsList = <Map<String, dynamic>>[].obs;
  var selectedOrder = <String, dynamic>{}.obs;
  var farmerInfo = <String, dynamic>{}.obs;
  var customerInfo = <String, dynamic>{}.obs;

  RxList orderStatusList =
      [
        "The order has been received",
        "On the Way",
        "The order has been delivered",
      ].obs;
  List<Map<String, dynamic>>? allOrders = [];
  var showOrders = false.obs;

  Map<String, dynamic> customerDetailForDetail = {};

  var showAcceptBtn = false.obs;
  var showRejectBtn = false.obs;

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  void getOrders() {
    logInType.value = BaseController.storageService.getLogInType();
    if (logInType.value == "driver") {
      getOrdersList("driverId", "");
      fetchDriverOrders();
    } else {
      getOrdersList("farmerId", BaseController.firebaseAuth.getUid());
    }
  }

  getFarmerProducts(String farmerId) async {
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

  RxString getProductImage(productId) {
    RxString imageUrl = "".obs;
    for (var element in farmerProducts) {
      if (element["id"] == productId) {
        imageUrl.value = element["image"];
        break;
      }
    }
    return imageUrl;
  }

  void getOrdersList(String fieldName, String uId) async {
    allOrders?.clear();
    ordersList.clear();
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchOrders(
        fieldName,
        uId,
      );
      if (response != null) {
        allOrders?.assignAll(response.cast<Map<String, dynamic>>());
        if (logInType.value == "driver" && pageName.value == "") {
          if (allOrders!.isNotEmpty) {
            for (var element in allOrders!) {
              if (Constants.orderStatusListOfFarmer[1] == element["status"]) {
                ordersList.add(element);
              }
            }
          }
        } else {
          ordersList.assignAll(allOrders ?? []);
        }
      }
    } catch (e) {
      print("Error in getOrdersList: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  var currentOrders = <Map<String, dynamic>>[].obs;
  var pastOrders = <Map<String, dynamic>>[].obs;
  var driverOrdersHome = <Map<String, dynamic>>[];
  var showCurrentOrders = false.obs;
  var showPastOrders = false.obs;

  fetchDriverOrders() async {
    try {
      print("[DriverOrders] Start fetching orders for driver");
      LoadingIndicator.loadingWithBackgroundDisabled();

      // Clear existing data
      pastOrders.clear();
      currentOrders.clear();
       pageName.value ="";
      final driverId = BaseController.firebaseAuth.getUid();
      print("[DriverOrders] Driver UID: $driverId");

      // Fetch orders
      driverOrdersHome =
          (await BaseController.firebaseAuth.fetchOrdersWithDriverId(BaseController.firebaseAuth.getUid(),)) ??
              [];

      print("[DriverOrders] Total fetched orders: ${driverOrdersHome.length}");

      for (var order in driverOrdersHome) {
        print(
          "[DriverOrders] Order ID: ${order["orderID"]}, Status: ${order["status"]}",
        );

        if (order["status"] == "Successfully Delivered") {
          pastOrders.add(order);
        } else {
          currentOrders.add(order);
        }
      }

      print("[DriverOrders] Current Orders: ${currentOrders.length}");
      print("[DriverOrders] Past Orders: ${pastOrders.length}");

      showCurrentOrders.value = currentOrders.isNotEmpty;
      showPastOrders.value = pastOrders.isNotEmpty;

      LoadingIndicator.stopLoading();
      print("[DriverOrders] Fetch complete");
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("[DriverOrders] Error fetching driver orders: $e");
    }
  }

  navigateToDetailsPage(selectedOrderData) {
    print("🔁 Navigating to Order Details Page");

    // Step 1: Update page name
    pageName.value = "detailPage";
    print("📄 Page name set to: ${pageName.value}");

    // Step 2: Store selected order
    selectedOrder.value = selectedOrderData;
    print("✅ Selected Order set: ${jsonEncode(selectedOrderData.toString())}");

    // Step 3: Get products from farmer
    final farmerId = selectedOrderData["farmerId"].toString();
    print("👨‍🌾 Fetching farmer products for ID: $farmerId");
    getFarmerProducts(farmerId);

    // Step 4: Extract order details list
    try {
      ordersDetailsList.assignAll(
        selectedOrderData["orderDetails"].cast<Map<String, dynamic>>(),
      );
      print("📦 Order details loaded: ${ordersDetailsList.length} items");
    } catch (e) {
      print("❌ Error parsing orderDetails: $e");
    }

    // Step 5: Fetch related customer/farmer data
    getDetailData(farmerId);
    print("📊 getDetailData() called");

    // Step 6: Determine accept/reject logic
    sortDriverFarmerAcceptReject(selectedOrder);
    print("🧠 sortDriverFarmerAcceptReject() called");

    // Step 7: Stop any loading spinner
    LoadingIndicator.stopLoading();
    print("⏹️ LoadingIndicator stopped");
  }

  void sortDriverFarmerAcceptReject(
    RxMap<String, dynamic> selectedOrder,
  ) async {
    if (selectedOrder["isRejected"] == true) {
      showRejectBtn.value = false;
      showAcceptBtn.value = false;
      if (selectedOrder["isRejected"] == true) {
        selectedOrder["status"] = "Order Rejected";
      }
      return;
    }

    if (logInType.value == "driver") {
      showAcceptBtn.value =
          Constants.orderStatusListOfFarmer.last == selectedOrder["status"];
      showRejectBtn.value = false;
    } else if (logInType.value == "farmer") {
      showAcceptBtn.value =
          Constants.orderStatusListOfFarmer.first == selectedOrder["status"];
      showRejectBtn.value =
          Constants.orderStatusListOfFarmer.first == selectedOrder["status"];
    }
  }

  void sortDriverOrders() async {
    if (allOrders!.isNotEmpty) {
      for (var element in allOrders!) {
        if (Constants.orderStatusListOfDriver[1] == element["status"]) {
          ordersList.add(element);
        }
      }
    }
  }

  void getDetailData(farmerId) async {
    try {
      print("🔍 getDetailData() started");
      LoadingIndicator.loadingWithBackgroundDisabled();

      // Fetch farmer details
      print("📡 Fetching farmer info for ID: ${farmerId}");
      final farmerDetail = await BaseController.firebaseAuth
          .getCurrentUserInfoById(farmerId, "farmer");

      // Fetch customer details
      print("📡 Fetching customer info for ID: ${selectedOrder["customerId"]}");
      final customerDetail = await BaseController.firebaseAuth
          .getCurrentUserInfoById(selectedOrder["customerId"], "customer");

      // Set farmer info if available
      if (farmerDetail != null) {
        farmerInfo.value = farmerDetail;
        print("✅ Farmer info set: ${jsonEncode(farmerDetail)}");
      } else {
        print("⚠️ Farmer detail is null");
      }

      // Set customer info and address if available
      if (customerDetail != null) {
        customerInfo.value = customerDetail;
        final address = customerInfo["current_address"]?["address"] ?? "";
        customerAddress.value = address;
        print("✅ Customer info set: ${jsonEncode(customerDetail)}");
        print("🏠 Customer address: $address");
      } else {
        print("⚠️ Customer detail is null");
      }

      LoadingIndicator.stopLoading();
      print("✅ getDetailData() completed");
    } catch (e, stacktrace) {
      LoadingIndicator.stopLoading();
      print("❌ Error in getDetailData(): $e");
      print("🧵 Stacktrace: $stacktrace");
    }
  }

  String formatDateTime(String dateTimeString) {
    DateFormat inputFormat = DateFormat("dd-MM-yyyy");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    DateFormat outputFormat = DateFormat("dd MMM");
    DateTime customDate = dateTime;
    return outputFormat.format(customDate);
  }

  List<String> covertDateFormat(date) {
    if (date is String) {
      var timestamp = DateTime.parse(date);
      DateTime dateTime = timestamp;
      DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime originalDate = inputFormat.parse(dateTime.toString());
      DateFormat outputFormat = DateFormat("dd MMM yyyy");
      DateFormat outputFormatTime = DateFormat("hh:mm a");
      String formattedNewDate = outputFormat.format(originalDate);
      String formattedNewTime = outputFormatTime.format(originalDate);
      return [
        formattedNewDate.toString() ?? "",
        formattedNewTime.toString() ?? "",
      ];
    } else {
      Timestamp timestamp = date;
      DateTime dateTime = timestamp.toDate();
      DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      DateTime originalDate = inputFormat.parse(dateTime.toString());
      DateFormat outputFormat = DateFormat("dd MMM yyyy");
      DateFormat outputFormatTime = DateFormat("hh:mm a");
      String formattedNewDate = outputFormat.format(originalDate);
      String formattedNewTime = outputFormatTime.format(originalDate);
      return [
        formattedNewDate.toString() ?? "",
        formattedNewTime.toString() ?? "",
      ];
    }
  }

  Future<void> acceptBtnClick(String orderStatus, bool isDriver) async {
    await BaseController.firebaseAuth.updateOrderStatus(
      selectedOrder["orderID"],
      orderStatus,
      isDriver,
    );
    showAcceptBtn.value = false;
    showRejectBtn.value = false;
    if (logInType.value == "driver") {
      getOrdersList("driverId", "");
      fetchFcmTokenById(selectedOrder['customerId'], selectedOrder, "accept");
    } else {
      getOrdersList("farmerId", BaseController.firebaseAuth.getUid());
      fetchFcmTokenById(selectedOrder['customerId'], selectedOrder, "accept");
    }
  }

  Future<void> rejectBtnClick() async {
    await BaseController.firebaseAuth.rejectOrder(selectedOrder["orderID"]);
    showAcceptBtn.value = false;
    showRejectBtn.value = false;
    if (logInType.value == "driver") {
      getOrdersList("driverId", "");
      fetchFcmTokenById(selectedOrder['customerId'], selectedOrder, "reject");
    } else {
      getOrdersList("farmerId", BaseController.firebaseAuth.getUid());
      fetchFcmTokenById(selectedOrder['customerId'], selectedOrder, "reject");
    }
  }

  void fetchFcmTokenById(
    String userId,
    Map<String, dynamic> data,
    String action,
  ) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchDetailsById(
        'customer',
        userId,
      );
      if (response != null) {
        String fcmToken = response['fcmToken'];
        final firebaseMessaging = FCM();

        String title = "Order Update";
        String body;

        if (logInType.value == "driver") {
          body =
              action == "accept"
                  ? "Driver has accepted your order (ID: ${data['orderID']})"
                  : "Driver has rejected your order (ID: ${data['orderID']})";
        } else {
          body =
              action == "accept"
                  ? "Farmer has accepted your order (ID: ${data['orderID']})"
                  : "Farmer has rejected your order (ID: ${data['orderID']})";
        }

        firebaseMessaging.sendFcm(fcmToken, title, body, {
          "orderID": data['orderID'],
        });
        LoadingIndicator.stopLoading();
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
}
