import 'package:flutter/material.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'حذف الحساب',
        style: TextStyle(
          color: Color(0xFFF84545),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}