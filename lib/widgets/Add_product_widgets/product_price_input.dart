import 'package:flutter/material.dart';
import 'dart:async';

class ProductPriceInput extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const ProductPriceInput({super.key, required this.onChanged});

  @override
  _ProductPriceInputState createState() => _ProductPriceInputState();
}

class _ProductPriceInputState extends State<ProductPriceInput> {
  int priceInt = 0;
  int priceDecimal = 0;
  bool isIntegerSelected = true;
  Timer? _timer;

  void _increase() {
    setState(() {
      if (isIntegerSelected) {
        if (priceInt < 99) {
          priceInt += 1;
        } else {
          if (priceDecimal < 5000) {
            priceDecimal += 1;
            priceInt = 0;
          }
        }
      } else {
        if (priceDecimal < 5000) {
          priceDecimal += 1;
        }
      }
    });
    _updatePrice();
  }

  void _decrease() {
    setState(() {
      if (isIntegerSelected) {
        if (priceInt > 0) {
          priceInt -= 1;
        } else if (priceDecimal > 0) {
          priceDecimal -= 1;
          priceInt = 99;
        }
      } else {
        if (priceDecimal > 0) {
          priceDecimal -= 1;
        }
      }
    });
    _updatePrice();
  }

  void _startTimer(VoidCallback action) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      action();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void _updatePrice() {
    double finalPrice = priceInt + (priceDecimal / 100);
    widget.onChanged(finalPrice);
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
            'سعر المنتج',
            style: TextStyle(
              color: Color(0xFF797D82),
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
            ),
          ),
          const SizedBox(height: 10),
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
                    borderRadius: BorderRadius.circular(37),
                    color: const Color(0xFFF9F8F6),
                  ),
                  child: const Center(
                    child: Icon(Icons.remove, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => isIntegerSelected = true),
                child: Text(
                  priceInt.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: isIntegerSelected ? Colors.black : const Color(0xFF797D82),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              const Text('.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF797D82))),
              GestureDetector(
                onTap: () => setState(() => isIntegerSelected = false),
                child: Text(
                  priceDecimal.toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: !isIntegerSelected ? Colors.black : const Color(0xFF797D82),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ر.س',
                style: TextStyle(
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
                    borderRadius: BorderRadius.circular(37),
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
}
