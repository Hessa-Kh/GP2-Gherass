import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/orders/controller/orders_controller.dart';
import 'package:gherass/module/orders/view/orders_widgets.dart';
import 'package:gherass/widgets/appBar.dart';


class OrdersView extends StatelessWidget {
  final bool? showBackButton;

  const OrdersView({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OrdersController>();
    return Obx(
      () => Scaffold(
        appBar: CommonAppBar(
          title:
              controller.pageName.value == "detailPage"
                  ? "Order Details"
                  : "Orders",
          showBackButton: controller.pageName.value == "detailPage" || (showBackButton ?? false),
          onBackPressed: () {
            if (controller.pageName.value == "detailPage") {
              controller.pageName.value = "";
            } else {
              Get.back();
            }
          },
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.onInit();
          },
          child:
              controller.pageName.value == "detailPage"
                  ? OrdersWidgets().orderDetailsWidget()
                  : OrdersWidgets().ordersListWidget(context),
        ),
      ),
    );
  }
}
