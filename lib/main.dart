import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gherass/module/add_product/view/add_product.dart';
import 'package:gherass/module/cart/view/delivery_location_screen.dart';
import 'package:gherass/module/createaccount/createaccount_view.dart';
import 'package:gherass/module/events/view/add_event_screen.dart';
import 'package:gherass/module/events/view/edit_event_screen.dart';
import 'package:gherass/module/inventory/view/farm_rating_screen.dart';
import 'package:gherass/module/orders/view/order_details_map_view.dart';
import 'package:gherass/module/promotions/view/promotion_screen.dart';
import 'package:gherass/module/inventory/view/staticstics_screen.dart';
import 'package:gherass/module/editprofile/view/edit_profile_view.dart';
import 'package:gherass/module/orders/view/orders_view.dart';
import 'package:gherass/module/products/view/product_details_view.dart';
import 'package:gherass/module/splash/view/splash_screen.dart';
import 'package:gherass/apiservice/dio_helper.dart';
import 'package:gherass/baseclass/basebinding.dart';
import 'package:gherass/firebase_options.dart';
import 'package:gherass/storage/storage_service.dart';
import 'package:gherass/theme/theme_service.dart';
import 'package:get/get.dart';
import 'package:gherass/util/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'module/customer_orders/view/customer_orders_view.dart';
import 'module/customer_orders/view/customer_order_details_view.dart';
import 'module/dashboard/view/dashboard_screen.dart';
import 'module/delivery_address/view/delivery_address_screen.dart';
import 'module/login/login_view.dart';
import 'module/cart/view/my_cart_view.dart';
import 'module/products/view/products_view.dart';
import 'module/promotions/view/add_promotions_screen.dart';
import 'module/promotions/view/edit_promotion_screen.dart';
import 'module/splash/view/login_type_selection_screen.dart';
import 'helper/routes.dart';
import 'helper/no_internet_page.dart';
import 'helper/notification.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale/locale_service.dart';
import 'module/track_orders/view/track_orders_view.dart';
import 'module/vehicle_info/view/vehicle_info_view.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();
  await initFirebase();
  await DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'gherass',
      debugShowCheckedModeBanner: false,
      locale: LocaleService.locale,
      initialBinding: BaseBinding(Constants.initialRouting),
      fallbackLocale: LocaleService.fallbackLocale,
      translations: LocaleService(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: const HomePage(),
      initialRoute: Routes.splash,
      builder: EasyLoading.init(),
      getPages: [
        GetPage(
          name: Routes.splash,
          page: () => SplashScreen(),
          binding: BaseBinding(Routes.splash),
        ),
        GetPage(
          name: Routes.login,
          page: () => LoginView(),
          binding: BaseBinding(Routes.login),
        ),
        GetPage(
          name: Routes.createaccount,
          page: () => CreateaccountView(),
          binding: BaseBinding(Routes.createaccount),
        ),
        GetPage(
          name: Routes.loginTypeSelectionScreen,
          page: () => LoginTypeSelectionScreen(),
          binding: BaseBinding(Routes.loginTypeSelectionScreen),
        ),
        GetPage(
          name: Routes.dashBoard,
          page: () => DashboardScreen(),
          binding: BaseBinding(Routes.dashBoard),
        ),
        GetPage(
          name: Routes.addProdForm,
          page: () => AddProduct(),
          binding: BaseBinding(Routes.addProdForm),
        ),
        GetPage(
          name: Routes.promotion,
          page: () => PromotionScreen(),
          binding: BaseBinding(Routes.promotion),
        ),
        GetPage(
          name: Routes.addPromotion,
          page: () => AddPromotionsScreen(),
          binding: BaseBinding(Routes.addPromotion),
        ),
        GetPage(
          name: Routes.editPromotion,
          page: () => EditPromotionScreen(),
          binding: BaseBinding(Routes.editPromotion),
        ),
        GetPage(
          name: Routes.salesStatistics,
          page: () => Staticstics(),
          binding: BaseBinding(Routes.salesStatistics),
        ),
        GetPage(
          name: Routes.farmRating,
          page: () => FarmRatingScreen(),
          binding: BaseBinding(Routes.farmRating),
        ),
        GetPage(
          name: Routes.dashBoard,
          page: () => DashboardScreen(),
          binding: BaseBinding(Routes.dashBoard),
        ),
        GetPage(
          name: Routes.editProfile,
          page: () => EditProfileView(),
          binding: BaseBinding(Routes.editProfile),
        ),
        GetPage(
          name: Routes.ordersPage,
          page: () => OrdersView(showBackButton: true),
          binding: BaseBinding(Routes.ordersPage),
        ),
        GetPage(
          name: Routes.productDetails,
          page: () => ProductDetailsPage(),
          binding: BaseBinding(Routes.productDetails),
        ),
        GetPage(
          name: Routes.myCart,
          page: () => MyCartScreen(showBackButton: true),
          binding: BaseBinding(Routes.myCart),
        ),
        GetPage(
          name: Routes.customerOrdersPage,
          page: () => CustomerOrdersView(),
          binding: BaseBinding(Routes.customerOrdersPage),
        ),
        GetPage(
          name: Routes.customerOrdersDetailPage,
          page: () => CustomerOrderDetailsView(),
          binding: BaseBinding(Routes.customerOrdersDetailPage),
        ),
        GetPage(
          name: Routes.trackOrdersPage,
          page: () => TrackOrdersView(),
          binding: BaseBinding(Routes.trackOrdersPage),
        ),
        GetPage(
          name: Routes.productPage,
          page: () => ProductPage(),
          binding: BaseBinding(Routes.productPage),
        ),
        GetPage(
          name: Routes.deliveryAddress,
          page: () => DeliveryAddressScreen(),
          binding: BaseBinding(Routes.deliveryAddress),
        ),
        GetPage(
          name: Routes.deliverylocation,
          page: () => DeliveryLocationScreen(),
          binding: BaseBinding(Routes.deliverylocation),
        ),
        GetPage(
          name: Routes.addEventPage,
          page: () => AddEventScreen(),
          binding: BaseBinding(Routes.addEventPage),
        ),
        GetPage(
          name: Routes.editEventPage,
          page: () => EditEventScreen(),
          binding: BaseBinding(Routes.editEventPage),
        ),
        GetPage(
          name: Routes.editEventPage,
          page: () => EditEventScreen(),
          binding: BaseBinding(Routes.editEventPage),
        ),
        GetPage(
          name: Routes.vehicleInfo,
          page: () => VehicleInfoView(),
          binding: BaseBinding(Routes.vehicleInfo),
        ),
        GetPage(
          name: Routes.orderDetailDriverPage,
          page: () => OrderDetailsMapView(),
          binding: BaseBinding(Routes.orderDetailDriverPage),
        ),
      ],
    );
  }
}

Future<void> initialConfig() async {
  // You can request multiple permissions at once.
  Map<Permission, PermissionStatus> statuses =
      await [
        Permission.location,
        Permission.storage,
        Permission.notification,
      ].request();
  await Get.putAsync(() => StorageService().init());
  Get.put<LocaleService>(LocaleService());
  Get.put<ThemeService>(ThemeService());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: NoInternetPage());
  }
}

initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  //await PushNotificationService().setupInteractedMessage();
  final firebaseMessaging = FCM();
  firebaseMessaging.setNotifications();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
}
