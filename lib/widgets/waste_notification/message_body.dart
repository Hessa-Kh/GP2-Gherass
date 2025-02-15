import 'package:flutter/material.dart';

class MessageBody extends StatelessWidget {
  const MessageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'أهلا سعيد،\nنظراً لقرب تعرض المنتج للتلف وتجنباً للخسارة،\nنقترح عليك تقديم عرض تسويقي للعملاء خلال الفترة القادمة.',
      textAlign: TextAlign.right,
      style: TextStyle(
        fontFamily: 'Almarai',
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        height: 1.67,
        letterSpacing: 0.12,
      ),
    );
  }
}