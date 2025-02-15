import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,  
      child: ElevatedButton(
        onPressed: () {
         
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6472D2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'إضافة عرض',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
            color: Colors.white,  
          ),
        ),
      ),
    );
  }
}
