import 'package:flutter/material.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final List<Map<String, dynamic>> products = [
    {'name': 'تفاح', 'price': 5.0, 'sales': 150},
    {'name': 'برتقال', 'price': 4.5, 'sales': 120},
    {'name': 'موز', 'price': 3.0, 'sales': 180},
    {'name': 'عنب', 'price': 7.0, 'sales': 90},
    {'name': 'أناناس', 'price': 6.5, 'sales': 110},
    {'name': 'مانجو', 'price': 8.0, 'sales': 200},
    {'name': 'كمثرى', 'price': 6.0, 'sales': 75},
    {'name': 'رمان', 'price': 9.0, 'sales': 50}
  ];

  bool showAllProducts = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sortedProducts = List.from(products)
      ..sort((a, b) => b['sales'].compareTo(a['sales']));

    final displayedProducts = showAllProducts ? sortedProducts : sortedProducts.take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: const Text(
              'المنتجات',
              style: TextStyle(
                color: Color(0xFF8C8C8C),
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.15,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      final product = displayedProducts[index];
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 84, 41, 225).withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 198, 165, 255).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'إجمالي المبيعات: ${product['sales']}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Almarai',
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${product['name']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${product['price']} SAR',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    color: Color.fromARGB(255, 58, 56, 56),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                if (products.length > 4)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAllProducts = !showAllProducts;
                      });
                    },
                    child: Text(
                      showAllProducts ? 'إخفاء' : 'المزيد',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6A5ACD),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
