import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/book_events/view/widgets/booked_events_widgets.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/styles.dart';

class BookedEventScreen extends StatelessWidget {
  const BookedEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "My Events".tr,
            style: Styles.boldTextView(20, AppTheme.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: BookedEventsWidgets().eventSectionListWidget(context),
      ),
    );
  }
}
