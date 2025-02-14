import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Color(0xFF936002).withOpacity(0.2), blurRadius: 9)],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.person, size: 24, color: Color(0xFF101010)),
          Icon(Icons.assignment, size: 24, color: Color(0xFF101010)),
          Icon(Icons.shopping_bag, size: 24, color: Color(0xFF101010)),
          Icon(Icons.home, size: 24, color: Color(0xFF101010)),
        ],
      ),
    );
  }
}
