import 'package:flutter/material.dart';
import 'package:gherass/module/vehicle_info/view/widgets/vehicle_info_widgets.dart';

import '../../../widgets/appBar.dart';

class VehicleInfoView extends StatelessWidget {
  final bool showBackButton;
  const VehicleInfoView({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Vehicle',
        showBackButton: showBackButton,
      ),
      body: VehicleInfoWidgets().vehicleInfoWidget(),
    );
  }
}
