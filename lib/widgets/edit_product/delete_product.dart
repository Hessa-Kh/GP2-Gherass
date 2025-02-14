import 'package:flutter/material.dart';

class DeleteProductButton extends StatelessWidget {
  const DeleteProductButton({super.key});

  void _deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,  // Same width as ProductNameCard
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
                  'تأكيد الحذف',
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0.24,
                    color: Color(0xFF101010),
                  ),
                  semanticsLabel: 'تأكيد الحذف',
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(147, 96, 2, 0.20),
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCB5B5),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(147, 96, 2, 0.20),
                                blurRadius: 9,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'حذف',
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,  // Same width as ProductNameCard
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFFCB5B5),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(147, 96, 2, 0.20),
            blurRadius: 6,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => _deleteProduct(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/trash.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: const Text(
                  'حذف المنتج',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEA4335),
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
}
