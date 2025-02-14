import 'package:flutter/material.dart';

class ProductsCard extends StatelessWidget {
  final int totalProducts;
  final double percentageChange;
  final bool isPositiveChange;

  const ProductsCard({
    super.key,
    required this.totalProducts,
    required this.percentageChange,
    this.isPositiveChange = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.inventory_2,
                  size: 24,
                  color: const Color(0xFF34A853),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'إجمالي المنتجات',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'Almarai',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: Text(
              '$totalProducts منتج',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212529),
                fontFamily: 'Inter',
                letterSpacing: -0.4,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF5F0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${percentageChange.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF34A853),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isPositiveChange ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: const Color(0xFF34A853),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}