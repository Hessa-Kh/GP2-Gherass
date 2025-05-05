import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gherass/module/cart/controller/my_cart_controller.dart';

class PaymentScreen extends StatelessWidget {
  final String totalAmount;
  PaymentScreen({super.key, required this.totalAmount});
  var controller = Get.find<MyCartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const SizedBox(height: 100),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: getRandomColor(),
                  child: Text(
                    getInitialsFromFullName(controller.userName.value),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Paying Gherass Commerce Private Limited',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'Banking name: Gherass',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'UPI ID: gherass.pay@alrajhibank',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'SAR $totalAmount',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120, // Adjust width as needed
                  height: 40, // Adjust height as needed
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 233, 231, 231),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: Text("UPIintent")),
                ),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                child: Container(
                  height: 280,
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Choose account to pay with',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            "https://play-lh.googleusercontent.com/ZaBioQBsEVVUgOj44e6EJKyfjpJskoWmkBtZbPQwTn_ZIkgrYcMYM-WnH8yqlybQCoAM=w600-h300-pc0xffffff-pd",
                          ),
                        ),
                        title: const Text("Al Rajhi Bank ****1234"),
                        subtitle: RichText(
                          text: TextSpan(
                            text: "Balance: ",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: "Check Now",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          controller.placeOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            19,
                            102,
                            165,
                          ),
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Pay SAR $totalAmount'),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(
                              "https://play-lh.googleusercontent.com/ZaBioQBsEVVUgOj44e6EJKyfjpJskoWmkBtZbPQwTn_ZIkgrYcMYM-WnH8yqlybQCoAM=w600-h300-pc0xffffff-pd",
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.network(
                              "https://m.economictimes.com/thumb/msid-74960608,width-1200,height-900,resizemode-4,imgsize-49172/upi-twitter.jpg",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getInitialsFromFullName(String fullName) {
    List<String> nameParts = fullName.split(' ');

    String initials = '';
    for (String part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }

    return initials;
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }
}
