import 'dart:developer';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/module/cart/model/cart_model.dart';
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
          log("NO duplicate prodId: ${product.prodId}");
        } else {
          duplicateProdIds.add(product);
          log("Found duplicate prodId: ${product.prodId}");
        }
      }

      myCartList.value = uniqueProductMap.values.toList();
      myCartList.refresh();

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

      log(
        "Adding product -> id: ${product.id} | prodId: ${product.prodId} | name: ${product.name}",
      );

      if (existingProduct.id.isEmpty) {
        log("New product from farmer: ${product.farmerId}");
        myCartList.add(product);
        await BaseController.firebaseAuth.addProductsToCart([product.toJson()]);
      } else {
        log("Updating existing product: ${product.prodId}");
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

  void updateQuantity(Product product, int quantity) async {
    LoadingIndicator.loadingWithBackgroundDisabled();
    try {
      var item = myCartList.firstWhere((p) => p.id == product.id);
      print('product:${product.id}');

      // if (quantity > product.totalQty) {
      //   Get.snackbar(
      //     "Cart",
      //     "Cannot update quantity. Only ${product.totalQty.toString()} items are available.",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: AppTheme.errorTextColor,
      //   );

      //   quantity = product.totalQty;
      // }

      if (quantity > 0) {
        print(product.id);
        item.qty = quantity;
        myCartList.refresh();
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
      getCartProducts(item.farmerId);
    } catch (e) {
      LoadingIndicator.stopLoading();
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
      Get.back();

      if (myCartList.isNotEmpty &&
          selectedDate.value != "" &&
          currentDeliveryAddress.isNotEmpty &&
          selectedTime.value != "") {
        var orderProductsList = [];
        Map<String, dynamic> postOrder = {};

        for (var prod in myCartList) {
          Map<String, dynamic> orderDetails = {
            "name": prod.name,
            "image": prod.image,
            "price": prod.price,
            "productId": prod.prodId,
            "qty": prod.qty,
          };
          postOrder = {
            "customerName": userName.value,
            "delivery_address": currentDeliveryAddress,
            "date": DateTime.now(),
            "deliveryDate": selectedDate.value,
            "customerId": BaseController.firebaseAuth.getUid(),
            "driverId": "",
            "farmerId": prod.farmerId.toString(),
            "farmerName": prod.farmerName.toString(),
            "isRejected": false,
            "orderDetails": orderProductsList,
            "orderID": "",
            "status": Constants.orderStatusListOfFarmer[0].toString(),
            "time": selectedTime.value,
            "totalAmount": totalPrice + deliveryCharge,
          };
          orderProductsList.add(orderDetails);
        }

        orderId.value = await BaseController.firebaseAuth.placeOrder(postOrder);

        log(orderId.value.toString());
        fetchFcmTokenById(myCartList.first.farmerId.toString(), {
          "orderId": orderId.value,
        });

        await BaseController.firebaseAuth.cartDelete();
        selectedDate.value = "";
        selectedTime.value = "";
        myCartList.clear();
        orderProductsList.clear();
        postOrder.clear();

        return true;
            } else {
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
      log("Error occurred while placing the order: $e");
      Get.snackbar(
        "Error",
        "Something went wrong while processing your order. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightRose,
      );
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
    }

    return false;
  }

  getCustomerDeliveryAddress() async {
    LoadingIndicator.loadingWithBackgroundDisabled();
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
    } catch (e) {
      LoadingIndicator.stopLoading();
    } finally {
      LoadingIndicator.stopLoading();
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
