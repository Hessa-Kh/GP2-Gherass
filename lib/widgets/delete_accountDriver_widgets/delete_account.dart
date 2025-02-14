import 'package:flutter/material.dart';
class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const DeleteAccountDialog({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.8, // Adjust width to 80% of screen width
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(147, 96, 2, 0.20),
              blurRadius: 9,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(13, 45, 13, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'هل تريد حذف الحساب؟',
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 0.24,
                color: Color(0xFF101010),
              ),
              semanticsLabel: 'حذف الحساب',
            ),
            SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Make the "إلغاء" button have the same width as "نعم"
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12), // Adjust vertical padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(147, 96, 2, 0.20),
                            blurRadius: 9,
                          ),
                        ],
                      ),
                      child: Center( // Center the text inside the button
                        child: Text(
                          'إلغاء',
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 17), // Space between buttons
                // "نعم" button
                Expanded(
                  child: TextButton(
                    onPressed: onConfirm,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12), // Adjust vertical padding
                      decoration: BoxDecoration(
                        color: Color(0xFFFCB5B5),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(147, 96, 2, 0.20),
                            blurRadius: 9,
                          ),
                        ],
                      ),
                      child: Center( // Center the text inside the button
                        child: Text(
                          'نعم',
                          style: TextStyle(
                            fontSize: 20,
                            letterSpacing: 0.2,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccount extends StatelessWidget {
  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(
        onCancel: () {
          Navigator.pop(context); // Close the dialog on cancel
        },
        onConfirm: () {
          // Handle account deletion logic here
          // Example: delete the user account from Firebase, etc.

          Navigator.pop(context); // Close the dialog after deletion
          //print("Account Deleted"); // You can replace this with actual deletion logic
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => showDeleteConfirmationDialog(context), // Trigger the dialog on tap
      child: Text(
        'حذف الحساب',
        style: TextStyle(
          color: Color(0xFFF84545),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    
    );
  }
}
