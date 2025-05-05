import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gherass/baseclass/basecontroller.dart';
import 'package:gherass/helper/routes.dart';
import 'package:gherass/module/cart/model/cart_model.dart';
import 'package:gherass/theme/app_theme.dart';
import 'package:gherass/util/constants.dart';
import 'package:gherass/widgets/loader.dart';

class FirebaseHelper {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> signUp({required Map<String, dynamic> registerUser}) async {
    try {
      RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      );
      if (!emailRegex.hasMatch(registerUser["email"])) {
        throw "Please enter a valid email address.";
      }

      if (registerUser["password"].length < 6) {
        throw "Password must be at least 6 characters long.";
      }

      await auth.createUserWithEmailAndPassword(
        email: registerUser["email"],
        password: registerUser["password"],
      );
      registerUser.remove('password');
      auth.authStateChanges().listen((userCredential) async {
        if (userCredential != null) {
          User? user = getCurrentUser();
          if (user == null) {
          } else {
            BaseController.storageService.write(Constants.isLogin, true);
            await setUserData(registerUser);
            Get.toNamed(Routes.dashBoard);

            Get.snackbar(
              "Sucess",
              "User signed In!",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppTheme.primaryColor,
            );
          }
        } else {
          Get.snackbar(
            "Failed",
            "User is signed failed!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
        }
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          Get.snackbar(
            "Failed",
            "This email is already in use. Please try another.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          throw "This email is already in use. Please try another.";
        } else if (e.code == 'weak-password') {
          Get.snackbar(
            "Failed",
            "The password is too weak. Please choose a stronger password.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          throw "The password is too weak. Please choose a stronger password.";
        } else if (e.code == 'invalid-email') {
          Get.snackbar(
            "Failed",
            "The email address is invalid. Please check your email.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          throw "The email address is invalid. Please check your email.";
        } else {
          Get.snackbar(
            "Failed",
            "An unknown error occurred during sign-up.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          throw "An unknown error occurred during sign-up.";
        }
      } else {
        Get.snackbar(
          "Failed",
          "Error during login: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
        throw "Error during sign-up: $e";
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        Get.snackbar(
          "Failed",
          "Login Failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
        return;
      }

      LoadingIndicator.loadingWithBackgroundDisabled();

      var loginType = await getUserType(user.uid);
      var isUid = await isUidPresent(user.uid);

      if ((BaseController.storageService.getLogInType().toString() ==
              loginType.toString()) &&
          isUid) {
        BaseController.storageService.write(Constants.isLogin, true);

        LoadingIndicator.stopLoading();
        Get.toNamed(Routes.dashBoard);
        Get.snackbar(
          "Sucess",
          "Login Sucess",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryColor,
        );
      } else {
        LoadingIndicator.stopLoading();
        Get.snackbar(
          "Failed",
          "Invalid User ",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
      }
    } catch (e) {
      LoadingIndicator.stopLoading();

      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Get.snackbar(
            "Failed",
            "User not found. Please check your email.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          throw "User not found. Please check your email.";
        } else if (e.code == 'wrong-password') {
          Get.snackbar(
            "Failed",
            "Incorrect password. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppTheme.lightRose,
          );
          throw "Incorrect password. Please try again.";
        } else {
          throw "An unknown error occurred during login.";
        }
      } else {
        Get.snackbar(
          "Failed",
          "Error during login: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.lightRose,
        );
        throw "Error during login: $e";
      }
    }
  }

  Future<String?> getUserType(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection(BaseController.storageService.getLogInType())
              .doc(uid)
              .get();

      if (userDoc.exists) {
        return userDoc['userType'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user type: $e");
      return null;
    }
  }

  Future<void> setUserData(Map<String, dynamic> userData) async {
    try {
      String userId = getUid();
      if (userId.isEmpty) {
        print('Error: User ID is empty. Please log in.');
        return;
      }

      userData['${userData["userType"]}Id'] = userId;

      await FirebaseFirestore.instance
          .collection(BaseController.storageService.getLogInType())
          .doc(userId)
          .set(userData);

      print('User initial data set successfully with ID: $userId');
    } catch (error) {
      print(
        'Error setting user data: logInUserType: ${BaseController.storageService.getLogInType()} , userId: ${getUid()}  error:  $error',
      );
    }
  }

  Future<void> updateUserData({
    required Map<String, dynamic> updateProfile,
    required logInUserType,
    required userId,
  }) async {
    try {
      if (updateProfile.containsKey("email")) {
        RegExp emailRegex = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
        );
        if (!emailRegex.hasMatch(updateProfile["email"])) {
          throw "Please enter a valid email address.";
        }
      }

      final docRef = FirebaseFirestore.instance
          .collection(logInUserType)
          .doc(userId);
      await docRef.update(updateProfile);

      print('User data updated successfully!');
    } catch (error) {
      print(
        'Error updating user data: logInUserType: $logInUserType , userId: $userId,  error:  $error',
      );
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserInfoById(
    String userId,
    String userTypeId,
  ) async {
    Map<String, dynamic>? farmerData;

    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(userTypeId)
              .doc(userId)
              .get();

      if (snapshot.exists) {
        farmerData = snapshot.data() as Map<String, dynamic>;
        print(farmerData);
      } else {
        print("No farmer data found for the given ID.");
      }
    } catch (e) {
      print("Error fetching current user info: $e");
    }

    return farmerData;
  }

  Future<List<Map<String, dynamic>>?> fetchFarmerProducts(
    String farmerId,
  ) async {
    List<Map<String, dynamic>>? farmerProducts;
    try {
      print("Fetching products for farmer ID: $farmerId");

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('farmer')
              .doc(farmerId)
              .collection('products')
              .get();

      if (snapshot.docs.isNotEmpty) {
        farmerProducts =
            snapshot.docs
                .map(
                  (doc) => {
                    'id': doc.id, // log the document ID
                    ...doc.data() as Map<String, dynamic>,
                  },
                )
                .toList();
      } else {
        print("No products found for the given farmer ID: $farmerId.");
      }
    } catch (e) {
      print("Error fetching Products: $e");
    }

    return farmerProducts;
  }

  Future<List<Map<String, dynamic>>?> fetchFarmerEvents(String farmerId) async {
    List<Map<String, dynamic>>? farmerEvents;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('farmer')
              .doc(farmerId)
              .collection('events')
              .get();

      if (snapshot.docs.isNotEmpty) {
        farmerEvents =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No Events found for the given farmer ID.");
      }
    } catch (e) {
      print("Error fetching data In Event: $e");
    }

    return farmerEvents;
  }

  Future fetchFarmerRatings(String farmerId) async {
    var farmerRatings = [];
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('farmer')
              .doc(farmerId)
              .collection('ratings')
              .get();
      if (snapshot.docs.isNotEmpty) {
        farmerRatings =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No ratings found for the given farmer ID.");
      }
    } catch (e) {
      print("Error fetching for faremr ratings: $e");
    }

    return farmerRatings;
  }

  Future<void> postFarmerReview(
    String farmerId,
    Map<String, dynamic> reviewData,
  ) async {
    try {
      CollectionReference addReview = FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerId)
          .collection('ratings');

      await addReview.add(reviewData);
      print("Review added successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future<List<List>> getFarmsList() async {
    List farmerData = [];
    List farmersList = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('farmer').get();
      farmersList = querySnapshot.docs.map((doc) => doc.id).toList();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      for (var element in allData) {
        farmerData.add(element);
      }
    } catch (e) {
      print(e);
    }
    return [farmerData, farmersList];
  }

  Future<List<Map<String, dynamic>>?> getCategoryList() async {
    List<Map<String, dynamic>>? categoryList;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('categoryList').get();
      if (querySnapshot.docs.isNotEmpty) {
        categoryList =
            querySnapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No Events found for the given farmer ID.");
      }
    } catch (e) {}
    return categoryList;
  }

  Future<void> addProductToFarmer(Map<String, dynamic> productData) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference productsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('products');

      var docRef = await productsRef.add(productData);

      productData['id'] = docRef.id;

      await docRef.update({'id': docRef.id});

      print(
        "Product added successfully! for ${getUid()} with ID: ${docRef.id}",
      );
    } catch (e) {
      print("Error adding product: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> fetchFarmerPromotions(
    String farmerId,
  ) async {
    List<Map<String, dynamic>>? farmerPromotions;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('farmer')
              .doc(farmerId)
              .collection('promotions')
              .get();

      if (snapshot.docs.isNotEmpty) {
        farmerPromotions =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No Events found for the given farmer ID.");
      }
    } catch (e) {
      print("Error fetching for promotions: $e");
    }

    return farmerPromotions;
  }

  Future<void> addEventsToFarmer(Map<String, dynamic> eventData) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference eventsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('events');
      var docRef = await eventsRef.add(eventData);
      eventData['id'] = docRef.id;

      await docRef.update({'id': docRef.id});
      print("event added successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> addPromotionsToFarmer(Map<String, dynamic> promotionData) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference promotionsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('promotions');
      var docRef = await promotionsRef.add(promotionData);
      promotionData['id'] = docRef.id;
      await docRef.update({'id': docRef.id});
      print("event added successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> updatePromotions(
    String eventId,
    Map<String, dynamic> eventData,
  ) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference eventsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('promotions');

      var docRef = eventsRef.doc(eventId);
      await docRef.update(eventData);
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> deletePromotion(String promotionId) async {
    try {
      CollectionReference productsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('promotions');
      await productsRef.doc(promotionId).delete();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> fetchBookedEvents(
    String customerId,
  ) async {
    List<Map<String, dynamic>>? farmerEvents;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('customer')
              .doc(customerId)
              .collection('booked_events')
              .get();

      if (snapshot.docs.isNotEmpty) {
        farmerEvents =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No Events found for the given farmer ID.");
      }
    } catch (e) {
      print("Error fetching booked events: $e");
    }

    return farmerEvents;
  }

  Future<List<Map<String, dynamic>>?> fetchOrders(
    String fieldName,
    String userId,
  ) async {
    List<Map<String, dynamic>>? orders;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('order')
              .where(fieldName, isEqualTo: userId)
              .orderBy('date', descending: true)
              .get();

      if (snapshot.docs.isNotEmpty) {
        orders =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No fetchOrders found for the given Driver ID.");
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }

    return orders;
  }

  Future<void> addToBookEvents(Map<String, dynamic> eventData) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference eventsRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(getUid())
          .collection('booked_events');
      var docRef = await eventsRef.add(eventData);
      eventData['booking_id'] = docRef.id;

      await docRef.update({'booking_id': docRef.id});
      print("event booked successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> updateEventTicketCount(
    String bookingId,
    int remainingTickets, {
    farmerID,
  }) async {
    try {
      print("Updating ticket count for booking ID: $bookingId");
      CollectionReference eventsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerID)
          .collection('events');

      await eventsRef.doc(bookingId).update({
        'remaining_tickets': remainingTickets.toString(),
      });

      print("Ticket count updated successfully for booking ID: $bookingId");
    } catch (e) {
      print("Error updating ticket count: $e");
    }
  }

  Future<void> updateEventsToFarmer(
    String eventId,
    Map<String, dynamic> eventData,
  ) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference eventsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('events');

      var docRef = eventsRef.doc(eventId);
      await docRef.update(eventData);
      print("event added successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> removeExpiredDoc(
    String collectionName,
    String fieldName,
    farmatedDate,
  ) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('farmer')
            .doc(getUid())
            .collection(collectionName)
            .where(fieldName, isLessThan: farmatedDate)
            .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> removeExpiredFields(
    String collectionName,
    String fieldName,
    farmatedDate,
  ) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('farmer')
            .doc(getUid())
            .collection(collectionName)
            .where(fieldName, isLessThan: farmatedDate)
            .get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'discount_end_date': FieldValue.delete(),
        'discount_price': FieldValue.delete(),
      });
    }
  }

  Future<void> updateProductToFarmer(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      print('getUid:${getUid()}');
      CollectionReference productsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('products');

      var docRef = productsRef.doc(productId);

      await docRef.update(productData);

      print(
        "Product updated successfully! for ${getUid()} with ID: $productId",
      );
    } catch (e) {
      print("Error updating product: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> fetchOrdersWithDriverId(
    String driverId,
  ) async {
    List<Map<String, dynamic>>? orders;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('order').orderBy('date', descending: true)
              .where('driverId', isEqualTo: driverId)
              .get();

      if (snapshot.docs.isNotEmpty) {
        orders =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No fetchOrdersWithDriverId found for the given .");
      }
    } catch (e) {
      print("Error fetching oerders by driver Id: $e");
    }

    return orders;
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<bool> isUidPresent(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection(BaseController.storageService.getLogInType())
              .doc(uid)
              .get();

      if (userDoc.exists) {
        print('User document exists');
        return true;
      } else {
        print('User document does not exist');
        return false;
      }
    } catch (e) {
      print('Error checking UID: $e');
      return false;
    }
  }

  String getUid() {
    return auth.currentUser!.uid;
  }

  Future<void> deleteFarmProduct(String productId) async {
    try {
      CollectionReference productsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('products');
      await productsRef.doc(productId).delete();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> deleteFarmEvent(String eventId) async {
    try {
      CollectionReference productsRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(getUid())
          .collection('events');
      await productsRef.doc(eventId).delete();
    } catch (e) {
      print("Error deleting product: $e");
    }
  }

  Future<void> addProductsToCart(List<Map<String, dynamic>> productList) async {
    try {
      String customerId = getUid();

      for (var productMap in productList) {
        String farmerId = productMap['farmerId'];

        if (farmerId.isEmpty) {
          continue;
        }

        DocumentReference cartDocRef = FirebaseFirestore.instance
            .collection('customer')
            .doc(customerId)
            .collection('cart')
            .doc(farmerId);

        await cartDocRef.set({
          'farmerId': farmerId,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        CollectionReference productRef = cartDocRef.collection('products');

        QuerySnapshot existing =
            await productRef
                .where('prodId', isEqualTo: productMap['prodId'])
                .get();

        if (existing.docs.isEmpty) {
          DocumentReference docRef = await productRef.add(productMap);
          await docRef.update({'id': docRef.id});
        } else {
          var doc = existing.docs.first;
          int existingQty = (doc['qty'] ?? 0);
          num newQty = existingQty + (productMap['qty'] ?? 1);
          await doc.reference.update({'qty': newQty});
        }
      }
    } catch (e) {}
  }

  Future<void> updateProductQty(
    String farmerId,
    String productId,
    int orderedQty,
  ) async {
    try {
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerId)
          .collection('products')
          .doc(productId);

      DocumentSnapshot productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        int currentQty = productSnapshot['qty'] ?? 0;

        int updatedQty = currentQty - orderedQty;
        updatedQty = updatedQty < 0 ? 0 : updatedQty;

        Map<String, dynamic> updateData = {'qty': updatedQty};

        if (updatedQty == 0) {
          updateData['isHidden'] = true;
        }

        await productRef.update(updateData);
      } else {}
    } catch (e) {}
  }

  Future<int> getProductTotalQty(String farmerId, String productId) async {
    try {
      DocumentReference productRef = FirebaseFirestore.instance
          .collection('farmer')
          .doc(farmerId)
          .collection('products')
          .doc(productId);

      DocumentSnapshot productSnapshot = await productRef.get();

      if (productSnapshot.exists) {
        int currentQty = productSnapshot['qty'] ?? 0;
        return currentQty;
      } else {
        return -1; // Product not found
      }
    } catch (e) {
      print('Error getting product quantity: $e');
      return -1; // Handle error
    }
  }

  Future<void> updateProductInCart(
    List<Map<String, dynamic>> productList,
  ) async {
    try {
      String customerId = getUid();
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var productMap in productList) {
        String productId = productMap['id'];
        String farmerId = productMap['farmerId'];

        if (farmerId.isEmpty) {
          continue;
        }

        var productDocRef = FirebaseFirestore.instance
            .collection('customer')
            .doc(customerId)
            .collection('cart')
            .doc(farmerId)
            .collection('products')
            .doc(productId);

        batch.set(productDocRef, productMap, SetOptions(merge: true));
      }

      await batch.commit();
    } catch (e) {}
  }

  Future<String?> fetchInitialCart() async {
    String customerId = getUid();

    try {
      final cartSnapshot =
          await FirebaseFirestore.instance
              .collection('customer')
              .doc(customerId)
              .collection('cart')
              .get();

      if (cartSnapshot.docs.isEmpty) {
        print("🛒 No cart documents found for customer: $customerId");
        return null;
      }

      for (var cartDoc in cartSnapshot.docs) {
        final farmerId = cartDoc.id;

        final productsSnapshot =
            await FirebaseFirestore.instance
                .collection('customer')
                .doc(customerId)
                .collection('cart')
                .doc(farmerId)
                .collection('products')
                .get();

        if (productsSnapshot.docs.isNotEmpty) {
          return farmerId;
        }
      }
    } catch (e) {}

    return null;
  }

  Future<List<Product>> fetchCustomerCartProducts({String? farmerId}) async {
    List<Product> cartProducts = [];

    try {
      String customerId = getUid();
      print("Fetching cart products for customer: $customerId");

      final cartRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(customerId)
          .collection('cart');

      farmerId = await fetchInitialCart();

      final productsSnapshot =
          await cartRef.doc(farmerId).collection('products').get();

      if (productsSnapshot.docs.isEmpty) {
        print("No products found for farmerId: $farmerId");
        return [];
      }

      cartProducts =
          productsSnapshot.docs.map((doc) {
            var data = doc.data();
            return Product(
              id: data['id'] ?? '',
              name: data['name'] ?? '',
              qty: data['qty'] ?? 0,
              price: data['price'] ?? 0,
              farmerId: data['farmerId'] ?? '',
              farmerName: data['farmerName'] ?? '',
              prodId: data['prodId'] ?? '',
              image: data['image'] ?? '',
              totalQty: data['totalQty'] ?? 0,
            );
          }).toList();

      print("Fetched ${cartProducts.length} products from farmerId: $farmerId");
    } catch (e) {
      print("Error fetching cart products: $e");
    }

    return cartProducts;
  }

  Future<void> removeFromCart({
    required String farmerId,
    required String productId,
  }) async {
    try {
      String customerId = getUid();

      final productRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(customerId)
          .collection('cart')
          .doc(farmerId)
          .collection('products')
          .doc(productId);

      await productRef.delete();
    } catch (e) {}
  }

  Future<void>? deleteCurrentUser() async {
    await FirebaseFirestore.instance
        .collection(BaseController.storageService.getLogInType())
        .doc(getUid())
        .delete();
    await auth.currentUser?.delete();
    BaseController.storageService.write(Constants.isLogin, false);
    Get.offAllNamed(Routes.splash);
    Get.snackbar(
      "Sucess",
      "User Deleted!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryColor,
    );

    print("User Deleted");
  }

  Future<void> logout() async {
    await auth.signOut();
    BaseController.storageService.write(Constants.isLogin, false);
    BaseController.storageService.write(Constants.logType, "");
    Get.offAllNamed(Routes.splash);
    Get.snackbar(
      "Sucess",
      "User signed Out!",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppTheme.primaryColor,
    );
    LoadingIndicator.stopLoading();
  }

  Future<Map<String, dynamic>?> getOrderStatusFlowList(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('Delivery') // Collection name
              .doc("DeliveryStatusTypes") // Document ID
              .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print("Document not found.");
        return null;
      }
    } catch (e) {
      print("Error fetching StatusFlow: $e");
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchAddressList(
    String customerId,
  ) async {
    List<Map<String, dynamic>>? addressList;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('customer')
              .doc(customerId)
              .collection('address_list')
              .get();

      if (snapshot.docs.isNotEmpty) {
        addressList =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No fetchAddressList found for the given  ID.");
      }
    } catch (e) {
      print("Error fetching Address: $e");
    }
    return addressList;
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      CollectionReference addressRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(getUid())
          .collection('address_list');

      await addressRef.doc(addressId).delete();
    } catch (e) {
      print("Error deleteAddress: $e");
    }
  }

  Future<void> addAddressForCustomer(Map<String, dynamic> addressData) async {
    try {
      CollectionReference addressRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(getUid())
          .collection('address_list');

      var docRef = await addressRef.add(addressData);
      addressData['id'] = docRef.id;
      await docRef.update({'id': docRef.id});
      print("addAddressForCustomer added successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> updateAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    try {
      CollectionReference addressRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(getUid())
          .collection('address_list');

      var docRef = addressRef.doc(addressId);
      await docRef.update(addressData);
      print("updateAddress added successfully! for ${getUid()}");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<String> placeOrder(Map<String, dynamic> orderData) async {
    try {
      CollectionReference placeOrderRef = FirebaseFirestore.instance.collection(
        'order',
      );

      var docRef = await placeOrderRef.add({...orderData, 'orderID': null});

      await docRef.update({'orderID': docRef.id});

      print("Order placed successfully! for ${getUid()} with ID: ${docRef.id}");
      return docRef.id;
    } catch (e) {
      print("Error placing order: $e");
      return '';
    }
  }

  Future<List<Map<String, dynamic>>?> fetchVehicleInfo(String driverId) async {
    List<Map<String, dynamic>>? vehicleInfo;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('driver')
              .doc(driverId)
              .collection('vehicle_detail')
              .get();

      if (snapshot.docs.isNotEmpty) {
        vehicleInfo =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No fetchVehicleInfo found for the given  ID.");
      }
    } catch (e) {
      print("Error fetching Vehicle: $e");
    }
    return vehicleInfo;
  }

  Future<void> updateVehicleInfo(
    String driverId,
    Map<String, dynamic> vehicleInfo,
  ) async {
    try {
      CollectionReference vehicleRef = FirebaseFirestore.instance
          .collection('driver')
          .doc(driverId)
          .collection('vehicle_detail');

      QuerySnapshot snapshot = await vehicleRef.limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference docRef = snapshot.docs.first.reference;
        await docRef.update(vehicleInfo);
        print("Vehicle info updated successfully for driver: $driverId");
      } else {
        var snapshot = await vehicleRef.add(vehicleInfo);
        await snapshot.update({'vehicleID': snapshot.id});
        print("No existing vehicle info document found for driver: $driverId");
      }
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<List<Map<String, dynamic>>?> fetchOrdersWithCustomerId(
    String customerId,
  ) async {
    List<Map<String, dynamic>>? orders;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection('order')
              .where('customerId', isEqualTo: customerId)
              .get();

      if (snapshot.docs.isNotEmpty) {
        orders =
            snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();
      } else {
        print("No fetchOrdersWithCustomerId found .");
      }
    } catch (e) {
      print("Error fetching customer id orders: $e");
    }

    return orders;
  }

  Future<Map<String, dynamic>?> fetchDetailsById(
    String collection,
    String userId,
  ) async {
    Map<String, dynamic>? data;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection(collection)
              .where(FieldPath.documentId, isEqualTo: userId)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        data = snapshot.docs.first.data() as Map<String, dynamic>;
        print("Fetched first document for user: $userId in $collection.");
      } else {
        print("No data found for user: $userId in $collection.");
      }
    } catch (e) {
      print("Error fetching data from $collection: $e");
    }
    return data;
  }

  Future<Map<String, dynamic>?> fetchOrderDetailsById(String orderId) async {
    Map<String, dynamic>? data;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance
              .collection("order")
              .where(FieldPath.documentId, isEqualTo: orderId)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        data = snapshot.docs.first.data() as Map<String, dynamic>;
      } else {
        print("No fetchOrderDetailsById found for user");
      }
    } catch (e) {
      print("Error fetching data DetailsById");
    }
    return data;
  }

  Future<void> updateOrderStatus(
    String orderId,
    String status,
    bool isDriver,
  ) async {
    try {
      DocumentReference ordersRef = FirebaseFirestore.instance
          .collection('order')
          .doc(orderId);

      if (isDriver) {
        var id = BaseController.firebaseAuth.getUid();
        await ordersRef.update({"status": status, "driverId": id});
      } else {
        await ordersRef.update({"status": status});
      }
      print("updateOrderStatus  successfully! for $orderId");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<void> rejectOrder(String orderId) async {
    try {
      DocumentReference ordersRef = FirebaseFirestore.instance
          .collection('order')
          .doc(orderId);

      await ordersRef.update({"isRejected": true});
      print("rejectOrder successfully! for $orderId");
    } catch (e) {
      print("Error adding event: $e");
    }
  }

  Future<String> getOrderStatusByid(String orderId) async {
    try {
      String orderStatus = "";
      DocumentReference ordersRef = FirebaseFirestore.instance
          .collection('order')
          .doc(orderId);

      var orderData = await ordersRef.get();
      orderStatus = orderData["status"];
      print(
        "getOrderStatusByid fetched successfully! for ${orderStatus.toString()}",
      );
      return orderStatus;
    } catch (e) {
      print("Error orderData : $e");
    }
    return "";
  }

  Future<void> loginFcmUpdate(
    String collection,
    String authId,
    String fcmToken,
  ) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection(collection)
          .doc(authId);

      await docRef.update({"fcmToken": fcmToken});

      print("loginFcmUpdate token updated successfully for user: $authId");
    } catch (e) {
      print("Error updating FCM token: $e");
    }
  }

  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      print(">>orderId $orderId");
      DocumentReference orderRef = FirebaseFirestore.instance
          .collection('order')
          .doc(orderId);

      DocumentSnapshot orderData = await orderRef.get();
      print(">>orderData :$orderData ");

      if (orderData.exists) {
        Map<String, dynamic> order = orderData.data() as Map<String, dynamic>;
        print("Order fetched successfully! Order: ${order.toString()}");
        return order;
      } else {
        print("No order found for the given ID.");
        return {}; // Return an empty map if no order is found
      }
    } catch (e) {
      print("Error fetching order data: $e");
      return {}; // Return an empty map in case of an error
    }
  }

  Future<bool> getOrderIsRejectByid(String orderId) async {
    try {
      bool orderReject = false;
      DocumentReference ordersRef = FirebaseFirestore.instance
          .collection('order')
          .doc(orderId);

      var orderData = await ordersRef.get();
      orderReject = orderData["isRejected"];
      print("orderData fetched successfully! for ${orderReject.toString()}");
      return orderReject;
    } catch (e) {
      print("Error orderData : $e");
    }
    return false;
  }

  Future cartDelete() async {
    try {
      CollectionReference cartRef = FirebaseFirestore.instance
          .collection('customer')
          .doc(getUid())
          .collection('cart');

      QuerySnapshot snapshot = await cartRef.get();

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      print("All items in cart deleted successfully.");
    } catch (e) {
      print("Error deleting cart items: $e");
    }
  }
}
