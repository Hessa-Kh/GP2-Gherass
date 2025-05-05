import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/theme/styles.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../theme/app_theme.dart';
import '../../../../util/image_util.dart';
import '../../controller/customer_orders_controller.dart';

class CustomerOrdersWidgets {
  var controller = Get.find<CustomerOrdersController>();

  Widget ordersListWidget(BuildContext context) {
    return Obx(() {
      if (controller.customerOrderList.isEmpty) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    controller.getCustomerOrderList();
                  },
                  child: Text(
                    "No Orders Available Try Again".tr,
                    style: Styles.boldTextView(18, Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          return controller.getCustomerOrderList();
        },
        child: ListView.builder(
          itemCount: controller.customerOrderList.length,
          itemBuilder: (context, index) {
            var order = controller.customerOrderList[index];
            return InkWell(
              onTap: () async {
                controller.setSelectedOrder(order, index);
                controller.getDetailsById("farmer", order["farmerId"]);
                controller.getDetailsById("driver", order["driverId"]);
                controller.getDetailsById("customer", order["customerId"]);
                Get.toNamed(Routes.customerOrdersDetailPage);
              },
              child: orderItem(order),
            );
          },
        ),
      );
    });
  }

  Widget orderItem(Map<String, dynamic> customerOrderList) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 25.0, top: 25.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerOrderList['farmerName'] ?? "No Name",
                  style: Styles.regularTextView(14, Color(0xff101010)),
                ),
                const SizedBox(height: 4),
                Text(
                  "${customerOrderList["deliveryDate"] ?? ""}, ${customerOrderList['time'] ?? ""}",
                  style: Styles.regularTextView(14, Color(0xff6A6A6A)),
                ),
                Text(
                  "Order:  #${customerOrderList["orderID"]}",
                  style: Styles.regularTextView(14, Color(0xff6A6A6A)),
                ),
              ],
            ),
            // Dynamic status badge
            Flexible(
              child: statusWidget(
                customerOrderList["isRejected"] == true
                    ? " Order Rejected"
                    : customerOrderList["status"],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusWidget(String status) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              controller.statusColors[status.toLowerCase()] ??
              Colors.grey[300]!,
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextScroll(
          status,
          mode: TextScrollMode.endless,
          velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
          delayBefore: const Duration(milliseconds: 500),
          numberOfReps: 2,
          pauseBetween: const Duration(milliseconds: 50),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          textAlign: TextAlign.right,
          selectable: true,
        ),
      ),
    );
  }

  Widget ordersDetailWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          customerInfo(),
          farmInfo(),
          controller.driverList.isNotEmpty ? driverInfo() : SizedBox.shrink(),
          controller.orderedProductList.isNotEmpty
              ? orderDetailInfo()
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget customerInfo() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 2.0,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Customer information:".tr,
                    style: Styles.boldTextView(13, AppTheme.black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.account_circle_outlined,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.customerList.isNotEmpty
                              ? controller.customerList[0]['username'] ?? ""
                              : "No Name",
                          style: Styles.boldTextView(13, AppTheme.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.phone_in_talk_outlined,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.customerList.isNotEmpty
                              ? controller.customerList[0]['phoneNumber'] ?? ""
                              : "No Phone Number".tr,
                          style: Styles.boldTextView(13, AppTheme.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.customerList.isNotEmpty
                                ? controller
                                        .customerList[0]['current_address']['address'] ??
                                    ""
                                : "No address".tr,
                            style: Styles.boldTextView(13, AppTheme.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget farmInfo() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 2.0,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Farm info:".tr,
                    style: Styles.boldTextView(13, AppTheme.black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.shopping_bag,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.farmList.isNotEmpty
                              ? controller.farmList.first['farmName'] ??
                                  "No Farm Name"
                              : "No Farm Name",
                          style: Styles.boldTextView(13, AppTheme.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.farmList.isNotEmpty
                                ? controller.farmList.first['farmLocation'] ??
                                    "No Farm Location".tr
                                : "No Farm Location".tr,
                            style: Styles.boldTextView(13, AppTheme.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget driverInfo() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 2.0,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Driver info:".tr,
                    style: Styles.boldTextView(13, AppTheme.black),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.account_circle_outlined,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          controller.driverList.first['name'] ?? "",
                          style: Styles.boldTextView(13, AppTheme.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.navGrey,
                          radius: 12,
                          child: Icon(
                            Icons.phone_in_talk_outlined,
                            color: AppTheme.white,
                            size: 18,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.driverList.first['phoneNumber'] ?? "",
                            style: Styles.boldTextView(13, AppTheme.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderDetailInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!,
              blurRadius: 2.0,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order details:".tr,
                  style: Styles.boldTextView(13, AppTheme.black),
                ),
                if (controller.selectedOrder["isRejected"] == false) ...[
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.trackOrdersPage,
                          arguments: [controller.selectedOrder["orderID"]],
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Background color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: Text("TRACK ORDER".tr),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 10),
            Obx(
              () =>
                  controller.orderedProductList.isEmpty
                      ? Text("No products available")
                      : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.orderedProductList.length,
                        itemBuilder: (context, index) {
                          return orderedItems(index);
                        },
                      ),
            ),
            SizedBox(height: 10),
            Text(
              "Total Amount:".tr,
              style: Styles.boldTextView(13, AppTheme.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.navGrey,
                    radius: 12,
                    child: Icon(Icons.money, color: AppTheme.white, size: 18),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${controller.selectedOrder['totalAmount'] ?? ""}",
                    style: Styles.boldTextView(13, AppTheme.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Expected delivery date:".tr,
              style: Styles.boldTextView(13, AppTheme.black),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.navGrey,
                    radius: 12,
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: AppTheme.white,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${controller.selectedOrder['deliveryDate'] ?? ""}",
                    style: Styles.boldTextView(13, AppTheme.black),
                  ),
                ],
              ),
            ),
            Text("Status:".tr, style: Styles.boldTextView(13, AppTheme.black)),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.navGrey,
                    radius: 12,
                    child: Icon(
                      Icons.card_travel,
                      color: AppTheme.white,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${controller.selectedOrder['status'] ?? ""}",
                    style: Styles.boldTextView(13, AppTheme.black),
                  ),
                ],
              ),
            ),
            Text(
              "Order:  #${controller.selectedOrder["orderID"]}",
              style: Styles.regularTextView(14, Color(0xff6A6A6A)),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderedItems(int index) {
    var product = controller.orderedProductList[index];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Obx(()=>Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: controller.getProductImage(product["productId"]).value.isNotEmpty
                ? Image.memory(
              base64Decode(
                controller.getProductImage(product["productId"]).toString(),
              ),
              height: 20,
              width: 20,
            ): Icon(
                  Icons.image_not_supported,
                  size: 30,
                  color: Colors.grey,
                ),
          ),
          SizedBox(width: 10),

          Expanded(
            flex: 3,
            child: Text(
              product["name"]?.toString() ?? "No Name",
              style: Styles.boldTextView(13, AppTheme.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              "${product["qty"] ?? "0"} kg",
              style: Styles.boldTextView(13, AppTheme.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 2,
            child: Text(
              "${product["price"] ?? "0"} SAR",
              style: Styles.boldTextView(13, AppTheme.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      )),
    );
  }
}
