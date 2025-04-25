import 'dart:convert';

import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/add_product/view/widgets/add_prod_widgets.dart';
import 'package:gherass/module/inventory/controller/inventory_controller.dart';
import 'package:gherass/module/promotions/controller/promotions_contoller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';
import 'package:gherass/widgets/svg_icon_widget.dart';
import 'dart:typed_data';

class InventoryWidget {
  var controller = Get.find<InventoryController>();
  var promotionsController = Get.find<PromotionsController>();

  Widget inventoryListWidget() {
    return Obx(() {
      return (!controller.isShowprodList.value)
          ? Container(
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Products".tr,
                  style: Styles.mediumTextView(15, AppTheme.navGrey),
                ),
              ),
              Expanded(
                child: inventoryCard(
                  controller.farmerProducts.toList(),
                  false,
                  5,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  controller.showMore();
                },
                splashColor: Colors.grey.withOpacity(0.2),
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightGray,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "show more".tr,
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 500,
          child: inventoryCard(
            controller.farmerProducts.toList(),
            true,
            controller.farmerProducts.length,
          ),
        ),
      );
    });
  }


  Widget statisticProdListWidget() {
    return (!controller.isShowprodList.value)
        ? Container(
          height: 350,
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Products".tr,
                    style: Styles.mediumTextView(15, AppTheme.navGrey),
                  ),
                ),
                Builder(
                  builder: (context) {
                    return Expanded(
                      child: Obx(
                        () => inventoryCard(
                          controller.farmerProducts.toList(),
                          false,
                          controller.farmerProducts.length,
                          isStatistics: true
                        ),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  onTap: () {
                    controller.showMore();
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: <BoxShadow>[
                        BoxShadow(color: AppTheme.lightGray, blurRadius: 10),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        controller.showMore();
                      },
                      splashColor: Colors.grey.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "show more".tr,
                            style: TextStyle(fontSize: 12, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 500,
            child: Obx(
              () => inventoryCard(
                controller.farmerProducts.toList(),
                true,
                controller.farmerProducts.length,
                  isStatistics: true
              ),
            ),
          ),
        );
  }

  Widget inventoryCard(List farmData, bool isSroll, int listCount,{bool? isStatistics}) {
    int actualCount = farmData.isNotEmpty ? farmData.length : 0;

    if (actualCount == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 60,
              color: Colors.grey,
            ), // Placeholder icon
            SizedBox(height: 10),
            Text(
              "No products available".tr,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Visibility(
          visible: isStatistics==true?true:false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Proudct ".tr,style: Styles.boldTextView(12, AppTheme.hintDarkGray),),
              Text("Price ".tr,style: Styles.boldTextView(12, AppTheme.hintDarkGray),),
              Text("Total Quantity  ".tr,style: Styles.boldTextView(12, AppTheme.hintDarkGray),),
            ],
          ),
        ),
        ListView.builder(
          physics: !isSroll ? NeverScrollableScrollPhysics() : ScrollPhysics(),
          itemCount: actualCount,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            RxInt selectedProdName = 0.obs;
            if (promotionsController.promotionProductName.value ==
                farmData[index]['name']) {
              promotionsController.selectedProductId.value = farmData[index]['id'];
              promotionsController.selectedProduct.value = farmData[index];
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap:
                                promotionsController.enableToEdit.value == true
                                    ? () {
                                      selectedProdName.value = index;
                                      promotionsController.selectedProductId.value =
                                          farmData[index]['id'];
                                      promotionsController.selectedProduct.value =
                                          farmData[index];
                                      promotionsController
                                          .promotionProductName
                                          .value = farmData[index]['name'];
                                    }
                                    : null,
                            child: Obx(
                              () => CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.transparent,
                                child:
                                    promotionsController
                                                .promotionProductName
                                                .value !=
                                            farmData[index]['name']
                                        ? SvgIcon(ImageUtil.uncheckBox, size: 17)
                                        : Icon(
                                          Icons.check_box,
                                          color: AppTheme.black,
                                        ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Builder(
                                builder: (context) {
                                  try {
                                    String? base64String = farmData[index]['image'];

                                    if (base64String == null ||
                                        base64String.isEmpty) {
                                      throw Exception("Image data is empty");
                                    }

                                    Uint8List imageBytes = base64Decode(
                                      base64String,
                                    );

                                    return Image.memory(
                                      imageBytes,
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                    );
                                  } catch (e) {
                                    return Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            farmData[index]['name'],
                            style: Styles.mediumTextView(15, AppTheme.navGrey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: isStatistics==true?true:false,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xffF5F2FF),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 12),
                                child: Text(farmData[index]['price'].toString(),style: Styles.boldTextView(10, AppTheme.lightPurple),),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: isStatistics==true?true:false,
                              child: SizedBox(width: 80,)),
                          Visibility(
                            visible: isStatistics==true?true:false,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xffF5F2FF),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3.0,horizontal: 12),
                                child: Text(controller.fetchTotalQuantity(farmData[index]['name'].toString()),
                                  style: Styles.boldTextView(10, AppTheme.lightPurple),),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(
                                Routes.addProdForm,
                                arguments: [farmData[index]],
                              );
                            },
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Stack(
                                children: [
                                  Center(child: Image.asset(ImageUtil.frame)),
                                  Center(
                                    child: SvgIcon(ImageUtil.editPen, size: 17),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isStatistics==true?false:true,
                            replacement: SizedBox.shrink(),
                            child: InkWell(
                              onTap: () {
                                showDeleteConfirmationDialog(
                                  title: "Delete Product".tr,
                                  productId: farmData[index]["id"],
                                );
                              },
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: Stack(
                                  children: [
                                    Center(child: Image.asset(ImageUtil.frame_red)),
                                    Center(child: SvgIcon(ImageUtil.trash, size: 17)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (index != farmData.length - 1)
                  Divider(color: Colors.grey, height: 1, thickness: 1),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget customInventoryButton({
    required String title,
    required String icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
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
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onPressed,
          splashColor: Colors.grey.withOpacity(0.2),
          child: Row(
            children: [
              SizedBox(width: 20),
              SvgIcon(icon, color: Colors.black),
              SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customInventoryButtonList() {
    return Column(
      children: [
        SizedBox(height: 10),
        customInventoryButton(
          title: "Sales statistics".tr,
          icon: ImageUtil.statistics,
          onPressed: () {
            Get.toNamed(Routes.salesStatistics);
          },
        ),
        customInventoryButton(
          title: "Farm ratings".tr,
          icon: ImageUtil.ranking,
          onPressed: () {
            Get.toNamed(Routes.farmRating);
          },
        ),
        customInventoryButton(
          title: "Promotions".tr,
          icon: ImageUtil.discount,
          onPressed: () {
            Get.toNamed(Routes.promotion);
          },
        ),
      ],
    );
  }

  Widget inventoryBody() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 100, top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!controller.isShowprodList.value)
              Column(
                children: [
                  InventoryWidget().inventoryListWidget(),
                  InventoryWidget().customInventoryButtonList(),
                ],
              )
            else
              InventoryWidget().inventoryListWidget(),
          ],
        ),
      ),
    );
  }

  Widget statisticBody(context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                inventoryListWidget(),
                AddProdWidgets().addProdTextField(
                  textController: null,
                  hintText: 'Description '.tr,
                  errorText: '',
                ),
                AddProdWidgets().customCountWidget(
                  title: 'New Price'.tr,
                  countVal: 0.obs ,
                  type: '',
                ),
                customDatePickerTextField(
                  context: context,
                  startDateController: controller.startDateController,
                  endDateController: controller.endDateController,
                  isReadOnly: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget farmRatingBody(context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Visibility(
              visible: controller.farmLogo.isEmpty,
              replacement: ClipOval(
                child: Image.memory(
                  base64Decode(controller.farmLogo.value),
                  height: 100,
                  width: 100,
                  fit: BoxFit.fill,
                ),
              ),
              child: SvgIcon(ImageUtil.profile_circle, size: 75),
            ),
            Text(controller.farmName.value),
            SizedBox(height: 20),
            Container(
              height: 320,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFECE4D7),
                    offset: Offset(0, 4),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Customer Ratings".tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ratingWidget(
                          initialRating: controller.farmRatings.value,
                          onRatingChanged: (v) {},
                          showRating: true,
                          showPercentage: false,
                          isReadOnly: true,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "${controller.farmerRatings.length} Ratings".tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        ratingWidget(
                          initialRating: 5,
                          onRatingChanged: (v) {},
                          showRating: false,
                          showPercentage: true,
                          isReadOnly: true,
                            percentage: "${controller.fetchRatingPercentage(5.0)}%"
                        ),
                        SizedBox(height: 10),
                        ratingWidget(
                          initialRating: 4,
                          onRatingChanged: (v) {},
                          showRating: false,
                          showPercentage: true,
                          isReadOnly: true,
                            percentage: "${(int.parse(controller.fetchRatingPercentage(4.0))+int.parse(controller.fetchRatingPercentage(4.5)))}%"
                        ),
                        SizedBox(height: 10),
                        ratingWidget(
                          initialRating: 3,
                          onRatingChanged: (v) {},
                          showRating: false,
                          showPercentage: true,
                          isReadOnly: true,
                            percentage: "${(int.parse(controller.fetchRatingPercentage(3.0))+int.parse(controller.fetchRatingPercentage(3.5)))}%"
                        ),
                        SizedBox(height: 10),
                        ratingWidget(
                          initialRating: 2,
                          onRatingChanged: (v) {},
                          showRating: false,
                          showPercentage: true,
                          isReadOnly: true,
                            percentage: "${(int.parse(controller.fetchRatingPercentage(2.0))+int.parse(controller.fetchRatingPercentage(2.5)))}%"
                        ),
                        SizedBox(height: 10),
                        ratingWidget(
                          initialRating: 1,
                          onRatingChanged: (v) {},
                          showRating: false,
                          showPercentage: true,
                          isReadOnly: true,
                            percentage: "${(int.parse(controller.fetchRatingPercentage(1.0))+int.parse(controller.fetchRatingPercentage(1.5)))}%"
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.farmerRatings.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.borderColor,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFECE4D7),
                          offset: Offset(0, 4),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(Icons.abc_sharp),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.farmerRatings[index]["name"]
                                    .toString(),
                              ),
                              Row(
                                children: [
                                  ratingWidget(
                                    initialRating:
                                        controller
                                            .farmerRatings[index]["rating"],
                                    onRatingChanged: (v) {},
                                    showRating: false,
                                    showPercentage: false,
                                    isReadOnly: true,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                controller.farmerRatings[index]['reviewText'],
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget ratingWidget({
    required double initialRating,
    required Function(double) onRatingChanged,
    required bool showRating,
    required bool showPercentage,
    required bool isReadOnly,
     dynamic  iconSize,
     dynamic  percentage,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
                percentage?? '${(initialRating * 20).toStringAsFixed(0)}%',
              style: TextStyle(fontSize: 14),
            ),
          ),
        AnimatedRatingStars(
          readOnly: isReadOnly,
          initialRating: initialRating,
          onChanged: onRatingChanged,
          displayRatingValue: showPercentage,
          interactiveTooltips: true,
          customFilledIcon: Icons.star,
          customHalfFilledIcon: Icons.star_half,
          customEmptyIcon: Icons.star_border,
          starSize: iconSize??20.0,
          animationDuration: const Duration(milliseconds: 500),
          animationCurve: Curves.easeInOut,
        ),
        if (showRating)
          Text(
            initialRating.toStringAsFixed(1),
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  Widget customDatePickerTextField({
    required BuildContext context,
    required TextEditingController startDateController,
    required TextEditingController endDateController,
    required bool isReadOnly,
  }) {
    Future<void> selectStartDate() async {
      DateTime initialDate = DateTime.now();
      DateTime firstDate = DateTime(1900);
      DateTime lastDate = DateTime(2100);

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (picked != null && picked != initialDate) {
        startDateController.text = "${picked.toLocal()}".split(' ')[0];
      }
    }

    Future<void> selectEndDate() async {
      DateTime initialDate = DateTime.now();
      DateTime firstDate = DateTime(1900);
      DateTime lastDate = DateTime(2100);

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (picked != null && picked != initialDate) {
        endDateController.text = "${picked.toLocal()}".split(' ')[0];
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Start Date
          Text("Start Date".tr, style: TextStyle(fontSize: 18)),
          GestureDetector(
            onTap: (isReadOnly) ? null : selectStartDate,
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFECE4D7),
                        offset: Offset(0, 4),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.arrow_drop_down),
                          suffixIcon: Icon(Icons.calendar_month),
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
                          hintStyle: Styles.mediumTextView(
                            16,
                            AppTheme.navGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          // End Date
          Text("End Date".tr, style: TextStyle(fontSize: 18)),
          GestureDetector(
            onTap: (isReadOnly) ? null : selectEndDate,
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFECE4D7),
                        offset: Offset(0, 4),
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: endDateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.arrow_drop_down),
                          suffixIcon: Icon(Icons.calendar_month),
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
                          hintStyle: Styles.mediumTextView(
                            16,
                            AppTheme.navGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog({
    required String title,
    required String productId,
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
                  controller.deleteProduct(productId);
                  Get.back();
                  controller.getInventoryProducts();
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
}
