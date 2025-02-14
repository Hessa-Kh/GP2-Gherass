import 'package:flutter/material.dart';

class ProductVisibilityWidget extends StatefulWidget {
  const ProductVisibilityWidget({super.key});

  @override
  _ProductVisibilityWidgetState createState() =>
      _ProductVisibilityWidgetState();
}

class _ProductVisibilityWidgetState extends State<ProductVisibilityWidget> {
  String selectedOption = 'الكل';

  void _onFilterSelected(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20), // Padding to match the quality selector
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20), // Rounded corners to match the style
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(147, 96, 2, 0.2),
            blurRadius: 9,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // Align text to the right
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
          const SizedBox(height: 20), // Adjusted the spacing for consistency
          Center( // Center the buttons
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centering the buttons horizontally
              children: [
                FilterButton(
                  text: 'الأعمال',
                  isSelected: selectedOption == 'الأعمال',
                  onTap: () => _onFilterSelected('الأعمال'),
                ),
                const SizedBox(width: 20),
                FilterButton(
                  text: 'الأفراد',
                  isSelected: selectedOption == 'الأفراد',
                  onTap: () => _onFilterSelected('الأفراد'),
                ),
                const SizedBox(width: 20),
                FilterButton(
                  text: 'الكل',
                  isSelected: selectedOption == 'الكل',
                  onTap: () => _onFilterSelected('الكل'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getPadding(text),
          vertical: isSelected ? 6 : 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? const Color.fromRGBO(228, 223, 211, 1)
              : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(147, 96, 2, 0.2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? Colors.black
                : const Color.fromRGBO(121, 125, 130, 1),
            fontSize: 14,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.16,
          ),
        ),
      ),
    );
  }

  double _getPadding(String text) {
    switch (text) {
      case 'الكل':
        return 18;  // Reduced padding for "الكل" button to prevent overflow
      case 'الأفراد':
        return 20;
      default:
        return 16;
    }
  }
}
