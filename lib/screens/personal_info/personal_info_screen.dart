import 'package:flutter/material.dart';
import 'package:ghereass/widgets/personal_info/custom_text_field.dart';
import 'package:ghereass/widgets/personal_info/custom_button.dart';
import 'package:ghereass/screens/farm_info/farm_info_screen.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

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
                    children: [
                      const Text(
                        '9:41',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // لجعل الصورة في أقصى اليسار
                        children: [
                          Image.asset(
                            'lib/assets/gherass.png',
                            width: 180, // قلل الحجم إن لزم
                            height: 100,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment:
                            Alignment.centerLeft, // Aligns text to the left
                        child: Text(
                          'المعلومات الشخصية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: 'الأسم',
                        hint: 'اسمك الثلاثي',
                      ),
                      const SizedBox(height: 17),
                      CustomTextField(
                        label: 'رقم الهويه او الإقامه',
                        hint: 'رقم الهويه او الإقامه',
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'البريد الإلكتروني',
                        hint: 'بريدك الإلكتروني',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        label: 'رقم الجوال',
                        hint: 'رقم الجوال الخاص بك',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 23),
                      CustomTextField(
                        label: 'كلمه المرور',
                        hint: 'كلمه المرور',
                        isPassword: true,
                      ),
                      const SizedBox(height: 44),
                      CustomButton(
                        text: 'التالي',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FarmInfoScreen()),
                          );
                        },
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
