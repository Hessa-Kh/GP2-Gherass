import 'package:flutter/material.dart';

class EditCancelButtons extends StatelessWidget {
  const EditCancelButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space buttons equally
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
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
                    color: Color.fromRGBO(121, 125, 130, 1),
                    fontSize: 18,
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
                onPressed: () => _showEditDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(100, 114, 210, 1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 9,
                  shadowColor: const Color.fromRGBO(147, 96, 2, 0.2),
                ),
                child: const Text(
                  'تأكيد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                    letterSpacing: 0.16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return LogoutDialog(
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}

class LogoutDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: screenWidth * 0.8,
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
            const Text(
              'تأكيد التعديل',
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 0.24,
                color: Color(0xFF101010),
              ),
              semanticsLabel: 'تأكيد التعديل',
            ),
            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: onCancel,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                      child: const Center(
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
                const SizedBox(width: 17),
                Expanded(
                  child: TextButton(
                    onPressed: onConfirm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                      child: const Center(
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
