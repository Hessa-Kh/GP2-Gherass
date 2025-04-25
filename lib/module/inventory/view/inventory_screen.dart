import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/inventory/controller/inventory_controller.dart';
import 'package:gherass/module/inventory/view/widgets/inventory_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/theme/styles.dart';

class InventoryScreen extends StatelessWidget {
  var controller = Get.find<InventoryController>();

  InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: () async {
          await controller.showMore();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Inventory".tr,
              style: Styles.boldTextView(20, AppTheme.black),
            ),
            leading:
                controller.isShowprodList.value
                    ? Align(
                      alignment:
                          BaseController.languageName.value == "english"
                              ? Alignment.topLeft
                              : Alignment.topRight,
                      child: IconButton(
                        color: Colors.black,
                        onPressed: () {
                          controller.showMore();
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                    )
                    : null,
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await controller.showMore();
            },
            child: InventoryWidget().inventoryBody(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.addProdForm);
            },
            backgroundColor: AppTheme.lightPurple,
            shape: CircleBorder(),
            elevation: 8.0,
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: CustomFloatingActionButtonLocation(
            Offset(
              BaseController.languageName.value == 'english' ? 80 : 380,
              BaseController.languageName.value == 'english' ? 180 : 180,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final Offset offset;

  CustomFloatingActionButtonLocation(this.offset);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      scaffoldGeometry.scaffoldSize.width - offset.dx,
      scaffoldGeometry.scaffoldSize.height - offset.dy,
    );
  }
}
