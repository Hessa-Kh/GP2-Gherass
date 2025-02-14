import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../../widgets/create_account_customer/form_input.dart';
import '../../widgets/create_account_customer/toggle_button.dart';
import 'dart:math' as math;

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String accountType = "حساب فردي";

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String? validateInput() {
    if (nameController.text.isEmpty) {
      return 'الرجاء إدخال اسمك';
    }
    RegExp nameRegExp = RegExp(r'^[a-zA-Zأ-ي\s]+$');
    if (!nameRegExp.hasMatch(nameController.text)) {
      return 'الرجاء إدخال اسم صحيح (أحرف فقط)';
    }

    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      return 'الرجاء إدخال بريد إلكتروني صحيح';
    }

    if (phoneController.text.isEmpty || phoneController.text.length != 10 || !phoneController.text.startsWith('05')) {
      return 'الرجاء إدخال رقم جوال صحيح (يجب أن يبدأ بـ 05 ويتكون من 10 أرقام)';
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      return 'الرجاء إدخال كلمة مرور قوية (6 حروف على الأقل)';
    }

    return null;
  }

  Future<bool> isEmailTaken(String email) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Customer')
          .where('c_email', isEqualTo: email)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking email in Firestore: $e');
      return false;
    }
  }

  Future<void> createAccount() async {
    String? validationMessage = validateInput();
    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    bool emailTakenFirestore = await isEmailTaken(emailController.text);
    if (emailTakenFirestore) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('البريد الإلكتروني هذا موجود في قاعدة البيانات.')),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String userId = userCredential.user?.uid ?? '';

      String hashedPassword = hashPassword(passwordController.text);

      CollectionReference customers = FirebaseFirestore.instance.collection('Customer');
      await customers.add({
        'c_name': nameController.text,
        'c_email': emailController.text,
        'PhoneNumber': phoneController.text,
        'c_password': hashedPassword,
        'accountType': accountType,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': userId,
        'orderHistory': [],
        'shoppingCart': 0,
        'address': '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إنشاء الحساب بنجاح!'))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: ClipPath(
                clipper: CustomBackgroundClipper(),
                child: Container(
                  width: 350,
                  height: 330,
                  decoration: BoxDecoration(
                    color: Color(0xFF6472D2),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: Transform.rotate(
                angle: -math.pi / 20,
                child: Image.network(
                  'https://cdn.builder.io/api/v1/image/assets/TEMP/9be8ac824b7c7599c1aee391a1ce54dae64a2668e09542ec1717f1810d8f8192',
                  width: 180,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 140),
                    FormInput(label: 'الأسم', placeholder: 'اسمك الثلاثي', controller: nameController),
                    FormInput(label: 'البريد الإلكتروني', placeholder: 'بريدك الإلكتروني', controller: emailController),
                    FormInput(label: 'رقم الجوال', placeholder: 'رقم الجوال الخاص بك', controller: phoneController),
                    FormInput(label: 'كلمه المرور', placeholder: 'كلمه المرور', isPassword: true, controller: passwordController),
                    SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ':يرجى تحديد نوع حسابك',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ToggleButton(
                      option1: 'حساب تجاري',
                      option2: 'حساب فردي',
                      onChanged: (selected) {
                        setState(() {
                          accountType = selected;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: createAccount,
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6472D2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'هل لديك حساب بالفعل؟',
                        style: TextStyle(
                          color: Color(0xFF6472D2),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.7, 0);
    path.quadraticBezierTo(size.width, size.height * 0, size.width, size.height * 0);
    path.quadraticBezierTo(size.width * 0.9, size.height, 0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
