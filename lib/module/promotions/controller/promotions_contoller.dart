import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../baseclass/basecontroller.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/loader.dart';

class PromotionsController extends BaseController {
  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var promotionDescription = TextEditingController();
  var promotionNewPrice = TextEditingController();
  RxString promotionProductName = "".obs;
  RxString promotionId = "".obs;
  RxString selectedProductId = "".obs;
  var isEdit = false.obs;
  RxInt newPriceValue = 1.obs;
  var enableToEdit = false.obs;
  var promotionsList = <Map<String, dynamic>>[].obs;
  var selectedProduct = <String, dynamic>{}.obs;

@override
  void onInit() {
  getPromotionsList();
    super.onInit();
  }

  void updateFields(arguments) {
    isEdit.value=true;
    enableToEdit.value=false;
    promotionId.value = arguments["id"].toString();
    promotionProductName.value = arguments["product"].toString();
    startDateController.text = arguments["start_date"].toString();
    endDateController.text = arguments["end_date"].toString();
    promotionDescription.text = arguments["description"].toString();
    promotionNewPrice.text = arguments["new_price"].toString();
    newPriceValue.value = int.tryParse(arguments["new_price"].toString())??0;
  }
  void getPromotionsList() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.removeExpiredDoc("promotions","end_date",DateFormat("yyyy-MM-dd").format(DateTime.now()));
      final response = await BaseController.firebaseAuth
          .fetchFarmerPromotions(BaseController.firebaseAuth.getUid());
      if (response != null) {
        promotionsList.assignAll(response.cast<Map<String, dynamic>>());
      }
      print(promotionsList);
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
  void updatePromotions() async {
    if (promotionNewPrice.text.isEmpty) {
      Get.snackbar("Validation Error", "Promotion price cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }

    if (startDateController.text.isEmpty) {
      Get.snackbar("Validation Error", "Start date is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }
    if (endDateController.text.isEmpty) {
      Get.snackbar("Validation Error", "End date is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }
    if (promotionDescription.text.isEmpty) {
      Get.snackbar("Validation Error", "Description type cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }

    if (promotionProductName.isEmpty) {
      Get.snackbar("Validation Error", "Select Product",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }


    Map<String, dynamic> promotionData = {
      "product": promotionProductName.value,
      "description": promotionDescription.text,
      "new_price": promotionNewPrice.text,
      "start_date": startDateController.text,
      "end_date": endDateController.text,
    };
    selectedProduct["discount_price"] = promotionNewPrice.text;
    selectedProduct["discount_end_date"] = endDateController.text;
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.updatePromotions(promotionId.value,promotionData);
      await BaseController.firebaseAuth.updateProductToFarmer(selectedProductId.value,selectedProduct);
      Get.back();
      Get.snackbar("Success", "Promotion updated successfully",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      getPromotionsList();
      promotionNewPrice.clear();
      startDateController.clear();
      promotionDescription.clear();
      endDateController.clear();
      promotionProductName.value ="";
      newPriceValue.value=1;
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar("Error", "Failed to add Event: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
    }
  }
  void deletePromotion() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();

      await BaseController.firebaseAuth.deletePromotion(promotionId.value);

      promotionsList.removeWhere((product) => product['id'] == promotionId.value);
      Get.back();
      Get.back();
      getPromotionsList();
      LoadingIndicator.stopLoading();
    } catch (e) {
      print("Error deleting product: $e");
      LoadingIndicator.stopLoading();
    }
  }
  createPromotion()async{
    if (promotionNewPrice.text.isEmpty) {
      Get.snackbar("Validation Error", "Promotion price cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }

    if (startDateController.text.isEmpty) {
      Get.snackbar("Validation Error", "Start date is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }
    if (endDateController.text.isEmpty) {
      Get.snackbar("Validation Error", "End date is required",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }
    if (promotionDescription.text.isEmpty) {
      Get.snackbar("Validation Error", "Description type cannot be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }

    if (promotionProductName.isEmpty) {
      Get.snackbar("Validation Error", "Select Product",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
      return;
    }

    Map<String, dynamic> promotionData = {
      "product": promotionProductName.value,
      "description": promotionDescription.text,
      "new_price": promotionNewPrice.text,
      "start_date": startDateController.text,
      "end_date": endDateController.text,
    };
    selectedProduct["discount_price"] = promotionNewPrice.text;
    selectedProduct["discount_end_date"] = endDateController.text;
    print(".......>>$promotionData");
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      await BaseController.firebaseAuth.addPromotionsToFarmer(promotionData);
      await BaseController.firebaseAuth.updateProductToFarmer(selectedProductId.value,selectedProduct);
      Get.back();
      Get.snackbar("Success", "Promotion added successfully",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
      getPromotionsList();
      promotionNewPrice.clear();
      startDateController.clear();
      promotionDescription.clear();
      endDateController.clear();
      promotionProductName.value ="";
      newPriceValue.value=1;
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar("Error", "Failed to add promotion: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose);
    }
  }
}