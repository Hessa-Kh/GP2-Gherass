import 'dart:async';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/track_orders/view/widgets/track_orders_widgets.dart';
import 'package:gherass/util/constants.dart';

class OrdersTimerController extends BaseController {
  static const int countdownSeconds = 5 * 60; // 5 minutes
  var remainingSeconds = countdownSeconds.obs;
  Timer? timer;
  var orderId = "".obs;

  @override
  void onInit() {
    super.onInit();

    print("Get.arguments: ${Get.arguments}");

    if (Get.arguments != null && Get.arguments.isNotEmpty) {
      orderId.value = Get.arguments[0]?.toString() ?? "";
      print("OrdersTimerController orderId: ${orderId.value}");
    } else {
      print("No orderId passed to OrdersTimerController");
    }

    startTimer();
  }

  void startTimer() {
    if (orderId.value.isEmpty) {
      print("Cannot start timer: orderId is empty");
      return;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds.value <= 0) {
        timer?.cancel();
        _autoRejectOrder();
      } else {
        remainingSeconds.value--;
        print("Timer tick: ${remainingSeconds.value}");
        _checkOrderStatus();
      }
    });
  }

  Future<void> _checkOrderStatus() async {
    try {
      final orderStatus = await BaseController.firebaseAuth.getOrderStatusByid(
        orderId.value,
      );
      final isOrderRejected = await BaseController.firebaseAuth
          .getOrderIsRejectByid(orderId.value);

      print("Checking status for orderId: ${orderId.value}");
      print("Order status: $orderStatus");
      print("Is rejected: $isOrderRejected");

      if (Constants.orderStatusListOfFarmer[1] == orderStatus.toString()) {
        timer?.cancel();
        TrackOrdersWidgets().placedOrderDailogue(
          "Thank you. Your order has been Confirmed.",
        );
        Get.back();
        Get.toNamed(Routes.trackOrdersPage, arguments: [orderId.value]);
        return;
      }

      if (isOrderRejected) {
        timer?.cancel();
        TrackOrdersWidgets().placedOrderDailogue(
          "Thank you. Your order has been Rejected.",
        );
        Get.back();
        Get.toNamed(Routes.dashBoard);
        return;
      }
    } catch (e) {
      print("Error during order polling: $e");
    }
  }

  Future<void> _autoRejectOrder() async {
    try {
      await BaseController.firebaseAuth.rejectOrder(orderId.value);
      TrackOrdersWidgets().placedOrderDailogue(
        "Your order (ID: ${orderId.value}) has been rejected due to no response.",
      );
    } catch (e) {
      print("Error rejecting order: $e");
    }
    Get.toNamed(Routes.dashBoard);
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return "$minutes:${sec.toString().padLeft(2, '0')}";
  }
}
