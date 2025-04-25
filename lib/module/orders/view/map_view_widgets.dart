import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/util/constants.dart';
import 'package:gherass/widgets/loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/styles.dart';
import '../../home/home_controller.dart';
import '../controller/order_detail_map_controller.dart';

class MapViewWidgets{
  var controller = Get.find<OrderDetailMapController>();

  Widget mapViewWidget(BuildContext context, RxMap<String, dynamic> selectedOrder){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: SizedBox(
                width: double.infinity,
                height: 500,
                child: Obx(
                      () => GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:LatLng(selectedOrder["delivery_address"]["lat"],selectedOrder["delivery_address"]["lng"]),
                      zoom: 12,
                    ),
                    markers: Set<Marker>.from(controller.markers),
                    onMapCreated: controller.setMapController,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(children: [
              Icon(Icons.location_on_outlined,color: AppTheme.navGrey,size: 30,),
              SizedBox(width: 10,),
              Text(selectedOrder['delivery_address']['address'],style: Styles.boldTextView(13, AppTheme.black),)],),
            SizedBox(height: 20,),
            Row(children: [
              Icon(Icons.access_time_outlined,color: AppTheme.navGrey,size: 25,),
              SizedBox(width: 10,),
              Text(controller.covertDateFormatToTime(selectedOrder['date']),style: Styles.boldTextView(13, AppTheme.black),)],),
            SizedBox(height: 20,),
            Row(children: [
              Icon(Icons.calendar_month_outlined,color: AppTheme.navGrey,size: 25,),
              SizedBox(width: 10,),
              Text(controller.covertDateFormatToDate(selectedOrder['date']),style: Styles.boldTextView(13, AppTheme.black),)],),
            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.pampas,
                borderRadius: BorderRadius.circular(20),
              ),
              child:  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: (){
                       controller.showOrderStatusToggle.toggle();
                      },
                      child: Row(children: [
                        Icon(Icons.keyboard_arrow_down_sharp,color: AppTheme.hintDarkGray,size: 25,),
                        SizedBox(width: 10,),
                        Text("Order Status".tr,style: Styles.boldTextView(16, AppTheme.hintDarkGray),)],),
                    ),
                  ),
                  Obx(() =>Visibility(
                    visible: controller.showOrderStatusToggle.value,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0,5.0,15.0,0.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                        return InkWell(
                          onTap: () async {

                            if(index > controller.currentStatusIndex.value)
                              {
                                LoadingIndicator.loadingWithBackgroundDisabled("Updating..");
                                await controller.updateDeliveryStatus(Constants.orderStatusListOfDriver[index]);
                                await Get.find<HomeViewController>().fetchDriverOrders();
                                controller.fetchFcmTokenByIdAndSendNotification(controller.selectedOrder["customerId"], Constants.orderStatusListOfDriver[index],controller.selectedOrder["orderID"]);
                                LoadingIndicator.stopLoading();
                              }
                          },
                            child: Row(
                              children: [
                                Flexible(child: Text(Constants.orderStatusListOfDriver[index],style: Styles.boldTextView(16, index <= controller.currentStatusIndex.value?AppTheme.hintDarkGray:Colors.blue),)),
                                SizedBox(width: 5,),
                                if (index <= controller.currentStatusIndex.value) ...
                                [
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 20, // Adjust size if needed
                                  )
                                ]
                              ],
                            ));
                      },
                        separatorBuilder: (BuildContext context, int index) {
                        return  Divider(color: index <= controller.currentStatusIndex.value? AppTheme.hintDarkGray:null,);
                      }, itemCount: Constants.orderStatusListOfDriver.length,),
                    ),
                  )),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Call Customer,".tr,style: Styles.boldTextView(16, AppTheme.black),),
                    Text(controller.customerName.value,style: Styles.boldTextView(16, AppTheme.black),),
                  ],
                ),
                InkWell(
                  onTap: (){
                    controller.openDialPad(selectedOrder['delivery_address']['phoneNumber']);
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.orange,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Icon(Icons.phone_in_talk_outlined,color: AppTheme.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}