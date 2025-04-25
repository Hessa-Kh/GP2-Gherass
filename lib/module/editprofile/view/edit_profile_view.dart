import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/editprofile/view/edit_profile_widgets.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/appBar.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Account".tr, showBackButton: true),
      backgroundColor: AppTheme.white,
      resizeToAvoidBottomInset: true,
      body: EditProfileWidgets().editProfileViewWidget(context),
    );
  }
}
