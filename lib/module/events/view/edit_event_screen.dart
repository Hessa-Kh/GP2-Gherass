import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/events/view/widgets/event_widgets.dart';

import '../../../widgets/appBar.dart';

class EditEventScreen extends StatelessWidget {
  const EditEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(title: "Edit Event".tr),
        body: EventWidgets().eventWidgetBody(context),
        bottomNavigationBar: EventWidgets().editEventBottomNaviWidget(),
      ),
    );
  }
}
