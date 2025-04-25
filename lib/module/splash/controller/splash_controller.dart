import 'package:get/get.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../helper/routes.dart';

class SplashController extends BaseController {
  @override
  void onInit() {
    isLoggedIn();
    super.onInit();
  }

  bool getIsLogin() {
    bool? isLogin = BaseController.storageService.getIsLogin();
    if (isLogin == "null") {
      return false;
    }
    return isLogin;
  }

  isLoggedIn() async {
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (getIsLogin()) {
        Get.offAllNamed(Routes.dashBoard);
      } else {
        Get.toNamed(Routes.loginTypeSelectionScreen);
      }
    });
  }
}
