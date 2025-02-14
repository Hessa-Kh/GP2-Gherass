import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String initialValue;
  final String label;

  const CustomTextField({
    Key? key,
    required this.initialValue,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEBE8E2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF936002).withOpacity(0.2),
            blurRadius: 9,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 23),
      child: TextFormField(
        initialValue: initialValue,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontFamily: 'Almarai',
            color: const Color(0xFF797D82),
            letterSpacing: 0.16,
          ),
        ),
      ),
    );
  }
}