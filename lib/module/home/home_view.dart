import 'package:flutter/material.dart';

import 'home_widgets.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: HomeWidgets().homeWidget(context),
    );
  }
}
