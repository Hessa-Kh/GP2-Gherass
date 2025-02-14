import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Create an instance of GoogleSignIn
      GoogleSignIn googleSignIn = GoogleSignIn();

      // Trigger the Google Sign-In flow
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Get the authentication details from the GoogleSignInAccount
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the Google authentication details
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // You can access the user details here if needed
      User? user = userCredential.user;
      if (user != null) {
        // Proceed to your app's authenticated screen
        // For example, navigate to the home page
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      print("Error during Google sign-in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Color(0xFF828282),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'او سجل دخول باستخدام',
                  style: TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Color(0xFF828282),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => _signInWithGoogle(context), // Call the sign-in function when pressed
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(
                color: Color(0xFFBDBDBD),
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align everything to the left initially
              children: [
                // Use Center widget to make the text appear centered within the remaining space
                Text(
                  'Google',
                  style: TextStyle(
                    color: Color(0xFF4F4F4F),
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 100),
                Image.asset(
                  'assets/images/google_icon.png',
                  width: 18,
                  height: 18,
                ),
                // Optional: Add more space after the text
                SizedBox(width: 7), // Add space on the right
              ],
            ),
          ),
          const SizedBox(height: 89),
        ],
      ),
    );
  }
}
