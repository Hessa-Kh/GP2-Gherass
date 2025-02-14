import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/delete_accountFarmer_widgets/logout_dialog.dart';

class LogoutButton extends StatelessWidget {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LogoutDialog(
          onCancel: () {
            Navigator.of(context).pop(); // Close the dialog on cancel
          },
          onConfirm: () {
            // Handle the confirmation (e.g., log the user out)
            Navigator.of(context).pop(); // Close the dialog on confirm
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _showLogoutDialog(context), // Show dialog on press
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFF84545).withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout,
              size: 24,
              color: Color(0xFFF84545),
            ),
          ),
        ),
        SizedBox(width: 12), // Space between icon and text
        Text(
          'تسجيل الخروج',
          style: TextStyle(
            color: Color(0xFF101010),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
