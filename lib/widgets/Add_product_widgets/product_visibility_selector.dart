import 'package:flutter/material.dart';

class ProductVisibilitySelector extends StatefulWidget {
  const ProductVisibilitySelector({super.key});

  @override
  _ProductVisibilitySelectorState createState() => _ProductVisibilitySelectorState();
}

class _ProductVisibilitySelectorState extends State<ProductVisibilitySelector> {
  String selectedOption = 'both';

  void _selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ظهور المنتجات لـ',
            style: TextStyle(
              color: Color(0xFF797D82),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
              letterSpacing: 0.16,
            ),
          ),
          const SizedBox(height: 21),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildOption('الأعمال', 'business'),
              const SizedBox(width: 17),
              _buildOption('الأفراد', 'individual'),
              const SizedBox(width: 17),
              _buildOption('الكل', 'both'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String text, String value) {
    bool isSelected = selectedOption == value;
    return GestureDetector(
      onTap: () => _selectOption(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? const Color(0xFFEBE8E2) : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(147, 96, 2, 0.2),
              blurRadius: 9,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF797D82),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ),
    );
  }
}
