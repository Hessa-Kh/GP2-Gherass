import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/events/view/widgets/event_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';

import '../controller/event_controller.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<EventController>();
    return Obx(
      () => RefreshIndicator(
        onRefresh: () async{
          await controller.getEventList();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Events".tr,
              style: Styles.boldTextView(20, AppTheme.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: EventWidgets().eventSectionListWidget(context),
          bottomNavigationBar: EventWidgets().eventBottomNavWidget(),
        ),
      ),
    );
  }
}
