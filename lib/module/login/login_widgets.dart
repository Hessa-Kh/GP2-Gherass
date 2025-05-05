import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/theme/styles.dart';
import '../../helper/routes.dart';
import '../../theme/app_theme.dart';
import 'login_controller.dart';

class LoginWidgets {
  var controller = Get.find<LoginController>();

  Widget loginWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Email address".tr,
            style: Styles.boldTextView(14, Colors.black),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller.userNameTextfield,
            decoration: InputDecoration(
              fillColor: AppTheme.hintBgColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              errorText:
                  controller.usernameError.value.isNotEmpty
                      ? controller.usernameError.value
                      : null,
              hintText: "Email address".tr,
            ),
          ),
          SizedBox(height: 20),
          Text("Password".tr, style: Styles.boldTextView(14, Colors.black)),
          SizedBox(height: 5),
          TextField(
            obscureText: !controller.isPasswordVisible.value,
            controller: controller.passwordTextfield,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppTheme.hintBgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  controller.isPasswordVisible.value =
                      !controller.isPasswordVisible.value;
                },
              ),
              errorText:
                  controller.passwordError.value.isNotEmpty
                      ? controller.passwordError.value
                      : null,
              hintText: "Password".tr,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await controller.loginAuthentication(context);
                await controller.updateLoginFcmToken();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: Text("Log in".tr, style: TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: !BaseController.logInType.value.contains("driver"),
            child: InkWell(
              onTap: () {
                if (BaseController.logInType.value.contains("farmer") == true) {
                  Get.toNamed(Routes.createaccount, arguments: [""]);
                } else {
                  Get.toNamed(Routes.createaccount, arguments: ["customer"]);
                }
              },
              child: Center(
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ".tr,
                    style: Styles.regularTextView(12, AppTheme.primaryColor),
                    children: [
                      TextSpan(
                        text: "Sign up".tr,
                        style: TextStyle(color: AppTheme.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Row(
          //   children: [
          //     Expanded(
          //         child: Divider(
          //       color: AppTheme.black,
          //     )),
          //     Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: Text("Or continue with".tr),
          //     ),
          //     Expanded(
          //         child: Divider(
          //       color: AppTheme.black,
          //     )),
          //   ],
          // ),
          SizedBox(height: 10),
          // Container(
          //   height: 40,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(color: AppTheme.hintDarkGray)),
          //   child: Row(
          //     children: [
          //       SizedBox(
          //         width: 20,
          //       ),
          //       Image.asset(
          //         ImageUtil.googleLogo,
          //         height: 18,
          //         width: 18,
          //       ),
          //       Spacer(
          //         flex: 2,
          //       ),
          //       Text("Google".tr),
          //       Spacer(
          //         flex: 3,
          //       ),
          //     ],
          //   ),
          // ),
          // ElevatedButton.icon(
          //   onPressed: () {},
          //   icon:
          //   label: ,
          //   style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
          // )
        ],
      ),
    );
  }
}
