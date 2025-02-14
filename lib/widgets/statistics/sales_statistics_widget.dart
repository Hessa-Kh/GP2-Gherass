import 'package:flutter/material.dart';

class SalesStatisticsWidget extends StatelessWidget {
  const SalesStatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 198, 201, 255), 
            Color(0xFFFFFFFF), 
          ],
          stops: [0.10, 0.90], 
        ),
      ),
    );
  }
}
