import 'package:flutter/material.dart';
import '../../widgets/edit_product/product_type.dart';
import '../../widgets/edit_product/product_price_input.dart';
import '../../widgets/edit_product/product_quantity_selector.dart';
import '../../widgets/edit_product/product_quality_selector.dart';
import '../../widgets/edit_product/product_prod_selector.dart';
import '../../widgets/edit_product/product_name.dart';
import '../../widgets/edit_product/product_visibility_widget.dart';
import '../../widgets/edit_product/edit_button.dart';
import '../../widgets/edit_product/product_image.dart';
import '../../widgets/edit_product/delete_product.dart';
import '../../widgets/edit_product/product_description.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      'تعديل المنتج',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const ProductImageUpload(),
                  const SizedBox(height: 29),
                  const ProductNameCard(),
                  const SizedBox(height: 29),
                  const ProductTypeCard(),
                  const SizedBox(height: 17),
                  const ProductionDateSelector(),
                  const SizedBox(height: 22),
                  const ProductDescription(),
                  const SizedBox(height: 17),
                  const ProductVisibilityWidget(),
                  const SizedBox(height: 21),
                  const ProductPriceInput(),
                  const SizedBox(height: 24),
                  const ProductQuantitySelector(),
                  const SizedBox(height: 24),
                  const ProductQualitySelector(),
                  const SizedBox(height: 34),
                  const DeleteProductButton(),
                  const EditCancelButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
