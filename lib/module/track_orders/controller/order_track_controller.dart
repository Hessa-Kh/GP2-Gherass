import 'dart:developer';

import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/util/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderTrackController extends BaseController {
  var orderId = "".obs;
  var orderStatus = "".obs;
  var driverName = "".obs;
  var driverphone = "".obs;
  GoogleMapController? googleMapController;
  var mapPosition = Rxn<LatLng>();
  Set<String> orderStatusList = {};
  var statusIndex = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if (Get.arguments != null){
      var orderId = Get.arguments[0];
      print("orderId : $orderId");
      this.orderId.value = orderId ?? "";
    }

    if (orderStatusList.isEmpty) {
      for (var element in Constants.orderStatusListOfFarmer) {
        orderStatusList.add(element);
      }
      for (var element in Constants.orderStatusListOfDriver) {
        orderStatusList.add(element);
      }
    }
    getOrderStatus();
  }

  getOrderStatus() async {
    final orderDetails = await BaseController.firebaseAuth.getOrderById(
      orderId.value.toString(),
    );

    orderStatus.value = orderDetails["status"];
    var lat = orderDetails['delivery_address']['lat'] ?? 24.774265;
    var lng = orderDetails['delivery_address']['lng'] ?? 46.738586;
    mapPosition.value = LatLng(lat, lng);

    if (googleMapController != null) {
      googleMapController!.animateCamera(
        CameraUpdate.newLatLng(mapPosition.value!),
      );
    }

    final driverId = orderDetails["driverId"];
    log('driverId:$driverId');
    final driverDetails = await BaseController.firebaseAuth.fetchDetailsById(
      'driver',
      driverId,
    );
    driverName.value = driverDetails!["name"];
    driverphone.value = driverDetails["phoneNumber"];

    log('driverDetails:${driverDetails["phoneNumber"].toString()}');
    statusIndex = orderStatusList.toList().indexWhere(
      (element) => element == orderStatus,
    );
  }

  openDialPad() async {
    Uri url = Uri(scheme: "tel", path: driverphone.value);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print("Can't open dial pad.");
    }
  }
}
