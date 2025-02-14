import 'package:flutter/material.dart';
import 'dart:async';

class ProductQuantitySelector extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const ProductQuantitySelector({super.key, required this.onChanged});

  @override
  _ProductQuantitySelectorState createState() => _ProductQuantitySelectorState();
}

class _ProductQuantitySelectorState extends State<ProductQuantitySelector> {
  int quantityInt = 0;
  int quantityDecimal = 0;
  bool isIntegerSelected = true;
  bool isKilogram = true;
  Timer? _timer;

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
    _updateQuantity();
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
    _updateQuantity();
  }

  void _toggleUnit(bool isKg) {
    setState(() {
      isKilogram = isKg;
    });
    _updateQuantity();
  }

  void _startTimer(VoidCallback action) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      action();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _updateQuantity() {
    double finalQuantity = quantityInt + (quantityDecimal / 100);
    if (!isKilogram) {
      finalQuantity /= 1000;
    }
    widget.onChanged(finalQuantity);
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
            ],
          ),
          const SizedBox(height: 21),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _decrease,
                onLongPress: () => _startTimer(_decrease),
                onLongPressUp: _stopTimer,
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
                onLongPress: () => _startTimer(_increase),
                onLongPressUp: _stopTimer,
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
