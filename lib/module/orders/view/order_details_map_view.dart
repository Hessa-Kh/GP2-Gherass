import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/orders/controller/order_detail_map_controller.dart';
import 'package:gherass/theme/styles.dart';

import '../../../theme/app_theme.dart';
import '../../home/home_controller.dart';
import 'map_view_widgets.dart';

class OrderDetailsMapView extends StatelessWidget {
  const OrderDetailsMapView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<OrderDetailMapController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          title: Text(
            "${"Order".tr}   #${controller.selectedOrder['orderID']}",
            style: Styles.boldTextView(16, AppTheme.black),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
              onTap: () {
                Get.back();
                Get.find<HomeViewController>().getDatas();
              },
              child: CircleAvatar(
                backgroundColor: AppTheme.pampas,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: AppTheme.black,
                ),
              ),
            ),
          ),
        ),
        body: MapViewWidgets().mapViewWidget(context,controller.selectedOrder),
      ),
    );
  }
}
