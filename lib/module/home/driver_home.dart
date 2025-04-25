
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';

import '../../helper/routes.dart';
import '../../widgets/svg_icon_widget.dart';
import 'home_controller.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeViewController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            "Home Page".tr,
            style: Styles.boldTextView(20, AppTheme.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Hello 👋\n${controller.userName.value}'.tr,
                  style: Styles.boldTextView(16, AppTheme.black),
                ),
                const SizedBox(height: 20),
                Text(
                  'current Orders'.tr,
                  style: Styles.boldTextView(14, AppTheme.navGrey),
                ),
                const SizedBox(height: 10),
                controller.showCurrentOrders.value
                    ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.currentOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = controller.currentOrders[index];
                        return InkWell(
                          onTap: () async {
                            // detail page navigation
                            print(item.toString());
                            await Get.toNamed(
                              Routes.orderDetailDriverPage,
                              arguments: [item],
                            );
                            // var controller = Get.find<OrderDetailMapController>();
                            // controller.selectedOrder.assignAll(item);
                            // print("assigned order");
                            // print(controller.selectedOrder["orderID"]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: orderItem(item, controller),
                          ),
                        );
                      },
                    )
                    : Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          controller.currentOrders.isEmpty
                              ? "Orders Empty !".tr
                              : "",
                        ),
                      ),
                    ),
                Row(
                  children: [
                    Text(
                      'Previous Orders This Week'.tr,
                      style: Styles.boldTextView(14, AppTheme.navGrey),
                    ),
                    InkWell(
                      onTap: () {
                        controller.showPastOrders.value =
                            !controller.showPastOrders.value;
                      },
                      child: Icon(
                        !controller.showPastOrders.value
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        size: 45,
                        color: AppTheme.navGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                controller.showPastOrders.value
                    ? Visibility(
                      visible: controller.showPastOrders.value,
                      child: Expanded(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.pastOrders.length,
                          itemBuilder: (BuildContext context, int index) {
                            var item = controller.pastOrders[index];
                            return InkWell(
                              onTap: () async {
                                // detail page navigation
                                await Get.toNamed(
                                  Routes.orderDetailDriverPage,
                                  arguments: [item],
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: orderItem(item, controller),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                    : Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          controller.pastOrders.isEmpty
                              ? "Orders Empty !".tr
                              : "",
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget orderItem(Map<String, dynamic> order, HomeViewController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(color: Colors.grey[300]!, blurRadius: 2.0, spreadRadius: 1),
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
              customRow(title: "Order number: ".tr, subTitle: order['orderID']),
              customRow(
                title: "Address: ".tr,
                subTitle: order['delivery_address']["address"],
              ),
              customRow(
                title: "Date: ".tr,
                subTitle: controller.formatDateTime(order["date"]),
              ),
              // customRow(title: "Time: ".tr, subTitle: order['time']),
            ],
          ),
          Flexible(child: SvgIcon(ImageUtil.note, size: 50)),
        ],
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
}
