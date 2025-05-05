import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gherass/util/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../helper/notification.dart';
import '../../../widgets/loader.dart';

class OrderDetailMapController extends BaseController {
  var selectedOrder = <String, dynamic>{}.obs;
  RxString selectedStatusName = "".obs;
  var orderId = '';
  RxBool showOrderStatusToggle = false.obs;
  var currentStatusIndex = 0.obs;
  var customerName = "".obs;

  GoogleMapController? mapController;
  var markers = <Marker>{}.obs;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void onInit() {
    super.onInit();
    selectedOrder.assignAll(Get.arguments[0]);
    orderId =selectedOrder["orderID"]??"";
    getOrdersList();
    getCustomerNameId(selectedOrder["customerId"]);
    currentStatusIndex.value = Constants.orderStatusListOfDriver.indexWhere(
      (element) => element == selectedOrder['status'],
    );
  }

  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {}
  }

  String covertDateFormatToDate(date) {
    Timestamp timestamp = date;
    DateTime dateTime = timestamp.toDate();
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime originalDate = inputFormat.parse(dateTime.toString());
    DateFormat outputFormat = DateFormat("dd MMM yyyy");
    String formattedNewDate = outputFormat.format(originalDate);
    return formattedNewDate.toString() ?? "";
  }

  String covertDateFormatToTime(date) {
    Timestamp timestamp = date;
    DateTime dateTime = timestamp.toDate();
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime originalDate = inputFormat.parse(dateTime.toString());
    DateFormat outputFormatTime = DateFormat("hh:mm a");
    String formattedNewTime = outputFormatTime.format(originalDate);
    return formattedNewTime.toString() ?? "";
  }

  updateDeliveryStatus(String status) async {
    await BaseController.firebaseAuth.updateOrderStatus(
      orderId,
      status,
      true,
    );
    var order = await BaseController.firebaseAuth.getOrderById(
      orderId,
    );
    selectedOrder.assignAll(order);
    selectedStatusName.value = selectedOrder["status"].toString();
    currentStatusIndex.value = Constants.orderStatusListOfDriver.indexWhere(
      (element) => element == selectedStatusName.value,
    );
    showOrderStatusToggle.value = false;
    showOrderStatusToggle.value = true;
  }

  void getOrdersList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final ordersData = await BaseController.firebaseAuth
          .fetchOrderDetailsById(orderId);

      if (ordersData != null && ordersData.isNotEmpty) {
        selectedOrder.assignAll(ordersData);
        selectedStatusName.value = selectedOrder["status"].toString();
        currentStatusIndex.value = Constants.orderStatusListOfDriver.indexWhere(
              (element) => element == selectedStatusName.value,
        );
        LatLng newLocation = LatLng(
          selectedOrder["delivery_address"]["lat"],
          selectedOrder["delivery_address"]["lng"],
        );
        markers.add(
          Marker(
            markerId: MarkerId("current_location"),
            position: newLocation,
            infoWindow: InfoWindow(title: "Location"),
          ),
        );
        LoadingIndicator.stopLoading();
      } else {
        LoadingIndicator.stopLoading();
      }
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error fetching order details: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  getCustomerNameId(String id) async {
    var data = await BaseController.firebaseAuth.getCurrentUserInfoById(
      id,
      "customer",
    );

    customerName.value = data?["username"];
  }

  void fetchFcmTokenByIdAndSendNotification(
    String userId,
    String status,
    String orderId,
  ) async {
    try {
      final response = await BaseController.firebaseAuth.fetchDetailsById(
        'customer',
        userId,
      );
      if (response != null) {
        String fcmToken = response['fcmToken'];
        final firebaseMessaging = FCM();
        firebaseMessaging.sendFcm(
          fcmToken,
          "Order Update",
          "Order ID : #$orderId \n $status",
          {"orderID": orderId},
        );
      }
    } catch (e) {
      print("Error :  $e");
    } finally {}
  }
}
