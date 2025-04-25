import 'package:get/get.dart';
import 'dart:async';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/track_orders/view/widgets/track_orders_widgets.dart';
import 'package:gherass/util/constants.dart';

class OrdersTimerController extends BaseController {
  static const int countdownSeconds = 5 * 60;
  var remainingSeconds = countdownSeconds.obs;
  Timer? timer;
  var orderId = "".obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      // Check if the remaining seconds are greater than zero
      if (remainingSeconds.value > 0) {
        // Perform the asynchronous checks only if there's time left

        final orderstatus = await BaseController.firebaseAuth
            .getOrderStatusByid(orderId.value.toString());
        final isOrderReject = await BaseController.firebaseAuth
            .getOrderIsRejectByid(orderId.value.toString());
        print("isOrderReject: ${orderId.value.toString()}");
        print("isOrderReject: $isOrderReject");

        // Check if the order has been confirmed
        if (Constants.orderStatusListOfFarmer[1] == orderstatus.toString()) {
          timer.cancel();
          TrackOrdersWidgets().placedOrderDailogue(
            "Thank you. Your order has been Confirmed.",
          );
          Get.back();
          Get.toNamed(Routes.trackOrdersPage, arguments: [orderId.value]);
          return; // Exit the function early as the order is confirmed
        }

        // Check if the order is rejected
        if (isOrderReject) {
          timer.cancel();
          TrackOrdersWidgets().placedOrderDailogue(
            "Thank you. Your order has been Rejected.",
          );
          Get.back();
          Get.toNamed(Routes.dashBoard);
          return; // Exit early as the order is rejected
        }

        // Decrement the remaining time if no conditions matched
        remainingSeconds.value--;
      } else {
        await BaseController.firebaseAuth.rejectOrder(orderId.value.toString());
        // When the countdown reaches zero
        timer.cancel();
        TrackOrdersWidgets().placedOrderDailogue(
          "Your order has been  rejected your order (ID: ${orderId.value.toString()}",
        );
        Get.toNamed(Routes.dashBoard);
      }
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  // Format remaining time as minutes:seconds
  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int sec = seconds % 60;
    return "$minutes:${sec.toString().padLeft(2, '0')}";
  }
}
