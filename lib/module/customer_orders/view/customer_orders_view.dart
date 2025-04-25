import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/customer_orders/view/widgets/customer_orders_widgets.dart';

import '../../../widgets/appBar.dart';

class CustomerOrdersView extends StatelessWidget {
  const CustomerOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Orders".tr, showBackButton: false),
      body: CustomerOrdersWidgets().ordersListWidget(context),
    );
  }
}
