import 'package:flutter/material.dart';
import '../../../widgets/delete_accountCustomer_widgets/profile_header.dart';
import '../../../widgets/delete_accountCustomer_widgets/nav_items.dart';
import '../../../widgets/delete_accountCustomer_widgets/bottom_nav.dart';
import '../../../widgets/delete_accountCustomer_widgets/delete_account.dart';
import '../../../widgets/delete_accountCustomer_widgets/logout_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.transparent,
  elevation: 0,
  centerTitle: true, // Ensures the title is centered
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
              ProfileHeader(),
              SizedBox(height: 40),
              NavItems(title: 'حسابات الدفع', icon: Icons.wallet),
              SizedBox(height: 40),
              NavItems(title: 'عنوان التوصيل', icon: Icons.home),
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
