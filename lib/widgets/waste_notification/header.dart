import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'غراس',
          style: TextStyle(
            fontFamily: 'Almarai',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            'https://cdn.builder.io/api/v1/image/assets/TEMP/c8cb1dee6c5815fe349c50d0855f7ab7192d59f6c3a8fcf41ceeb7cc669f91ae?placeholderIfAbsent=true&apiKey=07febad35e63414ebd02df60a0e63645',
            width: 36,
            height: 37,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}