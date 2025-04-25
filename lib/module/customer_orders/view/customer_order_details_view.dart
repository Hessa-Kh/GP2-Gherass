import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/appBar.dart';
import '../controller/customer_orders_controller.dart';
import 'widgets/customer_orders_widgets.dart';

class CustomerOrderDetailsView extends StatelessWidget {
  const CustomerOrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CustomerOrdersController>();
    return RefreshIndicator(
      onRefresh: () async{
        controller.onInit();
      },
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Order ",
        ),
        body: CustomerOrdersWidgets().ordersDetailWidget(),
      ),
    );
  }
}
