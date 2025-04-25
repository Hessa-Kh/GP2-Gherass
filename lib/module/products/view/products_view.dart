import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/products/view/product_widgets.dart';
import '../../../helper/routes.dart';
import '../../../theme/app_theme.dart';
import '../../../util/image_util.dart';
import '../../../widgets/appBar.dart';
import '../../../widgets/svg_icon_widget.dart';
import '../controller/product_contoller.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return Obx(
      () => Scaffold(
        appBar: CommonAppBar(
          title: "Farm Detail Page",
          onBackPressed: () {
            Get.offAllNamed(Routes.dashBoard);
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child:
              controller.logInType.value.contains("customer")
                  ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                    ),
                    onPressed: () {
                      log(controller.farmerId.value.toString());
                      Get.toNamed(
                        Routes.myCart,
                        arguments: [controller.farmerId.value],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgIcon(
                        ImageUtil.bag,
                        size: 40,
                        color: AppTheme.white,
                      ),
                    ),
                  )
                  : SizedBox.shrink(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        body: ProductWidgets().bookEventWidget(context),
      ),
    );
  }
}
