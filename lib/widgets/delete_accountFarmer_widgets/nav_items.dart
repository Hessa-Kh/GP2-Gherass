import 'package:flutter/material.dart';

class NavItems extends StatelessWidget {
  final String title;
  final IconData icon;

  const NavItems({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF101010),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(width: 20),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFEFEFEF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: Color(0xFF101010),
          ),
        ),
      ],
    );
  }
}