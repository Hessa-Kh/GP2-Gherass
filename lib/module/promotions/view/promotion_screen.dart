import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/promotions/view/widgets/promotions_widgets.dart';

import '../../../widgets/appBar.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(title: "Promotions".tr),
        body: PromotionsWidgets().promotionsListWidget(context),
        bottomNavigationBar: PromotionsWidgets().listingPromoBottomNaviWidget(),
      ),
    );
  }
}
