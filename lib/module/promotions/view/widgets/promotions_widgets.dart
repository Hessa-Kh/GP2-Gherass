import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/inventory/view/widgets/inventory_widgets.dart';
import 'package:gherass/module/promotions/controller/promotions_contoller.dart';
import 'package:gherass/theme/styles.dart';

import '../../../../helper/routes.dart';
import '../../../../theme/app_theme.dart';
import '../../../../util/image_util.dart';
import '../../../../widgets/svg_icon_widget.dart';

class PromotionsWidgets {
  var controller = Get.find<PromotionsController>();

  Widget promotionBody(context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                InventoryWidget().inventoryListWidget(),
                customTextField(
                  textController: controller.promotionDescription,
                  hintText: 'Description'.tr,
                  errorText: '',
                ),
                customCountWidget(title: "New Price: ".tr),
                InventoryWidget().customDatePickerTextField(
                  context: context,
                  startDateController: controller.startDateController,
                  endDateController: controller.endDateController,
                  isReadOnly: !controller.enableToEdit.value,
                ),

                controller.isEdit.value ? deletebutton() : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField({
    required textController,
    required String hintText,
    required String errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Obx(
        () => Container(
          height: 80,
          decoration: BoxDecoration(
            color:
                controller.enableToEdit.value
                    ? Colors.white
                    : AppTheme.borderColor,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.center,
              child: TextFormField(
                readOnly: !controller.enableToEdit.value,
                controller: textController,
                style: Styles.boldTextView(16, Color(0xff797D82)),
                decoration: InputDecoration(
                  fillColor:
                      controller.enableToEdit.value
                          ? Colors.white
                          : AppTheme.borderColor,
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
                  hintText: hintText,
                  hintStyle: Styles.mediumTextView(16, AppTheme.navGrey),
                  contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                  // errorText: textController.value.isNotEmpty ? errorText : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customCountWidget({required String title}) {
    if (controller.isEdit.value == false) {
      controller.promotionNewPrice.text =
          controller.newPriceValue.value.toString();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color:
              controller.enableToEdit.value
                  ? Colors.white
                  : AppTheme.borderColor,
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child:
              (controller.enableToEdit.value)
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: Styles.mediumTextView(
                                16,
                                AppTheme.navGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.newPriceValue.value++;
                              controller.promotionNewPrice.text =
                                  controller.newPriceValue.value.toString();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
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
                              child: Center(
                                child: Text(
                                  "+",
                                  style: Styles.boldTextView(
                                    20,
                                    AppTheme.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: TextField(
                                  readOnly: !controller.enableToEdit.value,
                                  controller: controller.promotionNewPrice,
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: Styles.boldTextView(
                                    16,
                                    AppTheme.black,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Text(
                                "SAR".tr,
                                style: Styles.boldTextView(
                                  16,
                                  AppTheme.hintDarkGray,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.newPriceValue.value > 0) {
                                controller.newPriceValue.value--;
                                controller.promotionNewPrice.text =
                                    controller.newPriceValue.value.toString();
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 40,
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
                              child: Center(
                                child: Text(
                                  "-",
                                  style: Styles.boldTextView(
                                    20,
                                    AppTheme.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          title,
                          style: Styles.mediumTextView(16, AppTheme.navGrey),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            child: TextField(
                              readOnly: !controller.enableToEdit.value,
                              controller: controller.promotionNewPrice,
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textAlign: TextAlign.end,
                              style: Styles.boldTextView(16, Color(0xff797D82)),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Text(
                            "SAR".tr,
                            style: Styles.boldTextView(16, Color(0xff797D82)),
                          ),
                        ],
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget promotionsListWidget(context) {
    List farmData = controller.promotionsList.toList();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: RefreshIndicator(
        onRefresh: () async {
          controller.getPromotionsList();
        },
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: farmData.length ?? 0,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                controller.updateFields(farmData[index]);
                Get.toNamed(Routes.editPromotion);
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 275,
                          child: Text(
                            farmData[index]["product"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.boldTextView(24, AppTheme.black),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Text(
                                "${farmData[index]["start_date"]}",
                                style: Styles.boldTextView(
                                  16,
                                  Color(0xff797D82),
                                ),
                              ),
                              Text(
                                " -",
                                style: Styles.boldTextView(
                                  16,
                                  Color(0xff797D82),
                                ),
                              ),
                              Text(
                                "${farmData[index]["end_date"]}",
                                style: Styles.boldTextView(
                                  16,
                                  Color(0xff797D82),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Promotion Details: ".tr,
                              style: Styles.boldTextView(16, Color(0xff797D82)),
                            ),
                            SizedBox(
                              width: 194,
                              child: Text(
                                "${farmData[index]["description"]}",
                                style: Styles.boldTextView(
                                  16,
                                  Color(0xff797D82),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "New Price: ".tr,
                              style: Styles.boldTextView(16, Color(0xff797D82)),
                            ),
                            SizedBox(
                              width: 194,
                              child: Text(
                                "${farmData[index]["new_price"]} ${"SAR".tr}",
                                style: Styles.boldTextView(
                                  16,
                                  Color(0xff797D82),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listingPromoBottomNaviWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              controller.isEdit.value = false;
              controller.enableToEdit.value = true;
              controller.promotionNewPrice.clear();
              controller.startDateController.clear();
              controller.promotionDescription.clear();
              controller.promotionProductName.value = "";
              controller.newPriceValue.value = 1;
              Get.toNamed(Routes.addPromotion);
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: AppTheme.lightPurple,
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
                child: Text(
                  "Add Promotion".tr,
                  style: Styles.mediumTextView(16, AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget deletebutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: GestureDetector(
        onTap: () {
          showEditConfirmationDialog(title: "Delete Promotion?");
        },
        child: Container(
          height: 60,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Delete Promotion",
                  style: Styles.mediumTextView(16, AppTheme.errorTextColor),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    children: [
                      Center(child: Image.asset(ImageUtil.frame_red)),
                      Center(child: SvgIcon(ImageUtil.trash, size: 17)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget editPromotionBottomNaviWidget() {
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      child:
          (controller.enableToEdit.value)
              ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: 150,
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
                      child: Center(
                        child: Text(
                          "Cancel".tr,
                          style: Styles.mediumTextView(16, AppTheme.black),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      controller.updatePromotions();
                      // showEditConfirmationDialog(
                      //     title: "Edited successfully");
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.lightPurple,
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
                        child: Text(
                          "Save".tr,
                          style: Styles.mediumTextView(16, AppTheme.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50,
                      width: 150,
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
                      child: Center(
                        child: Text(
                          "Cancel".tr,
                          style: Styles.mediumTextView(16, AppTheme.black),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showEditConfirmationDialog(title: "Confirm Edit?");
                    },
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppTheme.lightPurple,
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
                        child: Text(
                          "Edit".tr,
                          style: Styles.mediumTextView(16, AppTheme.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget addPromoBottomNaviWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              controller.createPromotion();
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                color: AppTheme.lightPurple,
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
                child: Text(
                  "Add Promotion".tr,
                  style: Styles.mediumTextView(16, AppTheme.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showEditConfirmationDialog({required String title}) {
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
                  "Cancel",
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
                  if (title == "Confirm Edit?") {
                    controller.enableToEdit.value = true;
                    Get.back();
                  } else {
                    controller.deletePromotion();
                  }
                },
                child: Text(
                  "Yes",
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
