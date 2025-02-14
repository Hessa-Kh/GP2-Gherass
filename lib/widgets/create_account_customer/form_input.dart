import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final TextEditingController controller; // أضف هذا السطر

  const FormInput({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller, // أضف هذا السطر
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 9),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
          child: TextField(
            controller: controller, // أضف هذا السطر
            obscureText: isPassword,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
              ),
              border: InputBorder.none,
              suffixIcon: isPassword
                  ? Icon(Icons.visibility_off, color: Color(0xFFBDBDBD))
                  : null,
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
