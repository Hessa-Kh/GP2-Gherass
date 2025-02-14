import 'package:flutter/material.dart';

class ProductQualitySelector extends StatefulWidget {
  const ProductQualitySelector({super.key});

  @override
  _ProductQualitySelectorState createState() => _ProductQualitySelectorState();
}

class _ProductQualitySelectorState extends State<ProductQualitySelector> {
  String selectedQuality = 'organic'; // Default to 'organic'

  void _selectQuality(String quality) {
    setState(() {
      selectedQuality = quality;
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
        crossAxisAlignment: CrossAxisAlignment.end,  // Align the content to the right
        children: [
          const Text(
            'جودة المنتج',
            style: TextStyle(
              color: Color(0xFF797D82),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
              letterSpacing: 0.16,
            ),
            textAlign: TextAlign.right, // Align text to the right
          ),
          const SizedBox(height: 20),
          Center(  // Center the buttons
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,  // Center buttons horizontally
              children: [
                _buildQualityOption('غير عضوي', 'not_organic'),
                const SizedBox(width: 20),
                _buildQualityOption('عضوي', 'organic'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualityOption(String text, String value) {
    bool isSelected = selectedQuality == value;
    return GestureDetector(
      onTap: () => _selectQuality(value),
      child: Container(
        width: 120,  // Set a fixed width for equal size buttons
        padding: const EdgeInsets.symmetric(vertical: 8),
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
        child: Center(  // Center the text inside the button
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF797D82),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
              letterSpacing: 0.14,
            ),
          ),
        ),
      ),
    );
  }
}
