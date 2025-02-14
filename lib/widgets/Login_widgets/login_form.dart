import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loginUser() async {
    try {
      // Sign in with Firebase Authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Fetch user data from Firestore based on email
      User? user = userCredential.user;
      if (user != null) {
        String email = user.email!;
        
        // Check if the user is in the customer, farmer, or driver collection
        DocumentSnapshot customerDoc = await _firestore.collection('customer').doc(email).get();
        DocumentSnapshot farmerDoc = await _firestore.collection('farmer').doc(email).get();
        DocumentSnapshot driverDoc = await _firestore.collection('driver').doc(email).get();

        if (customerDoc.exists) {
          Map<String, dynamic> customerData = customerDoc.data() as Map<String, dynamic>;
          // Handle customer login
          Navigator.pushReplacementNamed(context, '/customerHome');
        } else if (farmerDoc.exists) {
          Map<String, dynamic> farmerData = farmerDoc.data() as Map<String, dynamic>;
          // Handle farmer login
          Navigator.pushReplacementNamed(context, '/farmerHome');
        } else if (driverDoc.exists) {
          Map<String, dynamic> driverData = driverDoc.data() as Map<String, dynamic>;
          // Handle driver login
          Navigator.pushReplacementNamed(context, '/driverHome');
        } else {
          // If the email is not found in any collection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No account found for this email.")),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message ?? 'Error logging in';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'البريد لإلكتروني أو رقم الجوال',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 13),
            TextFormField(
              controller: _emailController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                hintText: 'البريد لإلكتروني أو رقم الجوال الخاص بك',
                hintStyle: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 17,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال بريدك الإلكتروني';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            Text(
              'كلمه المرور',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF2F2F2),
                hintText: 'كلمه المرور',
                hintStyle: TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 18,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Color(0xFFBDBDBD),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كلمة المرور';
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'نسيت كلمه المرور؟',
                style: TextStyle(
                  color: Color(0xFF93C249),
                  fontSize: 12,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _loginUser(); // Perform the login
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF93C249),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 17),
                minimumSize: const Size(double.infinity, 0),
              ),
              child: Text(
                'تسجيل دخول',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 27),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ليس لديك حساب؟',
                    style: TextStyle(
                      color: Color(0xFF93C249),
                      fontSize: 15,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'تسجيل',
                      style: TextStyle(
                        color: Color(0xFF93C249),
                        fontSize: 15,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
