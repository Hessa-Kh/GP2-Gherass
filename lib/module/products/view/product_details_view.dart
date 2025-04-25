import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/products/view/product_widgets.dart';

import '../../../widgets/appBar.dart';
import '../controller/product_contoller.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return Obx(
      () => Scaffold(
        appBar: CommonAppBar(
          title: "Product Detail Page",
          onBackPressed: () {
            Get.offAllNamed(Routes.dashBoard);
          },
        ),
        bottomNavigationBar:
            !controller.logInType.value.contains("farmer")
                ? ProductWidgets().productDetailsNavBar(context)
                : null,
        body: ProductWidgets().productDetailsWidget(context),
      ),
    );
  }
}
