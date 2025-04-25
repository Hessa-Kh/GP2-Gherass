import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/promotions/view/widgets/promotions_widgets.dart';

import '../../../widgets/appBar.dart';

class EditPromotionScreen extends StatelessWidget {
  const EditPromotionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(title: "Promotion"),
        body: PromotionsWidgets().promotionBody(context),
        bottomNavigationBar:
            PromotionsWidgets().editPromotionBottomNaviWidget(),
      ),
    );
  }
}
