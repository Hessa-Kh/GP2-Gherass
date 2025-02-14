import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF93C249),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(100),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(49, 24, 49, 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF101010),
              letterSpacing: -0.24,
            ),
          ),
          SizedBox(height: 32),
          Text(
            'معلومات المزرعة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.2,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}