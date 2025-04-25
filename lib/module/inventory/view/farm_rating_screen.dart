import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/module/inventory/view/widgets/inventory_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';

class FarmRatingScreen extends StatelessWidget {
  const FarmRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Farm Rating".tr,
          style: Styles.boldTextView(20, AppTheme.black),
        ),
        leading: Align(
          alignment:
              BaseController.languageName.value == "english"
                  ? Alignment.topLeft
                  : Alignment.topRight,
          child: IconButton(
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: InventoryWidget().farmRatingBody(context),
    );
  }
}
