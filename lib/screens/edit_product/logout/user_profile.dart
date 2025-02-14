import 'package:flutter/material.dart';
import '../../widgets/user_profile/user_info.dart';
import '../../widgets/user_profile/nav_items.dart';
import '../../widgets/user_profile/logout_button.dart';
import '../../widgets/user_profile/delete_account.dart';
import '../../widgets/user_profile/bottom_nav.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'الحساب',
          style: TextStyle(
            color: Color.fromRGBO(16, 16, 16, 1),
            fontSize: 20,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 46.0, vertical: 23.0),
          child: Column(
            children: [
              SizedBox(height: 5), // To give space after the app bar
              UserInfo(),
              SizedBox(height: 40),
              NavItems(title: 'المزرعه', icon: Icons.warehouse),
              SizedBox(height: 40),
              NavItems(title: 'الإعدادات', icon: Icons.settings),
              SizedBox(height: 40),
              NavItems(title: 'اللغة العربية', icon: Icons.language),
              SizedBox(height: 70),
              LogoutButton(),
              SizedBox(height: 50),
              DeleteAccount(),
              SizedBox(height: 10),
              BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}
