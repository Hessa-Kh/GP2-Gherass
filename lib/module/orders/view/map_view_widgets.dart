import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/util/constants.dart';
import 'package:gherass/widgets/loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/styles.dart';
import '../../home/home_controller.dart';
import '../controller/order_detail_map_controller.dart';

class MapViewWidgets{
  var controller = Get.find<OrderDetailMapController>();

  Widget mapViewWidget(BuildContext context, RxMap<String, dynamic> selectedOrder) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Obx(() {
                final deliveryLat = selectedOrder["delivery_address"]["lat"];
                final deliveryLng = selectedOrder["delivery_address"]["lng"];
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(deliveryLat, deliveryLng),
                    zoom: 12,
                  ),
                  markers: Set<Marker>.from(controller.markers),
                  onMapCreated: controller.setMapController,
                );
              }),
            ),
            const SizedBox(height: 20),
            Obx(() => Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppTheme.navGrey, size: 30),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedOrder['delivery_address']['address'],
                    style: Styles.boldTextView(13, AppTheme.black),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            )),
            const SizedBox(height: 20),
            Obx(() => Row(
              children: [
                const Icon(Icons.access_time_outlined, color: AppTheme.navGrey, size: 25),
                const SizedBox(width: 10),
                Text(
                  controller.covertDateFormatToTime(selectedOrder['date']),
                  style: Styles.boldTextView(13, AppTheme.black),
                ),
              ],
            )),
            const SizedBox(height: 20),
            Obx(() => Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: AppTheme.navGrey, size: 25),
                const SizedBox(width: 10),
                Text(
                  controller.covertDateFormatToDate(selectedOrder['date']),
                  style: Styles.boldTextView(13, AppTheme.black),
                ),
              ],
            )),
            const SizedBox(height: 20),
            // Order Status Section
            Container(
              decoration: BoxDecoration(
                color: AppTheme.pampas,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Obx(() => Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () => controller.showOrderStatusToggle.toggle(),
                      child: Row(
                        children: [
                          const Icon(Icons.keyboard_arrow_down_sharp, color: AppTheme.hintDarkGray, size: 25),
                          const SizedBox(width: 10),
                          Text(
                            controller.selectedStatusName.value ?? "Order Status".tr,
                            style: Styles.boldTextView(16, AppTheme.hintDarkGray),
                          ),
                        ],
                      ),
                    ),
                  )),
                  Obx(() => Visibility(
                    visible: controller.showOrderStatusToggle.value,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Constants.orderStatusListOfDriver.length,
                        separatorBuilder: (context, index) => Divider(
                          color: index <= controller.currentStatusIndex.value
                              ? AppTheme.hintDarkGray
                              : null,
                        ),
                        itemBuilder: (context, index) {
                          final status = Constants.orderStatusListOfDriver[index];
                          return InkWell(
                            onTap: () async {
                              if (index > controller.currentStatusIndex.value) {
                                LoadingIndicator.loadingWithBackgroundDisabled("Updating..");
                                await controller.updateDeliveryStatus(status);
                                await Get.find<HomeViewController>().fetchDriverOrders();
                                controller.fetchFcmTokenByIdAndSendNotification(
                                  controller.selectedOrder["customerId"],
                                  status,
                                  controller.orderId,
                                );
                                LoadingIndicator.stopLoading();
                              }
                            },
                            child: Obx(()=>Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    status,
                                    style: Styles.boldTextView(
                                      16,
                                      index <= controller.currentStatusIndex.value ? AppTheme.hintDarkGray : Colors.blue,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                if (index <= controller.currentStatusIndex.value)
                                  const Icon(Icons.check, color: Colors.green, size: 20),
                              ],
                            )),
                          );
                        },
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Call Customer Section
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Call Customer,".tr, style: Styles.boldTextView(16, AppTheme.black)),
                    Text(controller.customerName.value, style: Styles.boldTextView(16, AppTheme.black)),
                  ],
                ),
                InkWell(
                  onTap: () => controller.openDialPad(selectedOrder['delivery_address']['phoneNumber']),
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.orange,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.phone_in_talk_outlined, color: AppTheme.white),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}