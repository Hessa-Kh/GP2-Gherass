import 'package:flutter/material.dart';
import 'package:ghereass/widgets/farm_info/custom_app_bar.dart';
import 'package:ghereass/widgets/farm_info/farm_form.dart';


class FarmInfoScreen extends StatelessWidget {
  const FarmInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          color: Colors.white,
        ),
        child: Column(
          children: const [
            CustomAppBar(),
            Expanded(
              child: FarmForm(),
            ),
          ],
        ),
      ),
    );
  }
}