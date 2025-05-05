import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/cart/model/cart_model.dart';
import 'package:gherass/module/cart/view/my_cart_widgets.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/util/constants.dart';
import 'package:gherass/widgets/loader.dart';

import '../../../helper/notification.dart';

class MyCartController extends GetxController {
  final double deliveryCharge = 15.00;
  var currentDeliveryAddress = <String, dynamic>{}.obs;
  var adddress = "".obs;
  var street = ''.obs;
  var neighborhood = ''.obs;
  var houseNumber = ''.obs;
  var phoneNumber = "".obs;
  var email = "".obs;
  var selectedTime = "".obs;
  var selectedDate = ''.obs;
  var userName = "".obs;
  var orderId = "".obs;
  RxString farmerId = "".obs;
  RxString selectedPaymentMethod = "ApplePay".obs;
  RxBool isLoadingAddress = true.obs;

  RxList<Product> myCartList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();

    try {
      final args = Get.arguments;
      if (args != null && args.isNotEmpty) {
        farmerId.value = args[0]?.toString() ?? '';
        getCartProducts(farmerId.value);
        print("Farmer ID from arguments: ${farmerId.value}");
      } else {
        getCartProducts("");
        print("No arguments received in Get.arguments.");
      }
    } catch (e) {
      print("Error parsing Get.arguments in onInit(): $e");
    }
  }

  Future<int> fetchTotalQty(Product product) async {
    return await BaseController.firebaseAuth.getProductTotalQty(
      product.farmerId,
      product.prodId,
    );
  }

  void getCartProducts(String farmerId) async {
    myCartList.clear();

    try {
      var response = await BaseController.firebaseAuth
          .fetchCustomerCartProducts(farmerId: farmerId);

      Map<String, Product> uniqueProductMap = {};
      List<Product> duplicateProdIds = [];

      for (var product in response) {
        if (!uniqueProductMap.containsKey(product.prodId)) {
          uniqueProductMap[product.prodId] = product;
        } else {
          duplicateProdIds.add(product);
        }
      }

      myCartList.value = uniqueProductMap.values.toList();

      myCartList.refresh();
      for (var prod in myCartList) {
        validateQuantity(prod);
      }

      for (var product in duplicateProdIds) {
        await BaseController.firebaseAuth.removeFromCart(
          farmerId: product.farmerId.toString(),
          productId: product.id.toString(),
        );
        print(
          "Removed duplicate product with prodId: ${product.prodId} from backend.",
        );
      }
      selectedDate.value = "";
      selectedTime.value = "";

      getCustomerDeliveryAddress();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error fetching cart products: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void addToCart(Product product) async {
    LoadingIndicator.loadingWithBackgroundDisabled();

    try {
      myCartList.refresh();

      var existingProduct = myCartList.firstWhere(
        (item) =>
            item.prodId == product.prodId && item.farmerId == product.farmerId,
        orElse:
            () => Product(
              id: "",
              name: "",
              price: 0.0,
              image: "",
              qty: 0,
              prodId: '',
              farmerId: "",
              farmerName: "",
              totalQty: 0,
            ),
      );

      print(
        "Adding product -> id: ${product.id} | prodId: ${product.prodId} | name: ${product.name}",
      );

      if (existingProduct.id.isEmpty) {
        print("New product from farmer: ${product.farmerId}");
        myCartList.add(product);
        await BaseController.firebaseAuth.addProductsToCart([product.toJson()]);
      } else {
        print("Updating existing product: ${product.prodId}");
        existingProduct.qty += product.qty;
        myCartList.refresh();
        await updateProductInCart(existingProduct);
      }

      getCartProducts(product.farmerId);
    } catch (e) {
      print("Error adding product to cart: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  Future<void> updateProductInCart(Product product) async {
    try {
      getCartProducts(product.farmerId);
      await BaseController.firebaseAuth.updateProductInCart([product.toJson()]);
    } catch (e) {
      print("Error updating product in cart: $e");
    }
  }

  void validateQuantity(Product product) async {
    print('Validating quantity...');
    print('product.qty : ${product.qty}');
    print('Product name: ${product.name}');

    // Step 1: Fetch current total available quantity from Firestore
    final totalQty = await fetchTotalQty(product);
    print('Total available qty (from Firestore): $totalQty');

    // Step 2: Cap product.qty to totalQty if it exceeds it
    if (product.qty > totalQty) {
      print('Qty exceeds totalQty. Adjusting...');
      product.qty = totalQty;
    } else {
      print('Qty is within available stock.');
    }

    // Step 3: Update the adjusted product in Firebase (e.g., in cart)
    await BaseController.firebaseAuth.updateProductInCart([product.toJson()]);

    print('Final qty sent to Firebase: ${product.qty}');
  }

  void updateQuantity(Product product, int quantity) async {
    LoadingIndicator.loadingWithBackgroundDisabled();

    try {
      var item = myCartList.firstWhere((p) => p.id == product.id);
      print('product: ${product.id}');

      final totalQty = await fetchTotalQty(product);

      if (quantity > totalQty) {
        Get.snackbar(
          "Cart",
          "Cannot update quantity. Only $totalQty items are available.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.errorTextColor,
        );
        LoadingIndicator.stopLoading();
        return;
      }

      if (quantity > 0) {
        item.qty = quantity;
        await updateProductInCart(item);

        Get.snackbar(
          "Cart",
          "Quantity updated",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.successTextColor,
        );
      } else {
        removeFromCart(item);
      }

      myCartList.refresh();
      getCartProducts(item.farmerId);
    } catch (e) {
      print("Error updating quantity: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  void removeFromCart(Product product) async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      var itemToRemove = myCartList.firstWhere((item) => item.id == product.id);
      myCartList.removeWhere((item) => item.id == product.id);
      await BaseController.firebaseAuth.removeFromCart(
        farmerId: itemToRemove.farmerId.toString(),
        productId: itemToRemove.id.toString(),
      );
      myCartList.refresh();

      Get.snackbar(
        "Cart",
        "Product removed from cart",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.hintDarkGray,
      );
      await BaseController.firebaseAuth.removeFromCart(
        farmerId: itemToRemove.farmerId.toString(),
        productId: itemToRemove.id.toString(),
      );

      myCartList.removeWhere((item) => item.id == product.id);
      myCartList.refresh();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error removing product from cart: $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  double get totalPrice {
    return myCartList.fold(0.0, (total, product) {
      return total + (product.price * product.qty);
    });
  }

  Future<bool> postOrderComplete() async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      Get.back(); // Close any open overlays/dialogs

      // Check for all required fields
      if (myCartList.isNotEmpty &&
          selectedDate.value.isNotEmpty &&
          currentDeliveryAddress.isNotEmpty &&
          selectedTime.value.isNotEmpty) {
        List<Map<String, dynamic>> orderProductsList = [];

        for (var prod in myCartList) {
          final totalQty = await fetchTotalQty(prod);

          orderProductsList.add({
            "name": prod.name,
            "price": prod.price,
            "productId": prod.prodId,
            "qty": prod.qty,
            "totalQty": totalQty,
          });
        }

        Map<String, dynamic> postOrder = {
          "customerName": userName.value,
          "delivery_address": currentDeliveryAddress,
          "date": DateTime.now(),
          "deliveryDate": selectedDate.value,
          "customerId": BaseController.firebaseAuth.getUid(),
          "driverId": "",
          "farmerId": myCartList.first.farmerId,
          "farmerName": myCartList.first.farmerName,
          "isRejected": false,
          "orderDetails": orderProductsList,
          "paymentMethod": selectedPaymentMethod.value,
          "orderID": "",
          "status": Constants.orderStatusListOfFarmer[0],
          "time": selectedTime.value,
          "totalAmount": totalPrice + deliveryCharge,
        };

        orderId.value = await BaseController.firebaseAuth.placeOrder(postOrder);
        print("Order placed: ${orderId.value}");

        fetchFcmTokenById(myCartList.first.farmerId, {
          "orderId": orderId.value,
        });

        return true;
      } else {
        // Build detailed feedback for the user
        String getMessage() {
          String dateMessage =
              selectedDate.value.isNotEmpty
                  ? "Expected Date: ${selectedDate.value}"
                  : "Expected Date: Not set";

          String timeMessage =
              selectedTime.value.isNotEmpty
                  ? "Delivery Time: ${selectedTime.value}"
                  : "Delivery Time: Not set";

          String productMessage =
              myCartList.isNotEmpty
                  ? "Products: ${myCartList.length}"
                  : "No products selected";

          String locationMessage =
              currentDeliveryAddress.isNotEmpty
                  ? "Delivery Location: $currentDeliveryAddress"
                  : "Delivery Location: Not set";

          return "Please check the delivery details: \n$dateMessage \n$timeMessage  \n$productMessage  \n$locationMessage";
        }

        Get.snackbar(
          "Order",
          getMessage(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
      }
    } catch (e) {
      print("Error placing order: $e");
      Get.snackbar(
        "Error",
        "Something went wrong while processing your order. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
    } finally {
      LoadingIndicator.stopLoading();
    }

    return false;
  }

  getCustomerDeliveryAddress() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    isLoadingAddress.value = true;

    try {
      final data = await BaseController.firebaseAuth.getCurrentUserInfoById(
        BaseController.firebaseAuth.getUid(),
        BaseController.storageService.getLogInType(),
      );
      final userDetails = await BaseController.firebaseAuth
          .getCurrentUserInfoById(
            BaseController.firebaseAuth.getUid(),
            BaseController.storageService.getLogInType(),
          );
      userName.value = userDetails?["username"];

      currentDeliveryAddress.addAll(data!["current_address"]);
      adddress.value = data["current_address"]["address"];
      street.value = data["current_address"]["street"];
      houseNumber.value = data["current_address"]["houseNumber"];
      neighborhood.value = data["current_address"]["neighborhood"];
      email.value = data["email"];
      phoneNumber.value = data["phoneNumber"];
      currentDeliveryAddress["email"] = email.value;
      currentDeliveryAddress["phoneNumber"] = phoneNumber.value;
      Future.delayed(Duration(seconds: 3), () {
        isLoadingAddress.value = false;
      });
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
      Future.delayed(Duration(seconds: 3), () {
        isLoadingAddress.value = false;
      });
    }
  }

  void fetchFcmTokenById(String userId, Map<String, dynamic> orderId) async {
    try {
      LoadingIndicator.loadingWithBackgroundDisabled();
      final response = await BaseController.firebaseAuth.fetchDetailsById(
        'farmer',
        userId,
      );
      if (response != null) {
        String fcmToken = response['fcmToken'];
        final firebaseMessaging = FCM();
        firebaseMessaging.sendFcm(
          fcmToken,
          "New Order",
          "There is a new order $orderId.",
          orderId,
        );
        LoadingIndicator.stopLoading();
      }
      LoadingIndicator.stopLoading();
    } catch (e) {
      LoadingIndicator.stopLoading();
      print("Error :  $e");
    } finally {
      LoadingIndicator.stopLoading();
    }
  }

  placeOrder() async {
    var isOrdered = await postOrderComplete();

    if (isOrdered) {
      updateProduct();
      await BaseController.firebaseAuth.cartDelete();
      selectedDate.value = "";
      selectedTime.value = "";

      MyCartWidgets().showPremiumSuccessDialog();
      await Future.delayed(Duration(seconds: 5));
      myCartList.clear();
      Get.back();
      Get.toNamed(Routes.countDownTimer, arguments: [orderId.value]);
    } else {
      print("Order failed");
    }
  }

  void updateProduct() async {
    for (var prod in myCartList) {
      await BaseController.firebaseAuth.updateProductQty(
        prod.farmerId.toString(),
        prod.prodId,
        prod.qty,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
