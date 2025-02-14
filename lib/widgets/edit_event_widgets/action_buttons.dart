import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 55,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(147, 96, 2, 0.2),
                blurRadius: 9,
              ),
            ],
          ),
          child: const Text(
            'إلغاء',
            style: TextStyle(
              color: Color(0xFF797D82),
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 59,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF6472D2),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(147, 96, 2, 0.2),
                blurRadius: 9,
              ),
            ],
          ),
          child: const Text(
            'تعديل',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}