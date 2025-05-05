import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/cart/controller/my_cart_controller.dart';
import 'package:gherass/module/cart/model/cart_model.dart';
import 'package:gherass/module/cart/view/payment_screen.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:intl/intl.dart';

class MyCartWidgets {
  var controller = Get.find<MyCartController>();
  Widget myCartWidget(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.getCartProducts("");
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Bag".tr, style: Styles.boldTextView(20, AppTheme.black)),
              Text(
                "Products".tr,
                style: Styles.normalTextStyle(AppTheme.hintDarkGray, 16),
              ),
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      controller.myCartList.isEmpty
                          ? 1
                          : controller.myCartList.length,
                  itemBuilder: (context, index) {
                    if (controller.myCartList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_2,
                              size: 60,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "No products Added".tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    var itemData = controller.myCartList[index];
                    return productItem(itemData);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Expected Delivery Date".tr,
                style: Styles.normalTextStyle(AppTheme.black, 16),
              ),
              const SizedBox(height: 10),
              Obx(
                () => dateSelector(context, controller.selectedDate.value, (
                  newDate,
                ) {
                  controller.selectedDate.value = newDate;
                }),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    timeSlotButton(
                      timeSlot: "8 AM - 11 AM",
                      selectedTime: controller.selectedTime.value,
                      onTap: (selected) {
                        controller.selectedTime.value = selected;
                      },
                    ),
                    timeSlotButton(
                      timeSlot: "12 PM - 2 PM",
                      selectedTime: controller.selectedTime.value,
                      onTap: (selected) {
                        controller.selectedTime.value = selected;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    timeSlotButton(
                      timeSlot: "2 PM - 4 PM",
                      selectedTime: controller.selectedTime.value,
                      onTap: (selected) {
                        controller.selectedTime.value = selected;
                      },
                    ),
                    timeSlotButton(
                      timeSlot: "4 PM - 6 PM",
                      selectedTime: controller.selectedTime.value,
                      onTap: (selected) {
                        controller.selectedTime.value = selected;
                      },
                    ),
                    timeSlotButton(
                      timeSlot: "6 PM - 8 PM",
                      selectedTime: controller.selectedTime.value,
                      onTap: (selected) {
                        controller.selectedTime.value = selected;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery Location".tr,
                    style: Styles.normalTextStyle(AppTheme.black, 16),
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.adddress.value.isNotEmpty) {
                        Get.toNamed(
                          Routes.deliverylocation,
                          arguments: controller.currentDeliveryAddress,
                        );
                      } else {
                        Get.dialog(
                          AlertDialog(
                            title: Text("No Delivery Address".tr),
                            content: Text(
                              "Please add a delivery address before continuing."
                                  .tr,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text("Cancel".tr),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  Get.back();
                                  Get.toNamed(Routes.deliveryAddress);
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppTheme.lightPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text("Add Now".tr),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Change".tr,
                      style: Styles.normalTextStyle(AppTheme.primaryColor, 16),
                    ),
                  ),
                ],
              ),
              Obx(
                () =>
                    controller.isLoadingAddress.value
                        ? Center(child: CircularProgressIndicator())
                        : ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.lightBlue.shade50,
                            child: const Icon(
                              Icons.location_on_outlined,
                              color: AppTheme.black,
                            ),
                          ),
                          title: Text(
                            (controller
                                        .currentDeliveryAddress
                                        .values
                                        .isNotEmpty &&
                                    controller.adddress.value.isNotEmpty)
                                ? controller.adddress.value
                                : "No delivery location selected.".tr,
                            style: Styles.normalTextStyle(AppTheme.black, 16),
                          ),
                        ),
              ),

              // Obx(
              //   () => Stack(
              //     children: [
              //       Visibility(
              //         visible:
              //             (controller
              //                         .currentDeliveryAddress
              //                         .values
              //                         .isNotEmpty &&
              //                     controller.adddress.value.isNotEmpty)
              //                 ? false
              //                 : true,
              //         child: Center(child: CircularProgressIndicator()),
              //       ),
              //       ListTile(
              //         leading: CircleAvatar(
              //           backgroundColor: Colors.lightBlue.shade50,
              //           child: const Icon(
              //             Icons.location_on_outlined,
              //             color: AppTheme.black,
              //           ),
              //         ),
              //         title: Text(
              //           (controller.currentDeliveryAddress.values.isNotEmpty &&
              //                   controller.adddress.value.isNotEmpty)
              //               ? controller.adddress.value
              //               : "please change your Delivery Address".tr,
              //           style: Styles.normalTextStyle(AppTheme.black, 16),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const Divider(color: AppTheme.whiteAndGrey),
              Obx(() => summary()),
              const SizedBox(height: 20),

              Obx(
                () => paymentMethod((method) {
                  controller.selectedPaymentMethod.value = method;
                }, controller.selectedPaymentMethod.value),
              ),

              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (controller.myCartList.isNotEmpty)
                            ? AppTheme.lightPurple
                            : AppTheme.hintDarkGray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    (controller.myCartList.isNotEmpty)
                        ? confirmOrderDailogue(context)
                        : null;
                  },
                  child: Row(
                    children: [
                      Spacer(),
                      Text(
                        "Complete Order".tr,
                        style: Styles.normalTextStyle(AppTheme.white, 16),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward,
                        color: AppTheme.white,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget productItem(Product product) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    style: Styles.normalTextStyle(AppTheme.hintDarkGray, 16),
                  ),
                  Center(
                    child: ClipRRect(
                      child: Builder(
                        builder: (context) {
                          try {
                            String base64String = product.image.toString();
                            Uint8List imageBytes = base64Decode(base64String);
                            return Image.memory(
                              imageBytes,
                              width: 90,
                              height: 90,
                              fit: BoxFit.fill,
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
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        product.price.toString(),
                        style: Styles.normalTextStyle(
                          AppTheme.primaryColor,
                          16,
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          controller.updateQuantity(product, product.qty - 1);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        product.qty.toString(),
                        style: Styles.boldTextView(20, AppTheme.black),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          controller.updateQuantity(product, product.qty + 1);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightPurple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
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
        Divider(color: AppTheme.whiteAndGrey),
      ],
    );
  }

  Widget dateSelector(
    BuildContext context,
    String selectedDate,
    Function(String) onDateSelected,
  ) {
    DateTime now = DateTime.now();
    DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);

    DateTime parsedDate =
        selectedDate.isNotEmpty
            ? DateFormat('dd-MM-yyyy').parse(selectedDate)
            : tomorrow;

    String displayDate = selectedDate.isEmpty ? "Select Date" : selectedDate;

    return GestureDetector(
      onTap: () async {
        if (controller.myCartList.isNotEmpty) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: parsedDate.isBefore(tomorrow) ? tomorrow : parsedDate,
            firstDate: tomorrow,
            lastDate: DateTime(now.year, 12, 31),
          );

          if (pickedDate != null) {
            onDateSelected(DateFormat('dd-MM-yyyy').format(pickedDate));
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: selectedDate.isEmpty ? Colors.grey[200] : AppTheme.lightPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.calendar_today,
              color: selectedDate.isEmpty ? Colors.black : Colors.white,
            ),
            Text(
              displayDate,
              style: TextStyle(
                color: selectedDate.isEmpty ? Colors.black : Colors.white,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: selectedDate.isEmpty ? Colors.black : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  String formatPrice(double price) {
    return "${price.toStringAsFixed(2)} SAR"; // Format as "XX.XX SAR"
  }

  Widget summary() {
    double totalAmount = controller.totalPrice + controller.deliveryCharge;

    return Column(
      children: [
        summaryRow("Total".tr, formatPrice(controller.totalPrice)),
        if (controller.totalPrice > 0.0)
          summaryRow("Delivery".tr, formatPrice(controller.deliveryCharge)),
        Divider(),
        summaryRow(
          "Total Amount".tr,
          formatPrice(controller.totalPrice != 0.0 ? totalAmount : 0.0),
          isBold: true,
        ),
      ],
    );
  }

  Widget paymentMethod(Function(String) onChanged, String selectedValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Method".tr,
          style: Styles.regularTextView(16, AppTheme.black),
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            paymentOption("ApplePay".tr, onChanged, selectedValue),
            paymentOption("Cash".tr, onChanged, selectedValue),
          ],
        ),
      ],
    );
  }

  Widget paymentOption(
    String method,
    Function(String) onChanged,
    String selectedValue,
  ) {
    return Row(
      children: [
        Radio<String>(
          value: method,
          groupValue: selectedValue,
          onChanged: (String? value) {
            if (value != null) {
              onChanged(value);
            }
          },
          activeColor: Colors.green,
        ),
        const SizedBox(width: 5),
        Text(method, style: Styles.regularTextView(15, AppTheme.black)),
      ],
    );
  }

  Widget summaryRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                isBold
                    ? Styles.regularTextView(15, AppTheme.black)
                    : Styles.normalTextStyle(AppTheme.black, 15),
          ),
          Text(
            amount,
            style:
                isBold
                    ? Styles.regularTextView(15, AppTheme.black)
                    : Styles.normalTextStyle(AppTheme.black, 15),
          ),
        ],
      ),
    );
  }

  Widget timeSlotButton({
    required String timeSlot,
    required String selectedTime,
    required Function(String) onTap,
  }) {
    return InkWell(
      onTap: () {
        if (controller.myCartList.isNotEmpty) {
          onTap(timeSlot);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color:
              selectedTime == timeSlot
                  ? AppTheme.lightPurple
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          timeSlot,
          style: Styles.normalTextStyle(
            selectedTime == timeSlot
                ? AppTheme.whiteAndGrey
                : AppTheme.hintDarkGray,
            12,
          ),
        ),
      ),
    );
  }

  confirmOrderDailogue(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => Dialog(
            insetPadding: EdgeInsets.all(35),
            child: SizedBox(
              height: 180,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Complete Order".tr,
                    style: Styles.boldTextView(24, AppTheme.black),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.lightGray,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Cancel".tr,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          if (controller.selectedPaymentMethod.value ==
                              "ApplePay") {
                            Get.back();
                            final finalAmt =
                                controller.totalPrice +
                                controller.deliveryCharge;
                            Get.to(
                              () => PaymentScreen(
                                totalAmount: finalAmt.toString(),
                              ),
                            );
                          } else {
                            controller.placeOrder();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.lightGray,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Yes".tr,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void showPremiumSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.withOpacity(0.1),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.check_circle, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 20),

              Text(
                "Order Completed",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
