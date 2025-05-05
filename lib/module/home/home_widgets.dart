import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/home/home_controller.dart';
import 'package:gherass/module/products/controller/product_contoller.dart';
import 'package:gherass/theme/styles.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../theme/app_theme.dart';
import '../inventory/view/widgets/inventory_widgets.dart';

class HomeWidgets {
  var controller = Get.find<HomeViewController>();

  Widget homeWidget(BuildContext context) {
    if (controller.customerList.isNotEmpty &&
        (!controller.customerList[0].containsKey('current_address') ||
            controller.customerList[0]['current_address'] == null ||
            controller.customerList[0]['current_address']['address'] == null ||
            controller.customerList[0]['current_address']['address']
                .toString()
                .trim()
                .isEmpty) &&
        !controller.hasShownDialog.value) {
      Future.delayed(Duration.zero, () {
        controller.hasShownDialog.value = true;
      });
    }

    return Obx(() {
      bool isSearching = controller.searchField.text.isNotEmpty;
      return DefaultTabController(
        length: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Home page'.tr,
                  style: Styles.boldTextView(20, Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 2.0,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller.searchField,
                  onChanged: (v) {
                    controller.searchData();
                  },
                  decoration: InputDecoration(
                    hintText: 'Search'.tr,
                    hintStyle: Styles.boldTextView(16, Colors.grey[700]!),
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppTheme.hintDarkGray,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (isSearching) ...[
                TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.green,
                  tabs: [Tab(text: 'Farms'), Tab(text: 'Products')],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      controller.searchedFarmsList.isEmpty
                          ? Center(
                            child: Text(
                              "Data not found".tr,
                              style: Styles.boldTextView(25, AppTheme.black),
                            ),
                          )
                          : ListView.builder(
                            itemCount: controller.searchedFarmsList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    Routes.productPage,
                                    arguments: [
                                      controller
                                          .searchedFarmsList[index]["farmerId"],
                                      controller.searchedFarmsList[index],
                                    ],
                                  );
                                },
                                child: farmCard(
                                  controller.searchedFarmsList[index],
                                ),
                              );
                            },
                          ),

                      controller.searchedProductList.isEmpty
                          ? Center(
                            child: Text(
                              "Data not found".tr,
                              style: Styles.boldTextView(25, AppTheme.black),
                            ),
                          )
                          : ListView.builder(
                            itemCount: controller.searchedProductList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {
                                  if (!Get.isRegistered<ProductController>()) {
                                    Get.put(ProductController());
                                  }

                                  Get.toNamed(
                                    Routes.productDetails,
                                    arguments: [
                                      controller
                                          .searchedProductList[index]["farmDetails"]["farmerId"]
                                          .toString(),
                                      controller.searchedProductList[index],
                                    ],
                                  );
                                },

                                child: productCard(
                                  controller.searchedProductList[index],
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  'Hello 👋\n${controller.userName.value}',
                  style: Styles.boldTextView(16, AppTheme.black),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.categoryList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.filterFarmersByCategoryAndSortByDistance(
                            controller.categoryList[index]["name"].toString(),
                          );
                        },
                        child: categoryCard(
                          controller.categoryList[index]["name"]
                              .toString()
                              .replaceAll("All Products", "All Farms"),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Farms'.tr,
                      style: Styles.boldTextView(16, AppTheme.black),
                    ),
                  ],
                ),

                Obx(() {
                  return controller.sortedDistancesList.isEmpty
                      ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "No Farms Available".tr,
                            style: Styles.boldTextView(25, AppTheme.black),
                          ),
                        ),
                      )
                      : Expanded(
                        child: ListView.builder(
                          itemCount: controller.sortedDistancesList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.productPage,
                                  arguments: [
                                    controller
                                        .sortedDistancesList[index]["farmerId"]
                                        .toString(),
                                    controller.sortedDistancesList[index],
                                  ],
                                );
                              },
                              child: farmCard(
                                controller.sortedDistancesList[index],
                              ),
                            );
                          },
                        ),
                      );
                }),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget categoryCard(String title) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            controller.getCategoryIcons(title),
            height: 65,
            width: 65,
            fit: BoxFit.cover,
          ),
          Spacer(),
          Text(title, style: Styles.boldTextView(12, AppTheme.black)),
        ],
      ),
    );
  }

  Widget farmCard(farm) {
    return Card(
      shadowColor: Colors.grey,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Builder(
            builder: (context) {
              try {
                String? base64Logo =
                    farm.containsKey('farm_logo') && farm['farm_logo'] != null
                        ? farm['farm_logo'].toString()
                        : null;

                if (base64Logo == null ||
                    base64Logo.isEmpty ||
                    base64Logo == "null") {
                  throw Exception("No valid image data");
                }

                // Optional base64 format validation (can remove if not needed)
                if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(base64Logo)) {
                  throw Exception("Invalid base64 format");
                }

                Uint8List imageBytes = base64Decode(base64Logo);
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

        title: Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                farm['farmName'],
                style: Styles.boldTextView(16, AppTheme.black),
              ),
            ],
          ),
        ),
        subtitle: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    farm['farmLocation'],
                    style: Styles.boldTextView(11, AppTheme.hintDarkGray),
                  ),
                  Icon(
                    Icons.location_on_outlined,
                    color: AppTheme.hintDarkGray,
                    size: 15,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  farm['distance'] != null
                      ? "${farm['distance'].toStringAsFixed(2)} km"
                      : "Distance not available",
                  style: Styles.semiBoldTextView(11, AppTheme.hintDarkGray),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InventoryWidget().ratingWidget(
                  initialRating:
                      double.tryParse(farm["farm_ratings"].toString()) ?? 0.0,
                  onRatingChanged: (v) {},
                  showRating: true,
                  showPercentage: false,
                  iconSize: 13.0,
                  isReadOnly: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(product) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Builder(
            builder: (context) {
              try {
                String? base64Logo =
                    product.containsKey('image') && product['image'] != null
                        ? product['image'].toString()
                        : null;

                if (base64Logo == null ||
                    base64Logo.isEmpty ||
                    base64Logo == "null") {
                  throw Exception("No valid image data");
                }

                // Optional base64 format validation (can remove if not needed)
                if (!RegExp(r'^[A-Za-z0-9+/]*={0,2}$').hasMatch(base64Logo)) {
                  throw Exception("Invalid base64 format");
                }

                Uint8List imageBytes = base64Decode(base64Logo);
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
         controller.getTranslatedSearchedName(product),
          style: Styles.boldTextView(16, AppTheme.black),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Price: ${product['price'] ?? 'N/A'}',
                    style: Styles.semiBoldTextView(13, AppTheme.hintDarkGray),
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Category: ${product['category'] ?? 'N/A'}',
                style: Styles.semiBoldTextView(12, AppTheme.navGrey),
              ),
              const SizedBox(height: 4),
              Text(
                'Farm: ${product["farmDetails"]["farmName"] ?? 'N/A'}',
                style: Styles.semiBoldTextView(12, AppTheme.navGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showLocationSelectionDialog({
    required String title,
    required TextEditingController textController,
    Widget? suffixIcon,
    required VoidCallback onSave,
  }) {
    return AlertDialog(
      title: TextScroll(
        title,
        mode: TextScrollMode.endless,
        velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
        delayBefore: const Duration(milliseconds: 500),
        numberOfReps: 2,
        pauseBetween: const Duration(milliseconds: 50),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        textAlign: TextAlign.right,
        selectable: true,
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          readOnly: true,
          controller: textController,
          decoration: InputDecoration(
            hintText: "Select Location...".tr,
            hintStyle: Styles.regularTextStyle(Colors.grey, 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: suffixIcon,
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          onPressed: () {
            onSave();
          },
          child: Text("Save".tr),
        ),
      ],
    );
  }
}
