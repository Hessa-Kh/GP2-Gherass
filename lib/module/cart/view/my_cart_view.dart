import 'package:flutter/material.dart';
import 'package:gherass/module/cart/view/my_cart_widgets.dart';
import 'package:gherass/widgets/appBar.dart';

class MyCartScreen extends StatelessWidget {
  final showBackButton;
  const MyCartScreen({super.key, this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(showBackButton: showBackButton ?? true),
      body: MyCartWidgets().myCartWidget(context),
    );
  }
}
