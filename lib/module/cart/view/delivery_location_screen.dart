import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/delivery_address/controller/delivery_address_controller.dart';
import 'package:gherass/module/delivery_address/view/widgets/delivery_address_widgets.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/styles.dart';

class DeliveryLocationScreen extends StatelessWidget {
  DeliveryLocationScreen({super.key});
  final controller = Get.find<DeliveryAddressController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        leading: Padding(
          padding: const EdgeInsets.all(7.0),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: CircleAvatar(
              backgroundColor: AppTheme.whiteAndGrey,
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppTheme.black,
                size: 18,
              ),
            ),
          ),
        ),
        title: Text(
          'Delivery Location'.tr,
          style: Styles.boldTextView(20, AppTheme.black),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () => DeliveryAddressWidgets().showAddresList(context),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Select from Saved Locations'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    fixedSize: Size(300, 65),
                  ),
                  onPressed:
                      () => DeliveryAddressWidgets().showAddresList(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => Flexible(
                          child: Text(
                            controller.address.value,

                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 30),
                      Icon(Icons.location_on_outlined, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Select Location on the Map'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 300,
              child: DeliveryAddressWidgets().mapWidget(context),
            ),
          ),
          SizedBox(height: 20),
          locationInputField(
            Icons.location_on_outlined,
            'Neighborhood'.tr,
            controller.neighborhood,
          ),
          locationInputField(
            Icons.location_on_outlined,
            'Street'.tr,
            controller.street,
          ),
          locationInputField(
            Icons.home,
            'House Number'.tr,
            controller.houseNumber,
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                minimumSize: const Size(200, 50),
              ),
              onPressed: () {
                controller.updateAddress();
              },
              child: Text(
                'Save Location'.tr,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget locationInputField(IconData icon, String hint, var textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: textController,
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          filled: true,
          fillColor: AppTheme.whiteAndGrey,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
