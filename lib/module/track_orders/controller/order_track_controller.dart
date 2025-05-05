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
    super.onInit();

    if (Get.arguments != null && Get.arguments.isNotEmpty) {
      orderId.value = Get.arguments[0] ?? "";
    }

    if (orderStatusList.isEmpty) {
      orderStatusList.addAll(Constants.orderStatusListOfFarmer);
      orderStatusList.addAll(Constants.orderStatusListOfDriver);
    }

    updateStatus();
  }

  updateStatus() async {
    if (orderId.value.isNotEmpty) {
      await getOrderStatus();
    }
  }

  getOrderStatus() async {
    try {
      if (orderId.value.isEmpty) {
        return;
      }

      final orderDetails = await BaseController.firebaseAuth.getOrderById(
        orderId.value,
      );

      if (orderDetails.isEmpty) {
        return;
      }

      orderStatus.value = orderDetails["status"] ?? "unknown";

      var lat = orderDetails['delivery_address']?['lat'] ?? 24.774265;
      var lng = orderDetails['delivery_address']?['lng'] ?? 46.738586;
      mapPosition.value = LatLng(lat, lng);

      if (googleMapController != null) {
        googleMapController!.animateCamera(
          CameraUpdate.newLatLng(mapPosition.value!),
        );
      }

      final driverId = orderDetails["driverId"];

      if (driverId == null || driverId.toString().isEmpty) {
        return;
      }

      final driverDetails = await BaseController.firebaseAuth.fetchDetailsById(
        'driver',
        driverId,
      );

      if (driverDetails == null || driverDetails.isEmpty) {
        return;
      }

      driverName.value = driverDetails["name"] ?? "Unknown";
      driverphone.value = driverDetails["phoneNumber"] ?? "N/A";

      statusIndex = orderStatusList.toList().indexWhere(
        (element) => element == orderStatus.value,
      );
    } catch (e, stackTrace) {}
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
