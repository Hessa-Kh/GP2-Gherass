import 'package:flutter/material.dart';

class ProductQuantitySelector extends StatefulWidget {
  const ProductQuantitySelector({super.key});

  @override
  _ProductQuantitySelectorState createState() => _ProductQuantitySelectorState();
}

class _ProductQuantitySelectorState extends State<ProductQuantitySelector> {
  int quantityInt = 0;
  int quantityDecimal = 0;
  bool isIntegerSelected = true;
  bool isKilogram = true;

  late final ValueNotifier<bool> _isIncreasing;
  late final ValueNotifier<bool> _isDecreasing;

  @override
  void initState() {
    super.initState();
    _isIncreasing = ValueNotifier<bool>(false);
    _isDecreasing = ValueNotifier<bool>(false);
  }

  void _increase() {
    setState(() {
      if (isIntegerSelected) {
        if (quantityInt < 5000) quantityInt += 1;
      } else {
        if (quantityDecimal < 99) {
          quantityDecimal += 1;
        } else {
          if (quantityInt < 5000) {
            quantityInt += 1;
            quantityDecimal = 0;
          }
        }
      }
    });
  }

  void _decrease() {
    setState(() {
      if (isIntegerSelected) {
        if (quantityInt > 0) quantityInt -= 1;
      } else {
        if (quantityDecimal > 0) {
          quantityDecimal -= 1;
        } else if (quantityInt > 0) {
          quantityInt -= 1;
          quantityDecimal = 99;
        }
      }
    });
  }

  void _startIncreasing() {
    _isIncreasing.value = true;
    _increase();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isIncreasing.value) {
        _holdIncrease();
      }
    });
  }

  void _stopIncreasing() {
    _isIncreasing.value = false;
  }

  void _holdIncrease() {
    if (_isIncreasing.value) {
      _increase();
      Future.delayed(const Duration(milliseconds: 100), _holdIncrease);
    }
  }

  void _startDecreasing() {
    _isDecreasing.value = true;
    _decrease();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_isDecreasing.value) {
        _holdDecrease();
      }
    });
  }

  void _stopDecreasing() {
    _isDecreasing.value = false;
  }

  void _holdDecrease() {
    if (_isDecreasing.value) {
      _decrease();
      Future.delayed(const Duration(milliseconds: 100), _holdDecrease);
    }
  }

  void _toggleUnit(bool isKg) {
    setState(() {
      isKilogram = isKg;
    });
  }

  @override
  void dispose() {
    _isIncreasing.dispose();
    _isDecreasing.dispose();
    super.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleUnit(true),
                    child: _buildUnitOption('كجم', isKilogram),
                  ),
                  const SizedBox(width: 17),
                  GestureDetector(
                    onTap: () => _toggleUnit(false),
                    child: _buildUnitOption('جرام', !isKilogram),
                  ),
                ],
              ),
              const Text(
                'الكمية',
                style: TextStyle(
                  color: Color(0xFF797D82),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Almarai',
                  letterSpacing: 0.16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _decrease,
                onLongPressStart: (_) => _startDecreasing(),
                onLongPressEnd: (_) => _stopDecreasing(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF9F8F6),
                  ),
                  child: const Center(
                    child: Icon(Icons.remove, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => isIntegerSelected = false),
                child: Text(
                  quantityDecimal.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: !isIntegerSelected ? Colors.black : const Color(0xFF797D82),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              const Text(
                '.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF797D82),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => isIntegerSelected = true),
                child: Text(
                  quantityInt.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: isIntegerSelected ? Colors.black : const Color(0xFF797D82),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isKilogram ? 'كجم' : 'جرام',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF797D82),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _increase,
                onLongPressStart: (_) => _startIncreasing(),
                onLongPressEnd: (_) => _stopIncreasing(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF9F8F6),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, size: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnitOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
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
        style: const TextStyle(
          color: Color(0xFF797D82),
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Almarai',
          letterSpacing: 0.14,
        ),
      ),
    );
  }
}
