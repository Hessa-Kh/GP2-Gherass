import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/orders/controller/orders_controller.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/constants.dart';
import 'package:gherass/widgets/svg_icon_widget.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../helper/routes.dart';
import '../../../theme/app_theme.dart';
import '../../../util/image_util.dart';

class OrdersWidgets {
  var controller = Get.find<OrdersController>();

  Widget ordersListWidget(BuildContext context) {
    return controller.logInType.value.contains("farmer")
        ? controller.ordersList.isEmpty
            ? Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "No Orders Available".tr,
                  style: Styles.boldTextView(25, AppTheme.black),
                ),
              ),
            )
            : ListView.builder(
              //customer orders
              itemCount: controller.ordersList.length ?? 0,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    controller.navigateToDetailsPage(
                      controller.ordersList[index],
                    );
                  },
                  child: farmerOrderItem(index),
                );
              },
            )
        : controller.logInType.value.contains("driver")
        ? Obx(
          () =>
              controller.ordersList.isNotEmpty
                  ? ListView.builder(
                    itemCount: controller.ordersList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          controller.navigateToDetailsPage(
                            controller.ordersList[index],
                          );
                        },
                        child: driverOrderItem(index),
                      );
                    },
                  )
                  : Container(),
        )
        : ListView.builder(
          itemCount: controller.ordersList.length ?? 0,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                controller.navigateToDetailsPage(controller.ordersList[index]);
              },
              child: driverOrderItem(index),
            );
          },
        );
  }

  Widget farmerOrderItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customRow(
                      title: "Order number:".tr,
                      subTitle:
                          " ${controller.ordersList[index]["orderID"].toString()}",
                    ),
                    customRow(
                      title: "Address:".tr,
                      subTitle:
                          " ${controller.ordersList[index]["delivery_address"]["address"].toString()}",
                    ),
                    customRow(
                      title: "Date:".tr,
                      subTitle:
                          " ${controller.covertDateFormat(controller.ordersList[index]["date"])[0]}",
                    ),
                    customRow(
                      title: "Time:".tr,
                      subTitle:
                          " ${controller.covertDateFormat(controller.ordersList[index]["date"])[1]}",
                    ),
                    customRow(
                      title: "Status:".tr,
                      subTitle:
                          controller.ordersList[index]["isRejected"] == true
                              ? " Order Rejected"
                              : " ${controller.ordersList[index]["status"]}",
                    ),
                  ],
                ),
                Flexible(child: SvgIcon(ImageUtil.note, size: 45)),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: InkWell(
                onTap: () {
                  controller.navigateToDetailsPage(
                    controller.ordersList[index],
                  );
                },
                child: Container(
                  width: 115,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      "View Details ".tr,
                      style: Styles.boldTextView(14, AppTheme.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget driverOrderItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customRow(
                  title: "Order number:".tr,
                  subTitle:
                      " #${controller.ordersList[index]["orderID"].toString()}",
                ),
                customRow(
                  title: "Address:".tr,
                  subTitle:
                      " ${controller.ordersList[index]["delivery_address"]["address"].toString()}",
                ),
                customRow(
                  title: "Date:".tr,
                  subTitle:
                      " ${controller.covertDateFormat(controller.ordersList[index]["date"])[0]}",
                ),
                customRow(
                  title: "Time:".tr,
                  subTitle:
                      " ${controller.covertDateFormat(controller.ordersList[index]["date"])[1]}",
                ),
              ],
            ),
            Flexible(child: SvgIcon(ImageUtil.note, size: 45)),
          ],
        ),
      ),
    );
  }

  Widget customRow({required String title, required String subTitle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Styles.boldTextView(13, AppTheme.black)),
        SizedBox(
          width: 168,
          child: Text(subTitle, style: Styles.boldTextView(13, AppTheme.black)),
        ),
      ],
    );
  }

  Widget orderDetailsWidget() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
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
                              controller.customerInfo["username"] ??
                                  "Mohammad saad",
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
                              controller.customerInfo["phoneNumber"] ?? "",
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
                                controller.customerAddress.value,
                                style: Styles.boldTextView(13, AppTheme.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
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
          Visibility(
            visible: !controller.logInType.value.contains("farmer"),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10,
              ),
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
                                controller.farmerInfo["username"] ?? "",
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
                              Text(
                                controller.farmerInfo["farmLocation"] ?? "",
                                style: Styles.boldTextView(13, AppTheme.black),
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
          ),
          Padding(
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
                        "Order details:".tr,
                        style: Styles.boldTextView(13, AppTheme.black),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: controller.ordersDetailsList.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            controller.ordersDetailsList[index]["image"]
                                        .toString() !=
                                    "null"
                                ? Image.memory(
                                  base64Decode(
                                    controller.ordersDetailsList[index]["image"]
                                        .toString(),
                                  ),
                                  height: 20,
                                  width: 20,
                                )
                                : Image.asset(
                                  ImageUtil.all_products,
                                  height: 20,
                                  width: 20,
                                ),
                            SizedBox(width: 10),
                            SizedBox(
                              width: 80,
                              child: Text(
                                controller.ordersDetailsList[index]["name"]
                                    .toString(),
                                style: Styles.boldTextView(13, AppTheme.black),
                              ),
                            ),
                            Spacer(),
                            Text(
                              " ${controller.ordersDetailsList[index]["qty"].toString()}kg ",
                              style: Styles.boldTextView(13, AppTheme.black),
                            ),
                            Spacer(),
                            Text(
                              "${controller.ordersDetailsList[index]["price"].toString()} SAR",
                              style: Styles.boldTextView(13, AppTheme.black),
                            ),
                            Spacer(),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Total Amount: ${controller.selectedOrder['totalAmount']  ?? ""} SAR",
                    style: Styles.semiBoldTextView(13, AppTheme.black),
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
                          "${controller.formatDateTime(controller.selectedOrder["deliveryDate"]??"")} ${controller.selectedOrder["time"]??""}",
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
                  SizedBox(width: 20),
                  Text(
                    "Order id: ${controller.selectedOrder["orderID"]}".tr,
                    style: Styles.semiBoldTextView(13, AppTheme.black),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50),
          if (controller.showAcceptBtn.value) ...[
            Center(
              child: SizedBox(
                width: 190,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.logInType.value.contains("farmer")) {
                      await controller.acceptBtnClick(
                        Constants.orderStatusListOfFarmer[1],
                        false,
                      );
                      if (controller.logInType.value == "driver") {
                        controller.getOrdersList("driverId", "");
                      } else {
                        controller.getOrdersList(
                          "farmerId",
                          BaseController.firebaseAuth.getUid(),
                        );
                      }
                    } else {
                      await controller.acceptBtnClick(
                        Constants.orderStatusListOfDriver[0],
                        true,
                      );

                      await Get.toNamed(
                        Routes.orderDetailDriverPage,
                        arguments: [controller.selectedOrder],
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        controller.logInType.value.contains("farmer")
                            ? AppTheme.primaryColor
                            : AppTheme.orange,
                  ),
                  child: Text("Accept".tr, style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
          SizedBox(height: 20),
          if (controller.showRejectBtn.value) ...[
            Center(
              child: SizedBox(
                width: 190,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.rejectBtnClick();
                    controller.getOrdersList(
                      "farmerId",
                      BaseController.firebaseAuth.getUid(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorTextColor,
                  ),
                  child: Text("Reject".tr, style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
