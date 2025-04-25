import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/cart/controller/my_cart_controller.dart';
import 'package:gherass/module/delivery_address/controller/delivery_address_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';
import 'package:gherass/widgets/svg_icon_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryAddressWidgets {
  final controller = Get.find<DeliveryAddressController>();

  Widget myAddressesWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Builder(
            builder: (context) {
              return Expanded(
                child: Obx(
                  () => addressListCard(controller.addressList.toList()),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.isAddingNewAddress.value = true;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff6472D2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                ),
                child: Text(
                  "Add New Address".tr,
                  style: Styles.boldTextView(20, Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mapWidget(context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 500,
          child: Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    controller.currentLocation.value ??
                    controller.initialPosition,
                zoom: 12,
              ),
              myLocationEnabled: true,
              markers: Set<Marker>.from(controller.markers),
              onMapCreated: controller.setMapController,
              onTap: controller.onMapTap,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: MediaQuery.of(context).size.width * 0.3,
          child: InkWell(
            onTap: () {
              controller.getCurrentLocation();
            },
            child: Container(
              width: 120,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SvgIcon(ImageUtil.icLoc, size: 17),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        "Your Current Location".tr,
                        style: Styles.mediumTextView(12, Color(0xff101010)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget addNewAddressWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            mapWidget(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 40,
                child: Obx(
                  () => ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.sectionList.length,
                    itemBuilder: (context, index) {
                      var sectionName = controller.sectionList[index];
                      bool isSelected = controller.selectedIndex.value == index;
                      return InkWell(
                        onTap: () {
                          controller.selectedIndex.value = index;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          margin: EdgeInsets.symmetric(
                            vertical: 7,
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? Color(0xff6472D2)
                                    : Color(0xffB7B7B7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              sectionName,
                              style: Styles.boldTextView(
                                12,
                                isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            customTextField(controller.addressTitle, "Address Title".tr),
            Visibility(
              visible: controller.selectedIndex.value == 2,
              child: customTextField(controller.description, "Description".tr),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (controller.addressId.value.isNotEmpty) {
                        controller.updateAddress();
                      } else {
                        controller.postAddress();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      controller.addressId.value.isNotEmpty
                          ? "Update Address".tr
                          : "Save Address".tr,
                      style: TextStyle(fontSize: 18, color: Colors.white),
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

  Widget addressListCard(List<Map<String, dynamic>> list) {
    int actualCount = list.isNotEmpty ? list.length : 0;

    if (actualCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contact_emergency, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No Address Found".tr,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: actualCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SvgIcon(ImageUtil.icLoc, size: 17),
                          SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              list[index]['address_title'],
                              style: Styles.mediumTextView(
                                15,
                                Color(0xff101010),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            controller.updateFields(list[index]);
                          },
                          child: Row(
                            children: [
                              SvgIcon(ImageUtil.icEdit, size: 17),
                              SizedBox(width: 4),
                              Text(
                                "Edit".tr,
                                style: Styles.mediumTextView(
                                  15,
                                  Color(0xff797D82),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            showDeleteConfirmationDialog(
                              title: "Delete Product".tr,
                              addressId: list[index]["id"],
                              addressType: list[index]["address_type"],
                            );
                          },
                          child: Row(
                            children: [
                              SvgIcon(ImageUtil.trash, size: 17),
                              SizedBox(width: 4),
                              Text(
                                "Delete".tr,
                                style: Styles.mediumTextView(
                                  15,
                                  Color(0xffEA4335),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDeleteConfirmationDialog({
    required String title,
    required String addressId,
    required String addressType,
  }) {
    Get.dialog(
      AlertDialog(
        title: Center(
          child: Text(title, style: Styles.boldTextView(16, AppTheme.black)),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFECE4D7),
                  offset: Offset(0, 4),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Center(
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".tr,
                  style: Styles.boldTextView(16, AppTheme.black),
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              color: AppTheme.lightRose,
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFECE4D7),
                  offset: Offset(0, 4),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Center(
              child: TextButton(
                onPressed: () {
                  controller.deleteAddress(addressId, addressType);
                  Get.back();
                  controller.getAddressList();
                },
                child: Text(
                  "Yes".tr,
                  style: Styles.mediumTextView(16, AppTheme.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customTextField(
    final TextEditingController controller,
    final String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 4)],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void showAddresList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Text(
                'Select Delivery Address'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.addressList.length,
                  itemBuilder: (context, index) {
                    var address = controller.addressList[index];
                    return RadioListTile<int>(
                      title: Text(address['address_title'].toString()),
                      value: index,
                      groupValue: controller.selectedAddress.value,
                      onChanged: (int? value) {
                        List<String> keysToCheck = [
                          "street".tr,
                          "houseNumber".tr,
                          "neighborhood".tr,
                        ];
                        for (var key in keysToCheck) {
                          if (!address.containsKey(key)) {
                            address[key] = '';
                          }
                        }

                        controller.updateDeliveryAddress(address);
                        controller.selectedAddress.value = value!;
                        MyCartController cartController =
                            Get.find<MyCartController>();
                        cartController.getCustomerDeliveryAddress();
                        Get.back();
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
