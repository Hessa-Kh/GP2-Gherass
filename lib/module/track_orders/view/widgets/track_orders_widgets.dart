
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/track_orders/controller/order_track_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/widgets/appBar.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../../../theme/styles.dart';
import '../../../../util/image_util.dart';
import '../../../../widgets/svg_icon_widget.dart';
import '../../controller/orders_timer_controller.dart';

class TrackOrdersWidgets {
  var controller = Get.put(OrderTrackController());

  Widget trackOrdersWidget(BuildContext context) {
    return Obx(() {
      if (controller.orderStatus.value.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
        appBar: CommonAppBar(title: controller.orderStatus.value),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "It will arrive in 10 - 15 minutes",
                //   style: Styles.regularTextView(14, Color(0xff6472D2)),
                //   textAlign: TextAlign.left,
                // ),
                // const SizedBox(height: 8),
                const SizedBox(height: 40),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.orderStatusList.length,
                  itemBuilder: (context, index) {
                    return buildTimelineStep(
                      controller.orderStatusList.toList()[index],
                      Icons.check,
                      index <= controller.statusIndex ? true : false,
                      controller.orderStatusList.length == index + 1
                          ? true
                          : false,
                    );
                  },
                ),
                const Divider(height: 32),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Visibility(
                    visible: controller.driverName.value != "",
                    child: ListTile(
                      leading: SvgIcon(ImageUtil.profileAvatar, size: 50),
                      title: Text(
                        controller.driverName.value,
                        style: Styles.boldTextView(20, Color(0xff101010)),
                      ),
                      subtitle: Text(
                        "Driver",
                        style: Styles.boldTextView(12, Color(0xffFC763E)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: SvgIcon(ImageUtil.callCalling, size: 30),
                            onPressed: () {
                              showDriverContactSheet(context);
                            },
                          ),
                          // IconButton(
                          //   icon: SvgIcon(ImageUtil.message, size: 30),
                          //   onPressed: () {
                          //     showDriverContactSheet(context);
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Get.back();
                Get.back();
                // showOrderCountdownScreen(context);
              },
              child: Text(
                "Orders".tr,
                style: Styles.boldTextView(20, const Color(0xff101010)),
              ),
            ),
          ),
        ),
      );
    });

    // Column(
    //   children: [
    // Stack(
    //   children: [
    //     SizedBox(
    //       height: 300,
    //       child: Obx(
    //         () => GoogleMap(
    //           initialCameraPosition: CameraPosition(
    //             target: controller.mapPosition.value ?? LatLng(0, 0),
    //             zoom: 12,
    //           ),
    //           onMapCreated: (GoogleMapController mapController) {
    //             controller.googleMapController = mapController;
    //           },
    //           markers: {
    //             if (controller.mapPosition.value != null)
    //               Marker(
    //                 markerId: MarkerId('${controller.mapPosition.value}'),
    //                 position: controller.mapPosition.value!,
    //                 icon: BitmapDescriptor.defaultMarkerWithHue(
    //                   BitmapDescriptor.hueRed,
    //                 ),
    //               ),
    //           },
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       top: 45,
    //       left: 18,
    //       child: GestureDetector(
    //         onTap: () {
    //           Get.offAllNamed(Routes.dashBoard);
    //         },
    //         child: Container(
    //           width: 40,
    //           height: 40,
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             shape: BoxShape.circle,
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black.withOpacity(0.1),
    //                 blurRadius: 4,
    //                 spreadRadius: 1,
    //               ),
    //             ],
    //           ),
    //           child: Center(child: SvgIcon(ImageUtil.backArrow, size: 15)),
    //         ),
    //       ),
    //     ),
    //     Positioned(
    //       top: 45,
    //       right: 18,
    //       child: Row(
    //         children: [
    //           GestureDetector(
    //             onTap: () {},
    //             child: Container(
    //               padding: const EdgeInsets.symmetric(
    //                 horizontal: 12,
    //                 vertical: 8,
    //               ),
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(20),
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.black.withOpacity(0.1),
    //                     blurRadius: 4,
    //                     spreadRadius: 1,
    //                   ),
    //                 ],
    //               ),
    //               child: Text(
    //                 "Help".tr,
    //                 style: Styles.regularTextView(14, Colors.black),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(width: 8),
    //           GestureDetector(
    //             onTap: () {},
    //             child: Container(
    //               width: 40,
    //               height: 40,
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 shape: BoxShape.circle,
    //                 boxShadow: [
    //                   BoxShadow(
    //                     color: Colors.black.withOpacity(0.1),
    //                     blurRadius: 4,
    //                     spreadRadius: 1,
    //                   ),
    //                 ],
    //               ),
    //               child: const Center(
    //                 child: Icon(Icons.more_horiz, color: Colors.black),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // ),
    //   ],
    // );
  }

  Widget buildTimelineStep(
    String text,
    IconData icon,
    bool isDone,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDone ? Color(0xff6472D2) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 20,
                color: isDone ? Color(0xff6472D2) : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Styles.boldTextView(16, Color(0xff101010))),
        ),
      ],
    );
  }

  void showDriverContactSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildContactButton(
                ImageUtil.callCalling,
                "Contact the driver".tr,
                () {
                  controller.openDialPad();
                },
              ),
              // SizedBox(height: 20),
              // buildContactButton(
              //   ImageUtil.message,
              //   "Message the driver".tr,
              //   () {},
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget buildContactButton(
    String svgAsset,
    String text,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff6472D2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: const Size(double.infinity, 60),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgIcon(svgAsset, size: 30, color: Colors.white),
          const SizedBox(width: 80),
          Text(text, style: Styles.boldTextView(20, Colors.white)),
        ],
      ),
    );
  }

  void placedOrderDailogue(title) {
    Get.dialog(
      AlertDialog(
        title: Center(
          child: Text(title, style: Styles.boldTextView(16, AppTheme.black)),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}

class OrderCountdownPage extends StatelessWidget {
  final String orderId;

  const OrderCountdownPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final OrdersTimerController controller = Get.put(OrdersTimerController());

    controller.orderId.value = orderId;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TextScroll(
            "Order  #$orderId",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
            mode: TextScrollMode.endless,
            velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
            delayBefore: Duration(milliseconds: 500),
            numberOfReps: 15,
            pauseBetween: Duration(milliseconds: 50),
            textAlign: TextAlign.right,
            selectable: true,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(child: SvgIcon(ImageUtil.fwdArrow, size: 15)),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Waiting for the farm to accept the order".tr,
              textAlign: TextAlign.center,
              style: Styles.boldTextView(20, Color(0xff101010)),
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Obx(() {
                    return CircularProgressIndicator(
                      value:
                          controller.remainingSeconds.value /
                          OrdersTimerController.countdownSeconds,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
                    );
                  }),
                ),
                Obx(() {
                  return Text(
                    controller.formatTime(controller.remainingSeconds.value),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
