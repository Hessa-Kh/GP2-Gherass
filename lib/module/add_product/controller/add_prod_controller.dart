import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/module/inventory/controller/inventory_controller.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/widgets/loader.dart';
import 'package:image_picker/image_picker.dart';

class AddProdController extends BaseController {
  var isEdit = false.obs;
  var enableToEdit = false.obs;
  var showPrefixIcon = false.obs;
  File? imageFile;
  var selectedImagePath = "".obs;
  String base64ProdImage = "";
  var productName = TextEditingController();
  var productType = TextEditingController();
  var productDescription = TextEditingController();
  var productionDateController = TextEditingController();
  var productQty = 0.obs;
  var productPrice = 0.obs;
  var productVisibility = "".obs;
  var productQuality = "".obs;
  var quantityType = "".obs;
  var selectedCategory = "".obs;
  var isKgSelected = false.obs;
  var unitSelected = "kg".obs;
  Uint8List? imageDecoded;
  var productId = "".obs;
  var farmerProducts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;

  var inventoryController = InventoryController();

  @override
  void onInit() {
    super.onInit();
    getCategoryList();
    var arguments = Get.arguments;
    if (arguments == null || arguments.isEmpty) {
      enableToEdit = true.obs;
    } else {
      isEdit.value = true;
      updateFields(arguments[0]);
      log(arguments[0].toString());
    }
    getInventoryProducts();
  }

  void updateFields(arguments) {
    productName.text = arguments["name"];
    if (arguments["image"] != null) {
      base64ProdImage = arguments["image"] ?? "".split(',').last;
      imageDecoded = base64Decode(base64ProdImage);
    }
    productId.value = arguments["id"];
    productType.text = arguments["prodType"];
    productDescription.text = arguments["description"];
    productVisibility.value = arguments["visibility"];
    productPrice.value = arguments["price"];
    productQty.value = arguments["qty"];
    productQuality.value = arguments["quality"];
    productionDateController.text = arguments["productionDate"];
  }

  void postProducts() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    if (productName.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product name cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (base64ProdImage.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product image is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    

    if (productDescription.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (productPrice.value <= 0) {
      Get.snackbar(
        "Validation Error",
        "Price must be greater than zero",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (productQty.value <= 0) {
      Get.snackbar(
        "Validation Error",
        "Quantity must be greater than zero",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (productQuality.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product quality cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    Map<String, dynamic> productData = {
      "name": productName.text,
      "image": base64ProdImage,
      "category": selectedCategory.value,
      "prodType": productType.text,
      "description": productDescription.text,
      "visibility": productVisibility.value,
      "price": productPrice.value,
      "qty": productQty.value,
      "quality": productQuality.value,
      "productionDate": productionDateController.text,
    };

    log(productData.toString());

    try {
      await BaseController.firebaseAuth.addProductToFarmer(productData);
      Get.back();
      inventoryController.showMore();
      Get.snackbar(
        "Success",
        "Product added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );

      productName.clear();
      base64ProdImage = "";
      productType.clear();
      productDescription.clear();
      productVisibility.value = "";
      productPrice.value = 0;
      productQty.value = 0;
      productQuality.value = "";
      inventoryController.isShowprodList.value = false;
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar(
        "Error",
        "Failed to add product: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void updateProduct() async {
    LoadingIndicator.loadingWithBackgroundDisabled();

    if (productName.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product name cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (base64ProdImage.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product image is required",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }


    if (productDescription.text.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product description cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (productPrice.value <= 0) {
      Get.snackbar(
        "Validation Error",
        "Price must be greater than zero",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (productQty.value <= 0) {
      Get.snackbar(
        "Validation Error",
        "Quantity must be greater than zero",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    if (productQuality.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Product quality cannot be empty",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
      return;
    }

    Map<String, dynamic> productData = {
      "name": productName.text,
      "image": base64ProdImage,
      "category": selectedCategory.value,
      "prodType": productType.text,
      "description": productDescription.text,
      "visibility": productVisibility.value,
      "price": productPrice.value,
      "qty": productQty.value,
      "quality": productQuality.value,
      "productionDate": productionDateController.text,
    };

    log(productData.toString());

    try {
      await BaseController.firebaseAuth.updateProductToFarmer(
        productId.value,
        productData,
      );
      Get.back();
      inventoryController.showMore();
      Get.snackbar(
        "Success",
        "Product updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );

      productName.clear();
      base64ProdImage = "";
      productType.clear();
      productDescription.clear();
      productVisibility.value = "";
      productPrice.value = 0;
      productQty.value = 0;
      productQuality.value = "";
    } catch (e) {
      LoadingIndicator.stopLoading();
      Get.snackbar(
        "Error",
        "Failed to update product: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  Future<void> pickImagesFromGallery() async {
    imageDecoded = Uint8List(0);
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      final imageBytes = await imageFile!.readAsBytes();

      imageDecoded = imageBytes;
      base64ProdImage = base64Encode(imageBytes);
      selectedImagePath.value = imageFile!.path;
    } else {
      print('No image selected');
    }
  }

  void deleteProduct() {
    inventoryController.deleteProduct(productId.value.toString());

    inventoryController.getInventoryProducts();
    Get.back();
    Get.back();
  }

  Future<void> getCategoryList() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      var categoryListResponse =
          await BaseController.firebaseAuth.getCategoryList();
      if (categoryListResponse != null) {
        for (var element in categoryListResponse) {
          categoryList.add(element);
        }
      }

      selectedCategory.value = categoryList.last["name"];
    } catch (e) {
      print("Error fetching category list: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void getInventoryProducts() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchFarmerProducts(
        BaseController.firebaseAuth.getUid(),
      );
      if (response != null) {
        farmerProducts.assignAll(response.cast<Map<String, dynamic>>());
      }
      print(farmerProducts);
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }
  }
}
