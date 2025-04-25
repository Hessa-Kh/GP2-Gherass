import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/add_product/controller/add_prod_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';
import 'package:gherass/widgets/svg_icon_widget.dart';

class AddProdWidgets {
  var controller = Get.find<AddProdController>();

  String getTitile() {
    return !controller.enableToEdit.value
        ? "Edit product".tr
        : "Add product".tr;
  }

  Widget addProdForm(context) {
    return Obx(
      () => Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10),
        child: ListView(
          children: [
            addProdImage(context),
            SizedBox(height: 10),
            addProdTextField(
              textController: controller.productName,
              hintText: "Product name".tr,
              errorText: '',
            ),
            
            customDropdownWidget(
              categories: controller.categoryList,
              title: 'Category'.tr,
              isEditable: !controller.isEdit.value,
              selectedCategory: controller.selectedCategory,
            ),
            addProdTextField(
              textController: controller.productDescription,
              hintText: "Product description".tr,
              errorText: '',
            ),
            customChoiceWidget(
              options: ["Organizations".tr, "Individuals".tr, "Both".tr],
              title: "Product Visibility ".tr,
              value: controller.productVisibility,
            ),
            customCountWidget(
              title: "Quantity",
              countVal: controller.productQty,
              type: controller.unitSelected.value,
            ),

            customCountWidget(
              title: "Product price",
              countVal: controller.productPrice,
              type: "SAR",
            ),

            customDatePickerTextField(
              context: context,
              startDateController: controller.productionDateController,
              isReadOnly: false,
            ),
            customChoiceWidget(
              options: ["Organic".tr, "Not Organic".tr],
              title: "Product quality ".tr,
              value: controller.productQuality,
            ),
            controller.isEdit.value ? deletebutton() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget addProdImage(context) {
    return GestureDetector(
      onTap: () {
        (!controller.enableToEdit.value)
            ? null
            : controller.pickImagesFromGallery();
      },
      child: Container(
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
        child: SizedBox(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Visibility(
                visible:
                    controller.isEdit.value ||
                    controller.imageDecoded != null ||
                    controller
                        .selectedImagePath
                        .value
                        .isNotEmpty, // Show visibility when one of the conditions is met
                replacement: SizedBox(
                  height: 230,
                  width: 230,
                  child: SvgIcon(
                    ImageUtil.gallery_add,
                  ), // Show this icon when both conditions are empty
                ),
                child: SizedBox(
                  height: 230,
                  width: 230,
                  child:
                      controller
                              .isEdit
                              .value // If "isEdit" is true, show the image from memory
                          ? (controller.imageDecoded != null &&
                                  controller
                                      .imageDecoded!
                                      .isNotEmpty) // Check if imageDecoded is not empty
                              ? Image.memory(
                                controller.imageDecoded!,
                                height: 230,
                                width: 230,
                              )
                              : SizedBox.shrink() // If imageDecoded is empty, show nothing
                          : (controller
                              .selectedImagePath
                              .value
                              .isNotEmpty) // If it's not edit mode, show image from path if available
                          ? Image.file(
                            File(controller.selectedImagePath.value),
                            height: 230,
                            width: 230,
                          )
                          : SizedBox.shrink(), // If there's no image from the path, show nothing
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  (controller.selectedImagePath.value != "")
                      ? "Added product image".tr
                      : "Add product image".tr,
                  style: Styles.mediumTextView(16, AppTheme.navGrey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addProdTextField({
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

  Widget customDropdownWidget({
    required String title,
    required RxList<Map<String, dynamic>> categories,
    required RxString selectedCategory,
    required bool isEditable,
  }) {
    if (!categories.any(
      (category) => category['name'] == selectedCategory.value,
    )) {
      selectedCategory.value =
          categories.isNotEmpty ? categories[0]['name'] : 'others';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: controller.enableToEdit.value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ),
              Obx(() {
                return DropdownButton<String>(
                  value: selectedCategory.value,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(height: 2, color: Colors.transparent),
                  onChanged:
                      controller.enableToEdit.value
                          ? (String? newValue) {
                            if (newValue != null) {
                              selectedCategory.value = newValue;
                            }
                          }
                          : null,
                  items:
                      categories.map<DropdownMenuItem<String>>((category) {
                        return DropdownMenuItem<String>(
                          value: category['name'],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(category['name']),
                          ),
                        );
                      }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget customChoiceWidget({
    required List<String> options,
    required String title,
    required RxString value,
    int initialSelectedIndex = 0,
  }) {
    RxInt selectedIndex = initialSelectedIndex.obs;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: (!controller.enableToEdit.value) ? 80 : 100,
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
                        child: Text(
                          title,
                          style: Styles.mediumTextView(16, AppTheme.navGrey),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(options.length, (index) {
                          return Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFECE4D7),
                                    offset: Offset(0, 4),
                                    blurRadius: 6.0,
                                    spreadRadius: 2.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: RawChip(
                                selectedShadowColor: null,
                                label: Text(options[index]),
                                selected: selectedIndex.value == index,
                                onSelected: (bool selected) {
                                  selectedIndex.value = selected ? index : -1;
                                  value.value = options[index];

                                  if (title == "Product Visibility ") {
                                    controller.productVisibility.value =
                                        value.value;
                                  } else {
                                    controller.productQuality.value =
                                        value.value;
                                  }
                                },
                                selectedColor: AppTheme.borderColor,
                                labelStyle: TextStyle(color: Colors.black),
                                backgroundColor:
                                    selectedIndex.value == index
                                        ? AppTheme.primaryColor
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value.value,
                          style: Styles.mediumTextView(16, AppTheme.navGrey),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget customCountWidget({
    required String title,
    required RxInt countVal,
    required String type,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height:
            (!controller.enableToEdit.value)
                ? 80
                : title.contains("Quantity")
                ? 150
                : 100,
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
          child: Obx(
            () =>
                controller.enableToEdit.value
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
                              if (title.contains("Quantity"))
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFECE4D7),
                                            offset: Offset(0, 4),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(
                                          40.0,
                                        ),
                                      ),
                                      child: RawChip(
                                        label: Text("Kg"),
                                        selected: controller.isKgSelected.value,
                                        onSelected: (selected) {
                                          controller.isKgSelected.value =
                                              selected;
                                          controller.unitSelected.value = "Kg";
                                        },
                                        selectedColor: AppTheme.borderColor,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFECE4D7),
                                            offset: Offset(0, 4),
                                            blurRadius: 6.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(
                                          40.0,
                                        ),
                                      ),
                                      child: RawChip(
                                        label: Text("Gram"),
                                        selected:
                                            !controller.isKgSelected.value,
                                        onSelected: (selected) {
                                          controller.isKgSelected.value =
                                              !selected;
                                          controller.unitSelected.value =
                                              "Gram";
                                        },
                                        selectedColor: AppTheme.borderColor,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                countVal.value++;
                              },
                              child: buildActionButton("+"),
                            ),

                            SizedBox(
                              width: 50,
                              child: TextFormField(
                                key: ValueKey(countVal.value),
                                initialValue: countVal.value.toString(),
                                readOnly: !controller.enableToEdit.value,
                                keyboardType: TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                textAlign: TextAlign.center,
                                style: Styles.boldTextView(16, AppTheme.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (v) {
                                  countVal.value = int.tryParse(v) ?? 0;
                                },
                              ),
                            ),

                            Visibility(
                              visible: title == "Quantity",
                              replacement: Text(
                                "SAR",
                                style: Styles.boldTextView(16, AppTheme.black),
                              ),
                              child: Text(
                                " ${controller.unitSelected.value}",
                                style: Styles.boldTextView(16, AppTheme.black),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                if (countVal.value > 0) {
                                  countVal.value--;
                                }
                              },
                              child: buildActionButton("-"),
                            ),
                          ],
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            title == "Quantity"
                                ? '${countVal.value} ${controller.unitSelected.value}'
                                : '${countVal.value} $type',
                            style: Styles.mediumTextView(16, AppTheme.navGrey),
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(String symbol) {
    return Container(
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
        child: Text(symbol, style: Styles.boldTextView(20, AppTheme.black)),
      ),
    );
  }

  Widget deletebutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: GestureDetector(
        onTap: () {
          showEditConfirmationDialog(title: "Delete Product");
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
                  "Delete Product".tr,
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

  Widget addProdbottomNaviWidget() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        child:
            (controller.isEdit.value)
                ? (controller.enableToEdit.value)
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                                style: Styles.mediumTextView(
                                  16,
                                  AppTheme.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.updateProduct();
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
                                "Update".tr,
                                style: Styles.mediumTextView(
                                  16,
                                  AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                style: Styles.mediumTextView(
                                  16,
                                  AppTheme.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showEditConfirmationDialog(title: "Confirm Edit?");
                            controller.showPrefixIcon.value = true;
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
                                style: Styles.mediumTextView(
                                  16,
                                  AppTheme.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.postProducts();
                        controller.inventoryController.showMore();
                      },
                      child: Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryButtonColor,
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
                            "Add".tr,
                            style: Styles.mediumTextView(16, AppTheme.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.getInventoryProducts();
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
                  ],
                ),
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
                    controller.deleteProduct();
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

  Widget customDatePickerTextField({
  required BuildContext context,
  required TextEditingController startDateController,
  required bool isReadOnly,
}) {
  Future<void> selectStartDate() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime oneWeekAgo = today.subtract(const Duration(days: 7));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: today,         // Default to today
      firstDate: oneWeekAgo,      // Min: a week ago
      lastDate: today,            // Max: today
    );

    if (picked != null) {
      startDateController.text = "${picked.toLocal()}".split(' ')[0];
    }
  }


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !controller.enableToEdit.value
              ? Text("", style: TextStyle(fontSize: 18))
              : Text("Production Date".tr, style: TextStyle(fontSize: 18)),
          GestureDetector(
            onTap: !controller.enableToEdit.value ? null : selectStartDate,
            child: AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        controller.enableToEdit.value
                            ? Colors.white
                            : AppTheme.borderColor,
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
      readOnly: !controller.enableToEdit.value,
      onTap: () async {
        if (controller.enableToEdit.value) {
          DateTime now = DateTime.now();
          DateTime today = DateTime(now.year, now.month, now.day);
          DateTime oneWeekAgo = today.subtract(const Duration(days: 7));

          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: today,
            firstDate: oneWeekAgo,
            lastDate: today,
          );

          if (picked != null) {
            startDateController.text = "${picked.toLocal()}".split(' ')[0];
          }
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.arrow_drop_down),
        suffixIcon: const Icon(Icons.calendar_month),
        fillColor: controller.enableToEdit.value
            ? Colors.white
            : AppTheme.borderColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        hintStyle: Styles.mediumTextView(
          16,
          AppTheme.navGrey,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
      ),
    ),
  ),
),

                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
