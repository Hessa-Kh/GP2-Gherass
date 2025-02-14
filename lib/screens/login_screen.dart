import 'package:flutter/material.dart';
import '../widgets/Login_widgets/login_form.dart';
import '../widgets/Login_widgets/social_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Adjust the logo width based on the screen width
    double logoWidth =
        screenWidth * 0.5; // Make logo width smaller (50% of screen width)

    return Scaffold(
      backgroundColor:
          Colors.white, // Set the entire screen background to white
      body: SingleChildScrollView(
        child: Container(
          width: double
              .infinity, // Ensure this container takes the full screen width
          padding:
              EdgeInsets.zero, // Remove any padding to avoid unnecessary space
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.end, // Align everything to the right
            children: [
              // Container for the top section with background image and logo
              SizedBox(
                width: double.infinity, // Full screen width
                height: screenHeight *
                    0.35, // Take up 45% of the screen height (adjustable)
                child: Stack(
                  children: [
                    // Background image (instead of green background)
                    Positioned(
                      top: -120, // Move the background image up by 120 pixels
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Image.asset(
                        'assets/images/login_circle.png', // Background image
                        fit: BoxFit
                            .cover, // Make the background image cover the whole container
                      ),
                    ),
                    // Logo image (on top of the background)
                    Positioned(
                      top: 60, // Adjust the position of the logo
                      left: 20, // Move the logo to the left with a margin
                      child: Image.asset(
                        'assets/images/logo.png', // Logo image
                        width:
                            logoWidth, // Adjusted logo width for screen size (smaller logo)
                        fit: BoxFit
                            .contain, // Ensure the logo maintains aspect ratio
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 25), // Reduced space between the image and the form

              // The login form section (now closer to the logo)
              const LoginForm(),

              // Social login section
              const SocialLogin(),

              // Add space at the bottom (reduced space here too)
              const SizedBox(
                  height: 10), // Less space between the form and social login
            ],
          ),
        ),
      ),
    );
  }
}
