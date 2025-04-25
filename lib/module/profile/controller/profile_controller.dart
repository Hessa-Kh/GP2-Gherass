
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';

class ProfileController extends BaseController {
  RxString logInType = "".obs;
  RxString userName = "".obs;
  RxString phoneNumber = "".obs;
  RxString farmName = "".obs;
  RxString farmLogo = "".obs;
  RxString location = "".obs;
  @override
  void onInit() {
    super.onInit();
    logInType.value = BaseController.storageService.getLogInType();
    getData();
  }

  getData() async {
    final results = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      logInType.value,
    );
    userName.value = results?["username"] ?? "";
    phoneNumber.value = results?["phoneNumber"] ?? "";
    farmName.value = results?["farmName"] ?? "";
    location.value = results?["location"] ?? "";
    farmLogo.value = results?["farm_logo"] ?? "";
  }
}
