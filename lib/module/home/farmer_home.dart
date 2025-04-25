import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:gherass/module/inventory/view/widgets/inventory_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../helper/routes.dart';
import 'home_controller.dart';

class FarmerHome extends StatelessWidget {
  const FarmerHome({super.key});

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
        body: Container(
          margin: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: TextFormField(
                    controller: controller.searchField,
                    onChanged: (v) {
                      controller.searchData();
                    },
                    decoration: InputDecoration(
                      suffix: SizedBox(
                        height: 60,
                        width: 50,
                        child: Icon(Icons.search),
                      ),
                      fillColor: AppTheme.borderColor,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: "Search".tr,
                      hintStyle: Styles.mediumTextView(16, AppTheme.black),
                      contentPadding: EdgeInsets.only(
                        left: 20.0,
                        top: 20,
                        bottom: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (controller.searchedFarmsList.isEmpty &&
                    controller.searchField.text.isNotEmpty) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Data not found".tr,
                        style: Styles.boldTextView(25, AppTheme.black),
                      ),
                    ),
                  ),
                ] else if (controller.searchedFarmsList.isEmpty) ...[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${"Hello".tr} 👋\n${controller.userName.value}",
                        style: Styles.boldTextView(16, AppTheme.black),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.borderColor,
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
                    child: SizedBox(
                      height: 230,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          Visibility(
                            visible:
                                controller.farmLogo.value.isEmpty
                                    ? true
                                    : false,
                            replacement: Image.memory(
                              base64Decode(controller.farmLogo.value),
                              height: 80,
                              width: 80,
                            ),
                            child: Image.asset(
                              ImageUtil.dummy_edit,
                              height: 80,
                              width: 80,
                            ),
                          ),
                          Text(
                            controller.farmName.value ?? "",
                            style: Styles.mediumTextView(16, AppTheme.navGrey),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_city),
                              Text(
                                controller.location.value ?? "",
                                style: Styles.mediumTextView(
                                  16,
                                  AppTheme.navGrey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StarRating(
                                rating:
                                    double.tryParse(
                                      controller.farmRatings.value.toString(),
                                    ) ??
                                    0.0,
                                allowHalfRating: true,
                                color: Colors.yellow.shade700,
                                onRatingChanged: (rating) {},
                              ),
                              Text(
                                controller.farmRatings.value.toString(),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Farms".tr,
                      style: Styles.boldTextView(18, AppTheme.black),
                    ),
                  ),
                  controller.sortedDistancesList.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "No Farms Available".tr,
                            style: Styles.boldTextView(25, AppTheme.black),
                          ),
                        ),
                      )
                      : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            controller.searchedFarmsList.isNotEmpty
                                ? controller.searchedFarmsList.length
                                : controller.sortedDistancesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var farmItem =
                              controller.searchedFarmsList.isNotEmpty
                                  ? controller.searchedFarmsList[index]
                                  : controller.sortedDistancesList[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.productPage,
                                  arguments: [
                                    controller.farmerIdList[index],
                                    controller.farmsList[index],
                                  ],
                                );
                              },
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: AppTheme.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFECE4D7),
                                      offset: Offset(0, 4),
                                      blurRadius: 10.0,
                                      spreadRadius: 1.0,
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Builder(
                                      builder: (context) {
                                        try {
                                          String? base64Logo =
                                              farmItem.containsKey(
                                                        'farm_logo',
                                                      ) &&
                                                      farmItem['farm_logo'] !=
                                                          null
                                                  ? farmItem['farm_logo']
                                                      .toString()
                                                  : null;

                                          if (base64Logo == null ||
                                              base64Logo.isEmpty ||
                                              base64Logo == "null") {
                                            throw Exception(
                                              "No valid image data",
                                            );
                                          }

                                          // Optional base64 format validation (can remove if not needed)
                                          if (!RegExp(
                                            r'^[A-Za-z0-9+/]*={0,2}$',
                                          ).hasMatch(base64Logo)) {
                                            throw Exception(
                                              "Invalid base64 format",
                                            );
                                          }

                                          Uint8List imageBytes = base64Decode(
                                            base64Logo,
                                          );
                                          return Image.memory(
                                            imageBytes,
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.cover,
                                          );
                                        } catch (e) {
                                          return Icon(
                                            Icons.image_not_supported,
                                            size: 60,
                                            color: Colors.grey,
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  title: Text(
                                    farmItem["farmName"].toString() ?? "",
                                    style: Styles.boldTextView(
                                      16,
                                      AppTheme.black,
                                    ),
                                  ),
                                  subtitle: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(Icons.location_city),
                                              SizedBox(width: 8),
                                              TextScroll(
                                                farmItem["farmLocation"]
                                                        .toString() ??
                                                    "",
                                                mode: TextScrollMode.endless,
                                                velocity: const Velocity(
                                                  pixelsPerSecond: Offset(
                                                    50,
                                                    0,
                                                  ),
                                                ),
                                                delayBefore: const Duration(
                                                  milliseconds: 500,
                                                ),
                                                numberOfReps: 2,
                                                pauseBetween: const Duration(
                                                  milliseconds: 50,
                                                ),
                                                style: Styles.mediumTextView(
                                                  12,
                                                  AppTheme.black,
                                                ),
                                                textAlign: TextAlign.right,
                                                selectable: true,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "${farmItem['distance'].toStringAsFixed(2)} km",
                                                style: Styles.semiBoldTextView(
                                                  11,
                                                  AppTheme.hintDarkGray,
                                                ),
                                              ),
                                            ],
                                          ),
                                          InventoryWidget().ratingWidget(
                                            initialRating:
                                                double.tryParse(
                                                  farmItem["farm_ratings"]
                                                      .toString(),
                                                ) ??
                                                0.0,
                                            onRatingChanged: (v) {},
                                            showRating: true,
                                            showPercentage: false,
                                            isReadOnly: true,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                ] else ...[
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        controller.searchedFarmsList.isNotEmpty
                            ? controller.searchedFarmsList.length
                            : controller.sortedDistancesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var farmItem =
                          controller.searchedFarmsList.isNotEmpty
                              ? controller.searchedFarmsList[index]
                              : controller.sortedDistancesList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(
                              Routes.productPage,
                              arguments: [
                                controller.farmerIdList[index],
                                controller.farmsList[index],
                              ],
                            );
                          },
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFECE4D7),
                                  offset: Offset(0, 4),
                                  blurRadius: 10.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Builder(
                                  builder: (context) {
                                    try {
                                      String? base64Logo =
                                          farmItem.containsKey('farm_logo') &&
                                                  farmItem['farm_logo'] != null
                                              ? farmItem['farm_logo'].toString()
                                              : null;

                                      if (base64Logo == null ||
                                          base64Logo.isEmpty ||
                                          base64Logo == "null") {
                                        throw Exception("No valid image data");
                                      }

                                      // Optional base64 format validation (can remove if not needed)
                                      if (!RegExp(
                                        r'^[A-Za-z0-9+/]*={0,2}$',
                                      ).hasMatch(base64Logo)) {
                                        throw Exception(
                                          "Invalid base64 format",
                                        );
                                      }

                                      Uint8List imageBytes = base64Decode(
                                        base64Logo,
                                      );
                                      return Image.memory(
                                        imageBytes,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      );
                                    } catch (e) {
                                      return Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: Colors.grey,
                                      );
                                    }
                                  },
                                ),
                              ),

                              title: Text(
                                farmItem["farmName"].toString() ?? "",
                                style: Styles.boldTextView(16, AppTheme.black),
                              ),
                              subtitle: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(Icons.location_city),
                                          SizedBox(width: 8),
                                          Text(
                                            farmItem["farmLocation"]
                                                    .toString() ??
                                                "",
                                            style: Styles.mediumTextView(
                                              12,
                                              AppTheme.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      InventoryWidget().ratingWidget(
                                        initialRating: 3.5,
                                        onRatingChanged: (v) {},
                                        showRating: true,
                                        showPercentage: false,
                                        isReadOnly: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
