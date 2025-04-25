import 'package:flutter/material.dart';
import 'package:gherass/module/products/view/product_widgets.dart';


class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProductWidgets().eventDetailsWidget(context));
  }
}
