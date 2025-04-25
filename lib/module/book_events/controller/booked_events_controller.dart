import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';

import '../../../widgets/loader.dart';

class BookedEventsController extends BaseController {
  var bookedEvents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    getBookedEventsList();
    super.onInit();
  }

  void getBookedEventsList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchBookedEvents(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        bookedEvents.assignAll(response.cast<Map<String, dynamic>>());
      }
      print(bookedEvents);
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
}
