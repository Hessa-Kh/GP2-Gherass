import 'package:flutter/material.dart';

import 'dashboard_widgets.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: DashboardWidgets().dashboardNavBar(context)),
    );
  }
}
