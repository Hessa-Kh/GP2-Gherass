import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/add_product/view/widgets/add_prod_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AddProdWidgets().getTitile(),
          style: Styles.boldTextView(20, AppTheme.black),
        ),
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: AddProdWidgets().addProdForm(context),
      bottomNavigationBar: AddProdWidgets().addProdbottomNaviWidget(),
    );
  }
}
