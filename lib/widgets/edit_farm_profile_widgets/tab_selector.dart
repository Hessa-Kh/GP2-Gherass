import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  const TabSelector({super.key, required this.pageController, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0x1E78788C),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                pageController.jumpToPage(0);
                onPageChanged(0);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'معلومات المزرعة',
                    style: TextStyle(
                      color: Color(0xFF797D82),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                pageController.jumpToPage(1);
                onPageChanged(1);
              },
              child: const Center(
                child: Text(
                  'المعلومات الشخصيه',
                  style: TextStyle(
                    color: Color(0xFF797D82),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
