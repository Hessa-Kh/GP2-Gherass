import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextEditingController? controller; // ✅ Add this line

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.keyboardType,
    this.controller, // ✅ Add this line
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true; // Controls password visibility

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.controller, // ✅ Use the controller
          obscureText: widget.isPassword ? _isObscured : false,
          keyboardType: widget.keyboardType,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 17,
              horizontal: 70,
            ),
            prefixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
          ),
        ),
      ],
    );
  }
}
