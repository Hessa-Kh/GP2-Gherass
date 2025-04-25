import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gherass/util/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../helper/notification.dart';

class OrderDetailMapController extends BaseController{
  var selectedOrder = <String, dynamic>{}.obs;
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
    // TODO: implement onInit
    super.onInit();
    selectedOrder.assignAll(Get.arguments[0]);
    getCustomerNameId(selectedOrder["customerId"]);
    currentStatusIndex.value = Constants.orderStatusListOfDriver.indexWhere((element) => element==selectedOrder['status'],);
    LatLng newLocation = LatLng(selectedOrder["delivery_address"]["lat"],selectedOrder["delivery_address"]["lng"]);
    markers.add(
      Marker(
        markerId: MarkerId("current_location"),
        position: newLocation,
        infoWindow: InfoWindow(
          title: "Location",
        ),
      ),
    );
  }

  openDialPad(String phoneNumber) async {
    Uri url = Uri(scheme: "tel", path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }

  String covertDateFormatToDate(date){
    Timestamp timestamp = date;
    DateTime dateTime = timestamp.toDate();
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime originalDate = inputFormat.parse(dateTime.toString());
    DateFormat outputFormat = DateFormat("dd MMM yyyy");
    String formattedNewDate = outputFormat.format(originalDate);
    return formattedNewDate.toString()??"";
  }

 String covertDateFormatToTime(date){
    Timestamp timestamp = date;
    DateTime dateTime = timestamp.toDate();
    DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime originalDate = inputFormat.parse(dateTime.toString());
    DateFormat outputFormatTime = DateFormat("hh:mm a");
    String formattedNewTime = outputFormatTime.format(originalDate);
    return formattedNewTime.toString()??"";
  }

  updateDeliveryStatus(String status) async {
    await BaseController.firebaseAuth.updateOrderStatus(selectedOrder["orderID"],status,true);
   var order = await BaseController.firebaseAuth.getOrderById(selectedOrder["orderID"]);
   selectedOrder.assignAll(order);
    currentStatusIndex.value = Constants.orderStatusListOfDriver.indexWhere((element) => element==selectedOrder['status'],);
    selectedOrder.refresh();
  }


  getCustomerNameId(String id) async {
   var data = await BaseController.firebaseAuth.getCurrentUserInfoById(id,"customer");

   customerName.value = data?["username"];
  }

  void fetchFcmTokenByIdAndSendNotification(String userId, String status , String orderId) async {
    try {
      final response = await BaseController.firebaseAuth.fetchDetailsById(
        'customer',
        userId,
      );
      if (response != null) {
        String fcmToken = response['fcmToken'];
        print(">> $fcmToken");
        final firebaseMessaging = FCM();
        firebaseMessaging.sendFcm(
          fcmToken,
          "Order Update",
          "Order ID : #$orderId \n $status",
          {"orderID": orderId },
        );
      }

    } catch (e) {
      print("Error :  $e");
    } finally {
    }
  }
}