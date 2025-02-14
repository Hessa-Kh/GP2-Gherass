import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  const TimeDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: const EdgeInsets.only(left: 13.0),
        child: Text(
          '9:41',
          style: TextStyle(
            color: Color(0xFF101010),
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.24,
          ),
        ),
      ),
    );
  }
}