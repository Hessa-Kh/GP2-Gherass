import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/events/view/widgets/event_widgets.dart';

import '../../../widgets/appBar.dart';

class AddEventScreen extends StatelessWidget {
  const AddEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "Add Event".tr),
      body: EventWidgets().eventWidgetBody(context),
      bottomNavigationBar: EventWidgets().addEventbottomNaviWidget(),
    );
  }
}
