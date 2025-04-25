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
    logInType.value = BaseController.storageService.getLogInType();
    if (logInType.value == "driver") {
      getOrdersList("driverId", "");
    } else {
      getOrdersList("farmerId", BaseController.firebaseAuth.getUid());
      print("farmer detail called");
    }
    super.onInit();
  }

  void getOrdersList(fieldName, String uId) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchOrders(
        fieldName,
        uId,
      );
      if (response != null) {
        allOrders?.assignAll(response.cast<Map<String, dynamic>>());

        if (logInType.value == "driver") {
          sortDriverOrders();
        } else {
          ordersList.assignAll(allOrders!);
        }
      }
      print(ordersList);
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  navigateToDetailsPage(selectedOrderData) {
    pageName.value = "detailPage";
    selectedOrder.value = selectedOrderData;
    ordersDetailsList.assignAll(
      selectedOrderData["orderDetails"].cast<Map<String, dynamic>>(),
    );
    log("selectedOrder>> ${selectedOrder.toString()}");
    getDetailData();
    sortDriverFarmerAcceptReject(selectedOrder);
    LoadingIndicator.stopLoading();
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
        if (Constants.orderStatusListOfFarmer.last == element["status"]) {
          ordersList.add(element);
        }
      }
    }
  }

  void getDetailData() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final farmerDetail = await BaseController.firebaseAuth
          .getCurrentUserInfoById(selectedOrder["farmerId"], "farmer");
      final customerDetail = await BaseController.firebaseAuth
          .getCurrentUserInfoById(selectedOrder["customerId"], "customer");
      if (farmerDetail != null) {
        farmerInfo.value = farmerDetail;
      }
      if (customerDetail != null) {
        customerInfo.value = customerDetail;
        customerAddress.value =
            customerInfo["current_address"]["address"] ?? "";
      }
      print(
        "customer and farmer detail  " +
            selectedOrder["farmerId"] +
            "  " +
            selectedOrder["customerId"],
      );
      print(farmerDetail.toString());
      print(customerDetail.toString());
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
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
    if(date is String){
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
    }else{
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

  void fetchFcmTokenById(String userId, Map<String, dynamic> data, String action) async {
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
          body = action == "accept"
              ? "Driver has accepted your order (ID: ${data['orderID']})"
              : "Driver has rejected your order (ID: ${data['orderID']})";
        } else {
          body = action == "accept"
              ? "Farmer has accepted your order (ID: ${data['orderID']})"
              : "Farmer has rejected your order (ID: ${data['orderID']})";
        }

        firebaseMessaging.sendFcm(
          fcmToken,
          title,
          body,
          {"orderID": data['orderID']},
        );
        LoadingIndicator.stopLoading();
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error :  $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
}
