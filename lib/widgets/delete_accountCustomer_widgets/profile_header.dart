import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 73,
          height: 70,
          decoration: BoxDecoration(
            color: Color(0xFFF3F3F3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            size: 32,
            color: Color(0xFF797D82),
          ),
        ),
        SizedBox(height: 22),
        Text(
              'إيمان الوهيبي',
          style: TextStyle(
            color: Color(0xFF101010),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 17),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'الرياض، 13455 حي المحمدية',
              style: TextStyle(
                color: Color(0xFF797D82),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.12,
              ),
            ),
            SizedBox(width: 7),
            Icon(
              Icons.check,
              size: 12,
              color: Color(0xFF797D82),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          '+966 05 *** ****',
          style: TextStyle(
            color: Color(0xFF797D82),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.12,
          ),
        ),
      ],
    );
  }
}

  