import 'package:flutter/material.dart';
import 'package:gherass/module/profile/view/profile_view_widgets.dart';

import '../../../widgets/appBar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Account", showBackButton: false),
      body: SingleChildScrollView(
        child: ProfileViewWidgets().profileViewWidget(context),
      ),
    );
  }
}
