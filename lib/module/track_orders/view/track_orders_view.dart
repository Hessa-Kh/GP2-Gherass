import 'package:flutter/material.dart';
import 'package:gherass/module/track_orders/view/widgets/track_orders_widgets.dart';

class TrackOrdersView extends StatelessWidget {
  const TrackOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: TrackOrdersWidgets().trackOrdersWidget(context));
  }
}
