import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/delivery_address/view/widgets/delivery_address_widgets.dart';

import '../../../widgets/appBar.dart';
import '../controller/delivery_address_controller.dart';

class DeliveryAddressScreen extends StatelessWidget {
  const DeliveryAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<DeliveryAddressController>();

    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          if (controller.isAddingNewAddress.value) {
            controller.isAddingNewAddress.value = false;
            return false;
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CommonAppBar(
            title:
                controller.isAddingNewAddress.value
                    ? "Add New Address".tr
                    : "My Addresses".tr,
            onBackPressed: () {
              if (controller.isAddingNewAddress.value) {
                controller.isAddingNewAddress.value = false;
              } else {
                Get.back();
              }
            },
          ),
          body:
              controller.isAddingNewAddress.value
                  ? DeliveryAddressWidgets().addNewAddressWidget(context)
                  : DeliveryAddressWidgets().myAddressesWidget(context),
        ),
      ),
    );
  }
}
