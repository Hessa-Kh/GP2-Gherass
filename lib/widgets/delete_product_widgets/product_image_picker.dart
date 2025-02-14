import 'package:flutter/material.dart';

class ProductImagePicker extends StatelessWidget {
  const ProductImagePicker({Key? key}) : super(key: key);

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
      padding: const EdgeInsets.symmetric(horizontal: 39, vertical: 33),
      child: Column(
        children: [
          Image.network(
            'https://cdn.builder.io/api/v1/image/assets/4317a1cae26b4df38540eedfded43565/b83e872eb595bf9e984ffb93d88847e6f1252dabadacd838381c52a7f080ada1?apiKey=4317a1cae26b4df38540eedfded43565&',
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 27),
          Text(
            'تغيير صورة المنتج',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Almarai',
              color: const Color(0xFF797D82),
              letterSpacing: 0.16,
            ),
          ),
        ],
      ),
    );
  }
}