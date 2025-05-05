import 'package:get/get.dart';
import 'package:gherass/apiservice/firebase_helper.dart';
import 'package:gherass/module/add_product/controller/add_prod_controller.dart';
import 'package:gherass/module/book_events/controller/booked_events_controller.dart';
import 'package:gherass/module/events/controller/event_controller.dart';
import 'package:gherass/module/inventory/controller/inventory_controller.dart';
import 'package:gherass/module/createaccount/createaccount_controller.dart';
import 'package:gherass/module/editprofile/controller/edit_profile_controller.dart';
import 'package:gherass/module/login/login_controller.dart';
import 'package:gherass/module/orders/controller/orders_controller.dart';
import 'package:gherass/module/products/controller/product_contoller.dart';
import 'package:gherass/module/promotions/controller/promotions_contoller.dart';

import '../module/customer_orders/controller/customer_orders_controller.dart';
import '../module/dashboard/controller/dashboard_controller.dart';
import '../module/delivery_address/controller/delivery_address_controller.dart';
import '../module/home/home_controller.dart';
import '../module/cart/controller/my_cart_controller.dart';
import '../module/orders/controller/order_detail_map_controller.dart';
import '../module/profile/controller/profile_controller.dart';
import '../module/splash/controller/splash_controller.dart';
import '../apiservice/dio_api.dart';
import '../helper/routes.dart';
import '../locale/locale_service.dart';
import '../module/track_orders/controller/order_track_controller.dart';
import '../module/track_orders/controller/orders_timer_controller.dart';
import '../module/vehicle_info/controller/vehicle_info_controller.dart';
import '../util/constants.dart';
import 'basecontroller.dart';

class BaseBinding extends Bindings {
  final String type;

  BaseBinding(this.type);

  @override
  void dependencies() {
    switch (type) {
      case Constants.initialRouting:
        _initialRoutingDependencies();
        break;
      case Routes.splash:
      case Routes.loginTypeSelectionScreen:
        Get.lazyPut<SplashController>(() => SplashController());
        break;
      case Routes.login:
        Get.lazyPut<LoginController>(() => LoginController());
        break;
      case Routes.createaccount:
        Get.lazyPut<CreateaccountController>(() => CreateaccountController());
        break;
      case Routes.editProfile:
        Get.lazyPut<EditProfileController>(() => EditProfileController());
        break;
      case Routes.dashBoard:
        Get.lazyPut<DashboardController>(() => DashboardController());
        Get.lazyPut<HomeViewController>(() => HomeViewController());
        Get.lazyPut<MyCartController>(() => MyCartController());
        Get.lazyPut<ProfileController>(() => ProfileController());
        Get.lazyPut<InventoryController>(() => InventoryController());
        Get.lazyPut<PromotionsController>(() => PromotionsController());
        Get.lazyPut<EventController>(() => EventController());
        Get.lazyPut<ProductController>(() => ProductController());
        Get.lazyPut<CustomerOrdersController>(() => CustomerOrdersController());
        Get.lazyPut<OrdersController>(() => OrdersController());
        Get.lazyPut<ProductController>(() => ProductController());
        Get.lazyPut<BookedEventsController>(() => BookedEventsController());
        Get.lazyPut<DeliveryAddressController>(
          () => DeliveryAddressController(),
        );
        Get.lazyPut<VehicleInfoController>(() => VehicleInfoController());
        break;
      case Routes.addProdForm:
        Get.lazyPut<AddProdController>(() => AddProdController());
        Get.lazyPut<ProductController>(() => ProductController());
        Get.lazyPut<InventoryController>(() => InventoryController());
        break;
      case Routes.salesStatistics:
      case Routes.farmRating:
      case Routes.promotion:
        Get.lazyPut<InventoryController>(() => InventoryController());
        Get.lazyPut<AddProdController>(() => AddProdController());
        Get.lazyPut<OrdersController>(() => OrdersController());
        Get.lazyPut<ProductController>(() => ProductController());
        Get.lazyPut<PromotionsController>(() => PromotionsController());
        Get.lazyPut<MyCartController>(() => MyCartController());
        break;
      case Routes.addPromotion:
        Get.lazyPut<InventoryController>(() => InventoryController());
        Get.lazyPut<PromotionsController>(() => PromotionsController());
        break;
      case Routes.editPromotion:
        Get.lazyPut<InventoryController>(() => InventoryController());
        Get.lazyPut<PromotionsController>(() => PromotionsController());
        break;
      case Routes.ordersPage:
        Get.lazyPut<OrdersController>(() => OrdersController());
        Get.lazyPut<MyCartController>(() => MyCartController());
        break;
      case Routes.customerOrdersPage:
      case Routes.customerOrdersDetailPage:
        Get.lazyPut<CustomerOrdersController>(() => CustomerOrdersController());
        Get.lazyPut<MyCartController>(() => MyCartController());

        break;
      case Routes.trackOrdersPage:
        Get.lazyPut<OrdersTimerController>(() => OrdersTimerController());
        Get.lazyPut<OrderTrackController>(() => OrderTrackController());
        Get.lazyPut<MyCartController>(() => MyCartController());

        break;
      case Routes.productDetails:
        Get.lazyPut<ProductController>(() => ProductController());

        break;
      case Routes.productPage:
        Get.lazyPut<ProductController>(() => ProductController());

        break;
      case Routes.myCart:
        Get.lazyPut<MyCartController>(() => MyCartController());
        break;
      case Routes.countDownTimer:
        Get.lazyPut<OrdersTimerController>(() => OrdersTimerController());
        break;
      case Routes.deliveryAddress:
        Get.lazyPut<DeliveryAddressController>(
          () => DeliveryAddressController(),
        );

        break;
      case Routes.deliverylocation:
        Get.lazyPut<DeliveryAddressController>(
          () => DeliveryAddressController(),
        );

        break;
      case Routes.addEventPage:
        Get.lazyPut<EventController>(() => EventController());
        break;
      case Routes.editEventPage:
        Get.lazyPut<EventController>(() => EventController());
        break;
      case Routes.vehicleInfo:
        Get.lazyPut<VehicleInfoController>(() => VehicleInfoController());
      case Routes.orderDetailDriverPage:
        Get.lazyPut(() => OrderDetailMapController());

        break;
      default:
        throw Exception('Unknown route: $type');
    }
  }

  void _initialRoutingDependencies() {
    Get.lazyPut<BaseController>(() => BaseController());
    Get.lazyPut<LocaleService>(() => LocaleService());
    Get.lazyPut<SplashController>(() => SplashController());
    Get.put(FirebaseHelper(), permanent: true);
    Get.put(DioApi(), permanent: true);
  }
}
