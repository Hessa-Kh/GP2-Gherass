import 'package:flutter/material.dart';
import 'package:gherass/widgets/Add_offer/offer_price.dart';
import 'package:gherass/widgets/Add_offer/product_list_widget.dart';
import '../../widgets/add_offer/offer_description.dart'; 
import '../../widgets/add_offer/date_input.dart'; 
import '../../widgets/add_offer/submit_button.dart'; 


class AddOfferScreen extends StatelessWidget {
  const AddOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'إضافة عرض',
          style: TextStyle(
            color: Color.fromRGBO(16, 16, 16, 1),
            fontSize: 20,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: Column(
              children: [
                Container(
  height: 350,
  width: MediaQuery.of(context).size.width * 0.8,
  margin: const EdgeInsets.symmetric(vertical: 10),
  padding: const EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(147, 96, 2, 0.20),
        blurRadius: 6,
      ),
    ],
  ),
  child: ProductList(
    products: [
      {'name': 'كيلو موز', 'imageUrl': 'assets/images/image_test.png'},
      {'name': 'كيلو بروكلي', 'imageUrl': 'assets/images/image_test.png'},
      {'name': 'كيلو طماطم', 'imageUrl': 'assets/images/image_test.png'},
  
    ],
    onShowMore: () {
      print('عرض المزيد من المنتجات'); 
    },
  ),
),

                const SizedBox(height: 10),
                const OfferDescription(),
                const SizedBox(height: 20),
                const OfferPrice(),
                const SizedBox(height: 20),
                const DateInput(label: 'تاريخ البدء',),
                const SizedBox(height: 20),
                const DateInput(label: 'تاريخ الإنتهاء',),
                const SizedBox(height: 20),
                const SubmitButton(),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
