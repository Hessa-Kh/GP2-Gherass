import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/apiservice/dio_api.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/storage/storage_service.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/widgets/loader.dart';

class LoginController extends BaseController {
  // final formKey = GlobalKey<FormBuilderState>();
  // final forgotPswdFormKey = GlobalKey<FormBuilderState>();
  StorageService storageService = StorageService();
  var loginUser = "".obs;
  var isPasswordVisible = false.obs;
  var appVersion = "".obs;
  var obscureText = true.obs;

  var usernameError = ''.obs;
  var passwordError = ''.obs;

  var storage = Get.find<StorageService>();

  DioApi api = DioApi();

  var userNameTextfield = TextEditingController();
  var passwordTextfield = TextEditingController();
  var forgotPassword = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    print('logInType:${BaseController.logInType.value}');
    getData();
  }

  bool validate() {
    bool isValid = true;

    if (userNameTextfield.text.isEmpty) {
      usernameError.value = 'please enter valid email address'.tr;
      isValid = false;
    } else {
      usernameError.value = '';
    }

    if (passwordTextfield.text.isEmpty) {
      passwordError.value = 'Please enter password'.tr;
      isValid = false;
    } else {
      passwordError.value = '';
    }
    return isValid;
  }

  getData() async {
    numberFormating();
  }

  String numberFormating() {
    final number =
        (passwordTextfield.text.isEmpty) ? "XXXXXXXXX" : passwordTextfield.text;
    final result =
        (passwordTextfield.text.isEmpty || passwordTextfield.text.length < 9)
            ? "XX"
            : number.substring(7, 9);
    return result;
  }

  loginAuthentication(BuildContext context) async {
    try {
      var email = userNameTextfield.text.trim();
      var password = passwordTextfield.text.trim();

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          "Error",
          "Email or password cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
        return;
      }

      // No loader here — loader now shows only on real login success
      await BaseController.firebaseAuth.login(email: email, password: password);
    } catch (e) {
      // Loader is stopped inside login() now, so no need to stop here
      print("Login error: $e");
    }
  }

  updateLoginFcmToken() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      await BaseController.firebaseAuth.loginFcmUpdate(
        BaseController.storageService.getLogInType().toString(),
        BaseController.firebaseAuth.getUid(),
        storageService.getFcmToken(),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "something went wrong !",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      print("Login error: $e");

      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  @override
  void dispose() {
    userNameTextfield.dispose();
    passwordTextfield.dispose();
    super.dispose();
  }
}
