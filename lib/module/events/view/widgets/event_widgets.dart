import 'package:adoptive_calendar/adoptive_calendar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/events/controller/event_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';
import 'package:gherass/util/image_util.dart';
import 'package:gherass/widgets/svg_icon_widget.dart';


class EventWidgets {
  var controller = Get.find<EventController>();

  Widget eventWidgetBody(context) {
    return Obx(
      () => Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10),
        child: ListView(
          children: [
            addProdTextField(
              textController: controller.eventNameController,
              hintText: "Event name".tr,
              errorText: '',
            ),
            customDatePickerTextField(
              context: context,
              startDateController: controller.startDateController,
              isReadOnly: controller.enableToEdit.value ? false : true,
            ),
            customCountWidget(title: "Maximum number of visitors".tr),
            addProdTextField(
              textController: controller.eventDescriptionController,
              hintText: "Event description".tr,
              errorText: '',
            ),
            addProdTextField(
              textController: controller.eventLocationController,
              hintText: "Event location".tr,
              errorText: '',
              suffixIcon: GestureDetector(
                onTap: () {
                  controller.openGoogleMaps();
                },
                child: Icon(Icons.location_on, color: AppTheme.navGrey),
              ),
            ),
            controller.isEdit.value ? deletebutton() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget eventSectionListWidget(context) {
    List farmData = controller.farmerEvents.toList();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: farmData.length ?? 0,
        itemBuilder: (context, index) {
          return Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 275,
                        child: Text(
                          farmData[index]["name"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.boldTextView(24, AppTheme.black),
                        ),
                      ),
                      Text(
                        "${farmData[index]["remaining_tickets"]} tickets remaining".tr,
                        style: Styles.boldTextView(16, AppTheme.errorTextColor),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.updateFields(farmData[index]);
                    Get.toNamed(Routes.editEventPage);
                  },
                  child: SvgIcon(ImageUtil.editPen, size: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget customCountWidget({required String title}) {
    if (controller.isEdit.value == false) {
      controller.eventMinimumNumberController.text =
          controller.maxNumberOfVisit.value.toString();
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
                              controller.maxNumberOfVisit.value++;
                              controller.eventMinimumNumberController.text =
                                  controller.maxNumberOfVisit.value.toString();
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
                                  controller:
                                      controller.eventMinimumNumberController,
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
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.maxNumberOfVisit.value > 0) {
                                controller.maxNumberOfVisit.value--;
                                controller.eventMinimumNumberController.text =
                                    controller.maxNumberOfVisit.value
                                        .toString();
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
                      SizedBox(
                        width: 50,
                        child: TextField(
                          readOnly: !controller.enableToEdit.value,
                          controller: controller.eventMinimumNumberController,
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.center,
                          style: Styles.boldTextView(16, AppTheme.black),
                          decoration: InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
        ),
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
      DateTime futureTime = now.add(Duration(minutes: 5));
      DateTime today = DateTime(futureTime.year, futureTime.month, futureTime.day, futureTime.hour, futureTime.minute);

      final DateTime? picked = await showDialog<DateTime>(
        context: context,
        builder: (BuildContext dialogContext) {
          return AdoptiveCalendar(
            initialDate: today,
            disablePastDates: true,
            use24hFormat: false,
            action: true,
          );
        },
      );

      if (picked != null) {
        startDateController.text = controller.formatDateTime(
          picked.toIso8601String(),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (isReadOnly) ? null : selectStartDate,
            child: AbsorbPointer(
              child: Container(
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
                      controller: startDateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.arrow_drop_down),
                        fillColor: AppTheme.white,
                        filled: true,
                        hintText: "Time and date".tr,
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
                        hintStyle: Styles.mediumTextView(16, AppTheme.navGrey),
                        contentPadding: EdgeInsets.symmetric(vertical: 20.0),
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

  Widget deletebutton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: GestureDetector(
        onTap: () {
          showEditConfirmationDialog(title: "Delete Event".tr);
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
                  "Delete Event".tr,
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

  Widget addProdTextField({
    required textController,
    required String hintText,
    required String errorText,
    Widget? suffixIcon,
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
                  suffixIcon: suffixIcon,
                  // errorText: textController.value.isNotEmpty ? errorText : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget eventBottomNavWidget() {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    controller.isEdit.value = false;
                    controller.enableToEdit.value = true;
                    controller.eventNameController.clear();
                    controller.startDateController.clear();
                    controller.eventMinimumNumberController.clear();
                    controller.eventDescriptionController.clear();
                    controller.eventLocationController.clear();
                    controller.maxNumberOfVisit.value = 1;
                    Get.toNamed(Routes.addEventPage);
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget editEventBottomNaviWidget() {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            bottom: 100,
            left: 40,
            child: Container(
              color: Colors.transparent,
              child:
                  (controller.enableToEdit.value)
                      ? Row(
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
                              controller.updateEvents();
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
                              showEditConfirmationDialog(
                                title: "Confirm Edit?".tr,
                              );
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
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addEventbottomNaviWidget() {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          Positioned(
            bottom: 100,
            left: 40,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      controller.postEvents();
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
                  if (title == "Confirm Edit?".tr) {
                    controller.enableToEdit.value = true;
                    Get.back();
                  } else {
                    controller.deleteEvent();
                  }
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
