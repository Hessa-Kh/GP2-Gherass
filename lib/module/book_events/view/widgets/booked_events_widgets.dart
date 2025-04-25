import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/book_events/controller/booked_events_controller.dart';

import '../../../../theme/app_theme.dart';
import '../../../../theme/styles.dart';

class BookedEventsWidgets {
  var controller = Get.find<BookedEventsController>();

  Widget eventSectionListWidget(context) {
    List farmData = controller.bookedEvents.toList();
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: RefreshIndicator(
        onRefresh: () async {
          controller.getBookedEventsList();
        },
        child:
            (farmData.isEmpty)
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "No Events Booked!".tr,
                        style: Styles.boldTextView(22, AppTheme.black),
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  shrinkWrap: true,
                  itemCount: farmData.length ?? 0,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      margin: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
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
                                    style: Styles.boldTextView(
                                      24,
                                      AppTheme.black,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${farmData[index]["start_date"]}",
                                  style: Styles.boldTextView(
                                    16,
                                    Color(0xff797D82),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Event Details: ".tr,
                                      style: Styles.boldTextView(
                                        16,
                                        Color(0xff797D82),
                                      ),
                                    ),
                                    Expanded(
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
                                      "Location: ".tr,
                                      style: Styles.boldTextView(
                                        16,
                                        Color(0xff797D82),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 194,
                                      child: Text(
                                        "${farmData[index]["location"]}",
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
