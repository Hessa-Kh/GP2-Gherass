import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final Future<void> Function() onPressed; // Declare onPressed properly

  const ActionButtons({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the screen when cancel is clicked
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 9,
              shadowColor: const Color.fromRGBO(147, 96, 2, 0.2),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                color: Color(0xFF797D82),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
                letterSpacing: 0.16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await onPressed(); // Call the passed function
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF93C249),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 9,
              shadowColor: const Color.fromRGBO(147, 96, 2, 0.2),
            ),
            child: const Text(
              'إضافة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
                letterSpacing: 0.16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
