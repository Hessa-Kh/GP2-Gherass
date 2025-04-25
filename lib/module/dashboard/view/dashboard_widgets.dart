import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/events/view/events_screen.dart';
import 'package:gherass/module/home/driver_home.dart';
import 'package:gherass/module/home/farmer_home.dart';
import 'package:gherass/module/inventory/view/inventory_screen.dart';
import 'package:gherass/module/home/home_view.dart';
import 'package:gherass/module/vehicle_info/view/vehicle_info_view.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../module/home/home_controller.dart';
import '../../../theme/app_theme.dart';
import '../../../util/image_util.dart';
import '../../../widgets/svg_icon_widget.dart';
import '../../book_events/view/book_event_screen.dart';
import '../../customer_orders/view/customer_orders_view.dart';
import '../../orders/view/orders_view.dart';
import '../../cart/view/my_cart_view.dart';
import '../../profile/view/profile_view.dart';

class DashboardWidgets {
  final HomeViewController controller = Get.put(HomeViewController());

  Widget dashboardNavBar(BuildContext context) {
    return PersistentTabView(
      context,
      controller: controller.tabController,
      screens: listOfScreens(),
      onItemSelected: (index) {},
      items: navBarItems(),
      backgroundColor: AppTheme.white,
      handleAndroidBackButtonPress: true,
      margin: EdgeInsets.all(20),
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(color: AppTheme.lightGray, blurRadius: 10),
        ],
      ),
      resizeToAvoidBottomInset: true,
      navBarStyle:
          NavBarStyle.style6, // Choose// the nav bar style with this property.
      navBarHeight: 70,
    );
  }

  List<Widget> listOfScreens() {
    if (controller.logInType.value.contains("farmer") == true) {
      return [
        FarmerHome(),
        InventoryScreen(),
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: OrdersView(showBackButton: false),
        ),
        EventsScreen(),
        ProfileView(),
      ];
    } else if (controller.logInType.value.contains("customer") == true) {
      return [
        HomeView(),
        MyCartScreen(showBackButton: false),
        BookedEventScreen(),
        CustomerOrdersView(),
        ProfileView(),
      ];
    } else {
      return [
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: DriverHome(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: OrdersView(showBackButton: false),
        ),
        VehicleInfoView(showBackButton: false),
        ProfileView(),
      ];
    }
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    if (controller.logInType.value.contains("farmer") == true) {
      return [
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(ImageUtil.home, color: AppTheme.navGrey),
          icon: const SvgIcon(ImageUtil.home, color: AppTheme.primaryColor),
          activeColorPrimary: AppTheme.primaryTextColor,
          activeColorSecondary: AppTheme.white,
          inactiveColorPrimary: Colors.grey[500],
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(
            ImageUtil.shop_add,
            color: AppTheme.navGrey,
          ),
          icon: const SvgIcon(ImageUtil.shop_add, color: AppTheme.primaryColor),
          activeColorPrimary: AppTheme.primaryTextColor,
          activeColorSecondary: AppTheme.white,
          inactiveColorPrimary: Colors.grey[500],
        ),
        PersistentBottomNavBarItem(
          icon: const SvgIcon(ImageUtil.document, color: AppTheme.primaryColor),
          inactiveIcon: const SvgIcon(
            ImageUtil.document,
            color: AppTheme.navGrey,
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const SvgIcon(ImageUtil.calendar, color: AppTheme.primaryColor),
          inactiveIcon: const SvgIcon(
            ImageUtil.calendar,
            color: AppTheme.navGrey,
          ),
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(
            ImageUtil.profile,
            color: AppTheme.navGrey,
          ),
          icon: const SvgIcon(ImageUtil.profile, color: AppTheme.primaryColor),
        ),
      ];
    } else if (controller.logInType.value.contains("customer") == true) {
      return [
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(ImageUtil.home, color: AppTheme.navGrey),
          icon: const SvgIcon(ImageUtil.home, color: AppTheme.black),
          activeColorPrimary: AppTheme.primaryTextColor,
          activeColorSecondary: AppTheme.white,
          inactiveColorPrimary: Colors.grey[500],
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(ImageUtil.bag, color: AppTheme.navGrey),
          icon: const SvgIcon(ImageUtil.bag, color: AppTheme.black),
          activeColorPrimary: AppTheme.primaryTextColor,
          activeColorSecondary: AppTheme.white,
          inactiveColorPrimary: Colors.grey[500],
          onPressed: (v) {
            Get.toNamed(Routes.myCart);
          },
        ),
        PersistentBottomNavBarItem(
          icon: const SvgIcon(ImageUtil.calendar, color: AppTheme.primaryColor),
          inactiveIcon: const SvgIcon(
            ImageUtil.calendar,
            color: AppTheme.navGrey,
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const SvgIcon(ImageUtil.document, color: AppTheme.black),
          inactiveIcon: const SvgIcon(
            ImageUtil.document,
            color: AppTheme.navGrey,
          ),
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(
            ImageUtil.profile,
            color: AppTheme.navGrey,
          ),
          icon: const SvgIcon(ImageUtil.profile, color: AppTheme.black),
        ),
      ];
    } else {
      return [
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(ImageUtil.home, color: AppTheme.navGrey),
          icon: const SvgIcon(ImageUtil.home, color: AppTheme.black),
          activeColorPrimary: AppTheme.primaryTextColor,
          activeColorSecondary: AppTheme.white,
          inactiveColorPrimary: Colors.grey[500],
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(ImageUtil.box, color: AppTheme.navGrey),
          icon: const SvgIcon(ImageUtil.box, color: AppTheme.black),
          activeColorPrimary: AppTheme.primaryTextColor,
          activeColorSecondary: AppTheme.white,
          inactiveColorPrimary: Colors.grey[500],
        ),
        PersistentBottomNavBarItem(
          icon: const SvgIcon(ImageUtil.truck, color: AppTheme.black),
          inactiveIcon: const SvgIcon(ImageUtil.truck, color: AppTheme.navGrey),
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: const SvgIcon(
            ImageUtil.profile,
            color: AppTheme.navGrey,
          ),
          icon: const SvgIcon(ImageUtil.profile, color: AppTheme.black),
        ),
      ];
    }
  }
}
