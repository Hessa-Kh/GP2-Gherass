import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/Add_product_widgets/product_image_upload.dart';
import '../widgets/Add_product_widgets/product_form_field.dart';
import '../widgets/Add_product_widgets/product_price_input.dart';
import '../widgets/Add_product_widgets/product_quantity_selector.dart';
import '../widgets/Add_product_widgets/product_quality_selector.dart';
import '../widgets/Add_product_widgets/action_buttons.dart';
import '../widgets/Add_product_widgets/production_date_selector.dart';
import 'dart:io';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String selectedProductType = '';
  String category = '';
  File? selectedImage;
  String productName = '';
  String productDescription = '';
  double productPrice = 0.0;
  double productQuantity = 0.0;
  String productionDate = '';
  bool isOrganic = false;

  /// Shows the product type selector modal
  void _showProductTypeSelector() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildListTile('خضار', 'vegetables'),
          _buildListTile('فواكه', 'fruits'),
          _buildListTile('آخرى', 'other'),
        ],
      ),
    );
  }

  /// Builds a list tile for selecting product type
  Widget _buildListTile(String type, String categoryValue) {
    return ListTile(
      title: Text(type),
      onTap: () {
        setState(() {
          selectedProductType = type;
          category = categoryValue;
        });
        Navigator.pop(context);
      },
    );
  }

  /// Saves the product to Firestore
  Future<void> _saveProduct() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _showSnackBar('يرجى تسجيل الدخول لإضافة المنتج!');
        return;
      }

      if (productName.isEmpty || productPrice <= 0 || productQuantity <= 0 || selectedProductType.isEmpty) {
        _showSnackBar('يرجى ملء جميع الحقول المطلوبة!');
        return;
      }

      String productId = _firestore.collection('products').doc().id;
      String imageUrl = '';

      if (selectedImage != null) {
        imageUrl = await _uploadImage(productId, selectedImage!);
      }

      await _firestore.collection('Product').doc(productId).set({
        'farmer': user.email,
        'name': productName,
        'description': productDescription,
        'organic': isOrganic,
        'imgURL': imageUrl,
        'price': productPrice,
        'productID': productId,
        'productionDate': productionDate,
        'quantity': productQuantity,
        'type': category,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _showSnackBar('تم حفظ المنتج بنجاح!');
      _resetForm();
      
    } catch (e) {
      _showSnackBar('حدث خطأ: $e');
    }
  }

  /// Uploads the selected image to Firebase Storage
  Future<String> _uploadImage(String productId, File imageFile) async {
    try {
      String fileName = 'products/$productId.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      _showSnackBar('خطأ في تحميل الصورة: $e');
      return '';
    }
  }

  /// Resets the form fields
  void _resetForm() {
    setState(() {
      selectedImage = null;
      productName = '';
      productDescription = '';
      productPrice = 0.0;
      productQuantity = 0.0;
      productionDate = '';
      isOrganic = false;
      selectedProductType = '';
      category = '';
    });
  }

  /// Shows a snackbar message
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 46, vertical: 23),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Center(
                    child: Text(
                      'إضافة منتج',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  /// Image Upload
                  ProductImageUpload(
                    onImageSelected: (File file) {
                      setState(() {
                        selectedImage = file;
                      });
                    },
                  ),
                  const SizedBox(height: 29),

                  /// Product Name Input
                  ProductFormField(
                    label: 'إسم المنتج',
                    hint: 'أدخل اسم المنتج',
                    onChanged: (value) {
                      setState(() {
                        productName = value;
                      });
                    },
                  ),
                  const SizedBox(height: 29),

                  /// Product Type Selector
                  GestureDetector(
                    onTap: _showProductTypeSelector,
                    child: AbsorbPointer(
                      child: ProductFormField(
                        label: selectedProductType.isEmpty ? 'نوع المنتج' : selectedProductType,
                        hint: 'إختر نوع المنتج',
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  /// Production Date Selector
                  ProductionDateSelector(
                    onDateSelected: (String date) {
                      setState(() {
                        productionDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  /// Price Input
                  ProductPriceInput(
                    onChanged: (double value) {
                      setState(() {
                        productPrice = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  /// Quantity Selector
                  ProductQuantitySelector(
                    onChanged: (double value) {
                      setState(() {
                        productQuantity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  /// Quality Selector
                 ProductQualitySelector(
                    onChanged: (bool value) {
                      setState(() {
                        isOrganic = value;
                      });
                    },
                  ),
                  const SizedBox(height: 34),
                  /// Action Buttons
                  ActionButtons(
                    onPressed: () async {
                      await _saveProduct();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
