import 'package:flutter/material.dart';

class ProductPriceInput extends StatefulWidget {
  const ProductPriceInput({super.key});

  @override
  _ProductPriceInputState createState() => _ProductPriceInputState();
}

class _ProductPriceInputState extends State<ProductPriceInput> {
  int priceInt = 0;
  int priceDecimal = 0;
  bool isIntegerSelected = true;

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
        priceInt += 1;
      } else {
        if (priceDecimal < 99) {
          priceDecimal += 1;
        } else {
          priceInt += 1;
          priceDecimal = 0;
        }
      }
    });
  }

  void _decrease() {
    setState(() {
      if (isIntegerSelected) {
        if (priceInt > 0) priceInt -= 1;
      } else {
        if (priceDecimal > 0) {
          priceDecimal -= 1;
        } else if (priceInt > 0) {
          priceInt -= 1;
          priceDecimal = 99;
        }
      }
    });
  }

  void _startIncreasing() {
    _isIncreasing.value = true;
    _increase();
    Future.delayed(Duration(milliseconds: 500), () {
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
      Future.delayed(Duration(milliseconds: 100), _holdIncrease);
    }
  }

  void _startDecreasing() {
    _isDecreasing.value = true;
    _decrease();
    Future.delayed(Duration(milliseconds: 500), () {
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
      Future.delayed(Duration(milliseconds: 100), _holdDecrease);
    }
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: const Text(
              'سعر المنتج',
              style: TextStyle(
                color: Color(0xFF797D82),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                onLongPressStart: (_) => _startIncreasing(),
                onLongPressEnd: (_) => _stopIncreasing(),
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
