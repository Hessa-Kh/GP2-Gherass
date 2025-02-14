import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF936002).withOpacity(0.2),
                    blurRadius: 9,
                  ),
                ],
              ),
              child: Text(
                'إلغاء',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF797D82),
                  fontFamily: 'Almarai',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: TextButton(
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF6472D2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF936002).withOpacity(0.2),
                    blurRadius: 9,
                  ),
                ],
              ),
              child: Text(
                'تأكيد',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Almarai',
                  fontSize: 16,
                  letterSpacing: 0.16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}