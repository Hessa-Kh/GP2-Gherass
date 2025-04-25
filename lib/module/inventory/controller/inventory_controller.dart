
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';

import '../../../widgets/loader.dart';

class InventoryController extends BaseController {
  RxBool isShowprodList = false.obs;
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var farmerRatings = [].obs;
  var farmerProducts = <Map<String, dynamic>>[].obs;
  List<Map<String, dynamic>>? allOrders = [];
  List<Map<String, dynamic>>? orderDetails = [];
  List<Map<String, dynamic>>? totalOrderDetails = [];
  RxString farmLogo = "".obs;
  RxString farmName = "".obs;
  RxDouble totalSaleAmount = 0.0.obs;
  RxDouble farmRatings = 0.0.obs;

  @override
  void onInit() {
    getFarmerRatings();
    getInventoryProducts();
    getOrdersList("farmerId",BaseController.firebaseAuth.getUid());
    super.onInit();
  }

  showMore() {
    getInventoryProducts();
    isShowprodList.value = !isShowprodList.value;
  }
  Future<void> getOrdersList(fieldName,String uId) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchOrders(fieldName,uId);
      if (response != null) {
        allOrders?.assignAll(response.cast<Map<String, dynamic>>());
        allOrders?.forEach((element){
          var value = double.tryParse(element["totalAmount"].toString());
          totalSaleAmount.value = totalSaleAmount.value+ value!;
        });
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
String fetchTotalQuantity(productName){
  RxInt totalSaleQuantity = 0.obs;
  orderDetails?.clear();
  allOrders?.forEach((element){
   orderDetails?.assignAll(element["orderDetails"].cast<Map<String, dynamic>>());
   orderDetails?.forEach((orderValue){
     if(productName == orderValue["name"]){
       var value = int.tryParse(orderValue["qty"].toString());
       totalSaleQuantity.value = totalSaleQuantity.value+ value!;
     }
   });
  });
  return totalSaleQuantity.value.toString()??"0";
}
  Future<void> getFarmerRatings() async {
    final details = await BaseController.firebaseAuth.getCurrentUserInfoById(
      BaseController.firebaseAuth.getUid(),
      BaseController.storageService.getLogInType(),
    );
    farmLogo.value = details?["farm_logo"] ?? "";
    farmName.value = details?["username"] ?? "";

    final results = await BaseController.firebaseAuth.fetchFarmerRatings(
      BaseController.firebaseAuth.getUid(),
    );
    if(results!=null) {
      farmerRatings.value = results;
      RxDouble farmRating = 0.0.obs;
      for (var element in farmerRatings) {
        farmRating.value = farmRating.value + element["rating"];
      }
      farmRatings.value = double.parse((farmRating.value/farmerRatings.length).toDouble().toStringAsFixed(1));
    }
  }
  String fetchRatingPercentage(rating){
    RxString percentage = "".obs;
    if(farmerRatings.isNotEmpty){
      List ratings = farmerRatings.where((element)=>element["rating"]==rating).toList();
      percentage.value =( (ratings.length/farmerRatings.length)*100).toStringAsFixed(0);
      return percentage.value;
    }else{
     return percentage.value = "0";
    }
  }
  Future<void> getInventoryProducts() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchFarmerProducts(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        farmerProducts.assignAll(response.cast<Map<String, dynamic>>());
      }
      print("farmerProducts $farmerProducts");
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void deleteProduct(String productId) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      await BaseController.firebaseAuth.deleteFarmProduct(productId);

      farmerProducts.removeWhere((product) => product['id'] == productId);

      LoadingIndicator.stopLoading();
    } catch (e) {
      print("Error deleting product: $e");
      LoadingIndicator.stopLoading();
    }
  }
}
