import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/module/home/home_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';

import '../../helper/routes.dart';
import '../../widgets/svg_icon_widget.dart';

class DriverHome extends StatelessWidget {
  const DriverHome({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeViewController>();

    return Obx(()=>Scaffold(
      appBar: AppBar(
        title: Text(
          "Home Page".tr,
          style: Styles.boldTextView(20, AppTheme.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getDatas();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                Obx(
                  () => Text(
                    'Hello 👋\n${controller.userName.value}'.tr,
                    style: Styles.boldTextView(16, AppTheme.black),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  'current Orders'.tr,
                  style: Styles.boldTextView(14, AppTheme.navGrey),
                ),
                const SizedBox(height: 10),

                /// currentOrders section
                      controller.showCurrentOrders.value
                          ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.currentOrders.length,
                            itemBuilder: (BuildContext context, int index) {
                              var item = controller.currentOrders[index];
                              return InkWell(
                                onTap: () async {
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
                          )
                          : Align(
                            alignment: Alignment.center,
                            child: Text(
                              controller.currentOrders.isEmpty
                                  ? "Current Orders Empty !".tr
                                  : "",
                            ),
                          ),


                Visibility(
                  visible:
                      BaseController.storageService.getLogInType() == "driver"
                          ? true
                          : false,
                  child: Row(
                    children: [
                      Text(
                        'Previous Orders'.tr,
                        style: Styles.boldTextView(14, AppTheme.navGrey),
                      ),
                      Obx(
                        () => InkWell(
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                ///  pastOrders section
                Visibility(
                  visible:
                      BaseController.storageService.getLogInType() == "driver"
                          ? true
                          : false,
                  child:
                        controller.showPastOrders.value
                            ? Visibility(
                              visible: controller.showPastOrders.value,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.pastOrders.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = controller.pastOrders[index];
                                  return InkWell(
                                    onTap: () async {
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
                            )
                            : Align(
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
    ));
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
              customRow(title: "Order number: ".tr, subTitle: order['orderID']??""),
              customRow(
                title: "Address: ".tr,
                subTitle: order['delivery_address']["address"]??"",
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
