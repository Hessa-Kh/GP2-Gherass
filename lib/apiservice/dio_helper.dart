import 'package:dio/dio.dart';
import '../util/constants.dart';

class DioHelper {
  static Dio? dio;
  static String? cookies;

  static Future init() async {
    // var cookieJar = await getCookiePath();
    dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
      ),
    );
  }

  static Future initCookies() async {
    // cookies = await getCookies();
  }

  // static Future<PersistCookieJar> getCookiePath() async {
  //   Directory appDocDir = await getApplicationSupportDirectory();
  //   String appDocPath = appDocDir.path;
  //   return PersistCookieJar(
  //       ignoreExpires: true, storage: FileStorage(appDocPath));
  // }
  //
  // static Future<String?> getCookies() async {
  //   var baseUrl = GetStorage().read(Constants.baseUrl)??"";
  //   var cookieJar = await getCookiePath();
  //   var cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
  //
  //   var cookie = CookieManager.getCookies(cookies);
  //   return cookie;
  //
  // }
}
