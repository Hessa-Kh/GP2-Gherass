import 'package:flutter/material.dart';

class ProductFormField extends StatelessWidget {
  final String label;
  final String hint;
  final int maxLines;
  final ValueChanged<String> onChanged; // Correctly define the callback function

  const ProductFormField({
    super.key,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    required this.onChanged, // Properly require the onChanged function
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(147, 96, 2, 0.2),
            blurRadius: 9,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: TextFormField(
        textAlign: TextAlign.right,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFB7B7B7),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
            letterSpacing: 0.16,
          ),
          labelText: label,
        ),
        onChanged: onChanged, // Now correctly passing the onChanged callback
      ),
    );
  }
}
