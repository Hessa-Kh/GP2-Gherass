import 'dart:convert';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:get/get.dart';
import 'package:gherass/module/cart/controller/my_cart_controller.dart';
import 'package:gherass/module/cart/model/cart_model.dart';
import 'package:gherass/module/products/controller/product_contoller.dart';

import '../../../helper/routes.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/styles.dart';
import '../../../util/image_util.dart';
import '../../../widgets/svg_icon_widget.dart';
import '../../home/home_controller.dart';
import '../../inventory/view/widgets/inventory_widgets.dart';
import 'event_datails_view.dart';
import 'dart:typed_data';

class ProductWidgets {
  var controller = Get.find<ProductController>();
  var homeController = Get.find<HomeViewController>();

  Widget bookEventWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.whiteAndGrey,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Visibility(
                      visible: !controller.logInType.value.contains("farmer"),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              reviewDialog(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SvgIcon(
                                      ImageUtil.ranking,
                                      color: AppTheme.hintDarkGray,
                                    ),
                                    Text(
                                      "Write a review",
                                      style: Styles.boldTextView(
                                        10,
                                        AppTheme.hintDarkGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Builder(
                          builder: (context) {
                            try {
                              String? base64String =
                                  controller.farmData.containsKey(
                                            'farm_logo',
                                          ) &&
                                          controller.farmData['farm_logo'] !=
                                              null
                                      ? controller.farmData['farm_logo']
                                          .toString()
                                      : null;

                              if (base64String == null ||
                                  base64String.isEmpty) {
                                throw Exception("Invalid image data");
                              }

                              if (!RegExp(
                                r'^[A-Za-z0-9+/]*={0,2}$',
                              ).hasMatch(base64String)) {
                                throw Exception("Invalid base64 format");
                              }
                              Uint8List imageBytes = base64Decode(base64String);
                              return Image.memory(
                                imageBytes,
                                width: 120,
                                height: 120,
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
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.farmData['farmName']?.toString() ?? "",
                      style: Styles.boldTextView(16, AppTheme.black),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          controller.farmData['farmLocation'].toString() ?? "",
                          style: Styles.boldTextView(11, AppTheme.hintDarkGray),
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          color: AppTheme.hintDarkGray,
                          size: 17,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StarRating(
                            rating:
                                double.tryParse(
                                  controller.farmRating.value.toString(),
                                ) ??
                                0.0,
                            allowHalfRating: true,
                            color: Colors.yellow.shade700,
                            onRatingChanged: (rating) {},
                          ),
                          Text(
                            controller.farmRating.value ?? "",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 50,
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.sectionList.length,
                  itemBuilder: (context, index) {
                    String sectionName = controller.sectionList[index];
                    return GestureDetector(
                      onTap: () {
                        controller.eventSectionValue.value = index;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 30,
                        ),
                        margin: EdgeInsets.symmetric(
                          vertical: 7,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color:
                              controller.eventSectionValue.value == index
                                  ? AppTheme.darkBlue
                                  : AppTheme.lightPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            sectionName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
          if (controller.eventSectionValue.value == 1) ...[
            eventSectionWidget(),
          ] else if (controller.eventSectionValue.value == 2) ...[
            productSectionWidget(context),
          ] else ...[
            reviewSectionWidget(),
          ],
        ],
      ),
    );
  }

  Widget productSectionWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categoryList.length,
            itemBuilder: (context, index) {
              String categoryName = controller.categoryList[index];
              return GestureDetector(
                onTap: () {
                  controller.categorySelectedValue.value = index;
                  controller.filterProductsByCategory();
                },
                child: Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    decoration: BoxDecoration(
                      color:
                          controller.categorySelectedValue.value == index
                              ? AppTheme.whiteAndGrey
                              : AppTheme.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 1.0,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        categoryName,
                        style: Styles.boldTextView(11, AppTheme.black),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Obx(() {
            final products = controller.farmerProducts;
            if (products.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Center(
                  child: Text(
                    "No products available".tr,
                    style: Styles.boldTextView(16, Colors.blueGrey),
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    final prodController =
                        Get.isRegistered<ProductController>()
                            ? Get.find<ProductController>()
                            : Get.put(ProductController());

                    prodController.setSelectedProduct(products[index]);

                    Get.toNamed(
                      Routes.productDetails,
                      arguments: [controller.farmerId.value, products[index]],
                    );
                  },
                  child: productCard(products[index]),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget eventSectionWidget() {
    List farmData = controller.farmerEvents.toList();

    if (farmData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Center(
          child: Text(
            "No events available".tr,
            style: Styles.boldTextView(18, Colors.blueGrey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: farmData.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              controller.farmerEventItem.clear();
              controller.farmerEventItem.add(farmData[index]);
              Get.to(EventDetailsPage());
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!,
                    blurRadius: 2.0,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmData[index]["name"],
                    style: Styles.boldTextView(24, AppTheme.black),
                  ),
                  Text(
                    "${farmData[index]["remaining_tickets"]} tickets remaining",
                    style: Styles.boldTextView(16, AppTheme.errorTextColor),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productCard(Map<String, dynamic> product) {
    return Card(
      margin: EdgeInsets.all(2),
      color: AppTheme.whiteAndGrey,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Spacer(),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Builder(
                builder: (context) {
                  try {
                    String? base64String =
                        product.containsKey('image') && product['image'] != null
                            ? product['image'].toString()
                            : null;

                    // Check if the base64 string is null or empty
                    if (base64String == null || base64String.isEmpty) {
                      throw Exception("Invalid image data");
                    }

                    // Ensure it's a valid base64 string before decoding
                    if (!RegExp(
                      r'^[A-Za-z0-9+/]*={0,2}$',
                    ).hasMatch(base64String)) {
                      throw Exception("Invalid base64 format");
                    }
                    Uint8List imageBytes = base64Decode(base64String);
                    return Image.memory(
                      imageBytes,
                      width: 120,
                      height: 120,
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
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Visibility(
                  visible: controller.logInType.value.contains("customer"),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SvgIcon(ImageUtil.bag, color: AppTheme.white),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'] ?? "",
                        style: Styles.boldTextView(16, AppTheme.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      product['discount_price'] == null
                          ? Text(
                            "${product['price'].toString() ?? ""} SAR / ${product['qty'].toString() ?? ""}",
                            style: Styles.boldTextView(11, Color(0xff101010)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          )
                          : Text(
                            "${product['discount_price'].toString() ?? ""} SAR / ${product['qty'].toString() ?? ""}",
                            style: Styles.boldTextView(11, Color(0xff101010)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget eventDetailsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: AppTheme.whiteAndGrey,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.black,
                    size: 15,
                  ),
                ),
              ),
              Spacer(),
              Text(
                'Event details',
                style: Styles.boldTextView(20, AppTheme.black),
              ),
              Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 40),
          infoCard(controller.farmerEventItem.first["name"].toString(), context,),
          const SizedBox(height: 10),
          infoCard(
            'Event date and time',
            context,
            subtitle: controller.farmerEventItem.first["start_date"].toString(),
            icon: Icons.event,
          ),
          const SizedBox(height: 10),
          infoCard(
            'Event details',
            context,
            subtitle:
                controller.farmerEventItem.first["description"].toString(),
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 10),
          infoCard(
            'Location',
            context,
            subtitle: controller.farmerEventItem.first["location"].toString(),
            icon: Icons.location_on_outlined,
            isLink: true,
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 12,
                ),
              ),
              onPressed:
                  (controller.isEventBooked(controller.farmerEventItem.first) ||
                          int.parse(
                                controller
                                    .farmerEventItem
                                    .first["remaining_tickets"],
                              ) <=
                              0)
                      ? null
                      : () {
                        controller.bookEvents(
                          context,
                          controller.farmData["farmName"],
                        );
                      },
              child: Text(
                controller.isEventBooked(controller.farmerEventItem.first)
                    ? 'Booked'
                    : 'Book',
                style: Styles.boldTextView(16, AppTheme.white),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget infoCard(
    String title,
      BuildContext context,{
    String? subtitle,
    IconData? icon,
    bool isLink = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: AppTheme.whiteAndGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey[300]!, blurRadius: 2.0, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                title,
                style: Styles.boldTextView(16, AppTheme.hintDarkGray),
              ),
            ],
          ),
          if (subtitle != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.openInGoogleMaps();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width/1.3,
                    child: Text(
                      subtitle,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.hintDarkGray,
                        decoration:
                            isLink
                                ? TextDecoration.underline
                                : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget reviewSectionWidget() {
    List ratings = controller.farmerRatings;

    if (ratings.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
        child: Center(
          child: Text(
            "No reviews yet".tr,
            style: Styles.boldTextView(18, Colors.blueGrey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: ratings.length,
        itemBuilder: (context, index) {
          return reviewCard(ratings[index]);
        },
      ),
    );
  }

  Widget reviewCard(review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_circle_outlined, size: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: Styles.boldTextView(13, AppTheme.black),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review['rating']
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 17,
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review['reviewText'],
              style: Styles.regularTextStyle(AppTheme.hintDarkGray, 13),
            ),
          ],
        ),
      ),
    );
  }

  reviewDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder:
          (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(25),
            child: SizedBox(
              height: 400,
              child: Center(
                child: Card(
                  margin: const EdgeInsets.all(20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Review:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Row(
                            children: List.generate(
                              5,
                              (index) => IconButton(
                                icon: Icon(
                                  index < controller.selectedStars.value
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  controller.selectedStars.value = index + 1;
                                },
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          'Add a comment:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: controller.commentController,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(12.0),
                                  border: InputBorder.none,
                                ),
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.lightPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 3,
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.postFarmerRatings();

                                    Get.back();
                                  },
                                  child: const Text(
                                    'Send',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget productDetailsWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ClipRRect(
              child: Builder(
                builder: (context) {
                  try {
                    String base64String =
                        controller.selectedProduct['image']?.toString() ??
                        "".split(',').last;
                    Uint8List imageBytes = base64Decode(base64String);
                    return Image.memory(
                      imageBytes,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.5,
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
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 0,
                    ),
                    child: Text(
                      controller.selectedProduct['quality']?.toString() ?? "",
                      style: TextStyle(color: AppTheme.lightPurple),
                    ),
                  ),
                  labelPadding: EdgeInsets.zero,
                  backgroundColor: Colors.purple.shade50,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.selectedProduct['name']?.toString() ?? "",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    if (controller.selectedProduct['discount_price'] ==
                        null) ...[
                      Text(
                        "SAR ",
                        style: Styles.regularTextView(18, Colors.black26),
                      ),
                      Text(
                        controller.selectedProduct['price']?.toString() ?? "",
                        style: Styles.regularTextView(18, AppTheme.lightPurple),
                      ),
                      Text(
                        '/ Kg   ',
                        style: Styles.normalTextStyle(AppTheme.navGrey, 14),
                      ),
                    ] else ...[
                      Text(
                        "SAR ",
                        style: Styles.regularTextView(18, Colors.black26),
                      ),
                      Text(
                        controller.selectedProduct['discount_price']
                                ?.toString() ??
                            "",
                        style: Styles.regularTextView(18, AppTheme.lightPurple),
                      ),
                      Text(
                        '/ Kg   ',
                        style: Styles.normalTextStyle(AppTheme.navGrey, 14),
                      ),
                      Text(
                        "${controller.selectedProduct['price']?.toString() ?? ""}  SAR",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppTheme.navGrey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  "Production Date : ${controller.selectedProduct['productionDate']?.toString() ?? ""}",
                  style: Styles.normalTextStyle(Colors.black38, 13),
                ),
                const SizedBox(height: 16),
                productDetailsTabBarView(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productDetailsTabBarView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppTheme.lightPurple,
            unselectedLabelColor: Colors.black,
            indicatorColor: AppTheme.lightPurple,
            labelStyle: Styles.normalTextStyle(AppTheme.lightPurple, 14),
            tabs: [Tab(text: 'Description')],
          ),
          Divider(color: AppTheme.hintDarkGray, thickness: 0.5),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: TabBarView(
              children: [
                Text(
                  controller.selectedProduct['description']?.toString() ?? "",
                  style: Styles.normalTextStyle(AppTheme.hintDarkGray, 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget productDetailsNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightGray,
            blurRadius: 0.5,
            spreadRadius: 0.5,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DotsIndicator(
            dotsCount: 2,
            position: 0.0,

            // double.tryParse(controller.productQuantity.value.toString()) ??
            decorator: DotsDecorator(
              size: const Size.square(7.0),
              activeSize: const Size(20.0, 7.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              activeColor: AppTheme.lightPurple,
              color: AppTheme.lightGray,
              spacing: EdgeInsets.symmetric(horizontal: 2),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (controller.productQuantity.value > 0) {
                        controller.productQuantity.value--;
                        Get.snackbar(
                          'Removed',
                          '${controller.selectedProduct['qty'].toString()} quantity Removed',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppTheme.navGrey,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.lightPurple),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(Icons.remove, size: 15),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 10, 15.0, 10.0),
                      child: Text(
                        '${controller.productQuantity.value}',
                        style: Styles.mediumTextView(18, AppTheme.lightPurple),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      int currentQty = controller.productQuantity.value;
                      int availableQty = controller.selectedProduct['qty'];

                      if (currentQty + 1 > availableQty) {
                        Get.snackbar(
                          "Cart",
                          "Cannot add more. Only $availableQty item(s) available.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppTheme.errorTextColor,
                        );
                        return;
                      }

                      controller.productQuantity.value++;

                      Get.snackbar(
                        "Cart",
                        "${controller.productQuantity.value} item(s) updated in the cart.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppTheme.successTextColor,
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.lightPurple),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(Icons.add, size: 15),
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  if (controller.selectedProduct['name'] != null) {
                    if (controller.productQuantity.value + 1 >
                        controller.selectedProduct['qty']) {
                      controller.productQuantity.value =
                          controller.selectedProduct['qty'];
                    }
                    if (controller.productQuantity.value == 0) {
                      controller.productQuantity.value++;
                    }
                    Product product = Product(
                      id: "",
                      name: controller.selectedProduct['name'],
                      price:
                          controller.selectedProduct['discount_price'] == null
                              ? double.parse(
                                controller.selectedProduct['price'].toString(),
                              )
                              : double.parse(
                                controller.selectedProduct['discount_price']
                                    .toString(),
                              ),
                      image: controller.selectedProduct['image'],
                      qty:
                          (controller.productQuantity.value == 0)
                              ? 1
                              : controller.productQuantity.value,
                      prodId: controller.selectedProduct['id'],
                      farmerId:
                          (controller.farmerId.value.isEmpty)
                              ? controller
                                  .selectedProduct["farmDetails"]["farmerId"]
                              : controller.farmerId.value,
                      farmerName: controller.farmerName.value,
                      totalQty: controller.selectedProduct['qty'],
                    );

                    if (!Get.isRegistered<MyCartController>()) {
                      Get.put(MyCartController());
                    }

                    final cartController = Get.find<MyCartController>();
                    cartController.addToCart(product);
                    showDialog(
                      context: context,
                      builder:
                          (BuildContext context) => Dialog(
                            insetPadding: EdgeInsets.all(35),
                            child: SizedBox(
                              height: 180,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                    ),
                                    child: Text(
                                      "Product added successfully",
                                      style: Styles.boldTextView(
                                        24,
                                        AppTheme.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 3,
                                      ),
                                    ),
                                    onPressed: () {
                                      controller.productQuantity.value = 0;
                                      Get.back();
                                      Get.back();
                                      // Get.toNamed(Routes.myCart);
                                    },
                                    child: Text(
                                      'Okay',
                                      style: Styles.boldTextView(
                                        20,
                                        AppTheme.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                    );
                  } else {
                    print('failed');
                    Get.offAllNamed(Routes.dashBoard);
                  }
                },
                child: const Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
