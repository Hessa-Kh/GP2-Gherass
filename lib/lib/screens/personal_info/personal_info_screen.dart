import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ghereass/widgets/personal_info/custom_text_field.dart';
import 'package:ghereass/widgets/personal_info/custom_button.dart';
import 'package:ghereass/screens/farm_info/farm_info_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to save data to Firestore
  Future<void> saveUserInfo() async {
    try {
      await FirebaseFirestore.instance.collection('users').add({
        'name': nameController.text,
        'id': idController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'password': passwordController.text, // ⚠️ Don't store plain passwords in real apps!
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );

      // Navigate to Farm Info Screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FarmInfoScreen()),
      );
    } catch (e) {
      print("Error saving data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save data!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(60),
        ),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(38, 27, 80, 40),
                  decoration: const BoxDecoration(
                    color: Color(0xFF93C249),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(200),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        'المعلومات الشخصية',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'الأسم',
                        hint: 'اسمك الثلاثي',
                        controller: nameController,
                      ),
                      const SizedBox(height: 17),
                      CustomTextField(
                        label: 'رقم الهوية أو الإقامة',
                        hint: 'رقم الهوية أو الإقامة',
                        controller: idController,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'بريدك الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        label: 'رقم الجوال',
                        hint: 'رقم الجوال الخاص بك',
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                      ),
                      const SizedBox(height: 23),
                      CustomTextField(
                        label: 'كلمة المرور',
                        hint: 'كلمة المرور',
                        isPassword: true,
                        controller: passwordController,
                      ),
                      const SizedBox(height: 44),
                      CustomButton(
                        text: 'التالي',
                        onPressed: saveUserInfo,
                      ),
                      const SizedBox(height: 78),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
