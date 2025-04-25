import 'dart:convert';
import 'dart:developer' as devtools;
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gherass/module/orders/view/orders_view.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../baseclass/basecontroller.dart';
import '../module/customer_orders/controller/customer_orders_controller.dart';
import '../module/customer_orders/view/customer_order_details_view.dart';
import '../module/orders/controller/orders_controller.dart';
import '../storage/storage_service.dart';
import '../util/constants.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;
  StorageService storageService = StorageService();

  Future<bool> sendFcm(
    String token,
    String title,
    String body,
    dynamic data,
  ) async {
    final jsonCredentials = await rootBundle.loadString('assets/fcm_key.json');
    final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

    final client = await auth.clientViaServiceAccount(creds, [
      'https://www.googleapis.com/auth/cloud-platform',
    ]);

    const String senderId = '351272618438';

    var payload = {};

    if (Platform.isAndroid) {
      payload = {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "data": data,
        },
      };
    } else {
      payload = {
        "message": {
          "token": token,
          "notification": {"title": title, "body": body},
          "data": data,
        },
      };
    }

    final response = await client.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$senderId/messages:send',
      ),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(payload),
    );

    client.close();
    if (response.statusCode == 200) {
      return true;
    }

    devtools.log(
      'Notification Sending Error Response status: ${response.statusCode}',
    );
    devtools.log('Notification Response body: ${response.body}');
    return false;
  }

  setNotifications() async {
    print("setNotifications");
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Get.snackbar(
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        onTap: (_) async {
          final orderId = message.data["orderID"]?.toString() ?? "";
          if (orderId.isEmpty) {
            print("notification Error: Order ID is empty or null");
            return;
          }

          final ordersData = await BaseController.firebaseAuth
              .fetchOrderDetailsById(orderId);

          if (ordersData == null) {
            print(
              "notification Error: No order details found for ID: $orderId",
            );
            return;
          }

          if (BaseController.storageService.getLogInType() == "customer") {
            print("notification customer data: $ordersData");
            var controller = Get.find<CustomerOrdersController>();
            controller.navigateToDetail(ordersData);
            Get.to(CustomerOrderDetailsView());
          } else {
            print("notification others data: $ordersData");
            var controller = Get.put(OrdersController());
            controller.navigateToDetailsPage(ordersData);
            Get.to(OrdersView(showBackButton: false));
          }
        },
      );
    });

    _firebaseMessaging.getToken().then((value) {
      StorageService storageService = StorageService();
      storageService.write(Constants.fcmToken, value);
    });

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await BaseController.firebaseAuth.logout();
      StorageService storageService = StorageService();
      storageService.write(Constants.fcmToken, newToken);
    });
  }

  Future<void> registerNotificationListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      Get.snackbar(
        message?.notification?.title ?? "No Title",
        message?.notification?.body ?? "No Body",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
        onTap: (_) async {},
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Get.snackbar(
        message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    });
  }
}
