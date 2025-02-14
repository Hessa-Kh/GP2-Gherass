import 'package:flutter/material.dart';
import '../../widgets/edit_event_widgets/action_buttons.dart';
import '../../widgets/edit_event_widgets/delete_event_button.dart';
import '../../widgets/edit_event_widgets/time_displays.dart';


class EditEventStyles {
  static const backgroundColor = Colors.white;
  static const primaryTextColor = Color(0xFF101010);
  static const secondaryTextColor = Color(0xFF797D82);
  static const deleteButtonColor = Color(0xFFFCB5B5);
  static const deleteTextColor = Color(0xFFEA4335);
  static const editButtonColor = Color(0xFF6472D2);
  static const shadowColor = Color.fromRGBO(147, 96, 2, 0.2);
}

Widget _buildRow(String text, String imagePath) {
  return Container(
    width: 349,
    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 70),
    decoration: BoxDecoration(
      color: const Color(0xFFEBE8E2),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(147, 96, 2, 0.2),
          blurRadius: 9,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the left
      children: [
        // Removed the padding to push the image more to the left
        Image.asset(
          imagePath, // Path to your image
          width: 20, // Adjust the size of the image
          height: 20,
        ),
        SizedBox(width: 10), // Space between the image and the text
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: const Color(0xFF797D82),
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}

class EditEventScreen extends StatelessWidget {
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

  const EditEventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
        ),
        padding: EdgeInsets.fromLTRB(44, 23, 44, 68),
        child: SingleChildScrollView( // ✅ Wrap Column inside this
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Text(
                    '9:41',
                    style: TextStyle(
                      color: const Color(0xFF101010),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 21),
              Text(
                'تعديل الحدث',
                style: TextStyle(
                  color: const Color(0xFF101010),
                  fontSize: 20,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(height: 20),
              _buildRow('احصد ثمارك بنفسك', 'assets/images/edit-2.png'),
              SizedBox(height: 20),
              _buildRow('احصد ثمارك بنفسك', 'assets/images/edit-2.png'),
              SizedBox(height: 20),
              _buildRow('احصد ثمارك بنفسك', 'assets/images/edit-2.png'),
              SizedBox(height: 20),
              _buildRow('احصد ثمارك بنفسك', 'assets/images/edit-2.png'),
              SizedBox(height: 20),
              _buildRow('احصد ثمارك بنفسك', 'assets/images/edit-2.png'),
              SizedBox(height: 40),
              Container(
                width: 349,
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 70),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCB5B5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(147, 96, 2, 0.2),
                      blurRadius: 9,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10), // Moves image slightly left
                      child: Image.asset(
                        'assets/images/trash.png', // Path to your image
                        width: 20, // Adjust image size
                        height: 20,
                      ),
                    ),
                    SizedBox(width: 10), // Space between image and text
                    GestureDetector(
                      onTap: () => showDeleteConfirmationDialog(context), // Open delete dialog
                      child: Text(
                        'حذف الحدث',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFEA4335),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 93),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 55),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(147, 96, 2, 0.2),
                            blurRadius: 9,
                          ),
                        ],
                      ),
                      child: Text(
                        'إلغاء',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF797D82),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 59),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6472D2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(147, 96, 2, 0.2),
                            blurRadius: 9,
                          ),
                        ],
                      ),
                      child: Text(
                        'تعديل',
                        textAlign: TextAlign.center,
                        softWrap: false, // Prevents breaking into multiple lines
                        overflow: TextOverflow.visible, // Ensures text doesn't get cut off
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
