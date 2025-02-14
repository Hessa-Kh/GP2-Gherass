import 'package:flutter/material.dart';

class ProductQualitySelector extends StatefulWidget {
  final ValueChanged<bool> onChanged; // Correct function type

  const ProductQualitySelector({super.key, required this.onChanged});

  @override
  _ProductQualitySelectorState createState() => _ProductQualitySelectorState();
}

class _ProductQualitySelectorState extends State<ProductQualitySelector> {
  bool isOrganic = true; // Default to organic

  void _selectQuality(bool organic) {
    setState(() {
      isOrganic = organic;
    });
    widget.onChanged(isOrganic); // Notify parent widget of change
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
            'جودة المنتج',
            style: TextStyle(
              color: Color(0xFF797D82),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
              letterSpacing: 0.16,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildQualityOption('غير عضوي', false),
              const SizedBox(width: 20),
              _buildQualityOption('عضوي', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityOption(String text, bool value) {
    bool isSelected = isOrganic == value;
    return GestureDetector(
      onTap: () => _selectQuality(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
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
            fontSize: 14,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
            letterSpacing: 0.14,
          ),
        ),
      ),
    );
  }
}
