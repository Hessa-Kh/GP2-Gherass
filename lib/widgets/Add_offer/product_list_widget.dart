import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final List<Map<String, String>> products;
  final VoidCallback onShowMore;

  const ProductList({Key? key, required this.products, required this.onShowMore}) : super(key: key);

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  bool _showMore = false;
  int? selectedProductIndex; // To track the selected product

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "اسم المنتج",
                  style: const TextStyle(
                    color: Color.fromRGBO(66, 66, 73, 0.749),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai',
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
              ],
            ),
          ),
          widget.products.isEmpty
              ? Center(
                  child: Text(
                    "لا يوجد منتجات متاحة",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(), // Prevents scrolling when wrapped inside SingleChildScrollView
                  itemCount: _showMore ? widget.products.length : widget.products.length > 4 ? 4 : widget.products.length, // Adjust item count based on product list length
                  itemBuilder: (context, index) {
                    return ProductItem(
                      name: widget.products[index]['name']!,
                      imageUrl: widget.products[index]['imageUrl']!,
                      isSelected: selectedProductIndex == index, // Check if product is selected
                      onTap: () {
                        setState(() {
                          selectedProductIndex = index; // Set selected product index
                        });
                      },
                    );
                  },
                ),
          const SizedBox(height: 10),
          widget.products.length > 4 && !_showMore // Only show "إظهار المزيد" button if there are more than 4 products
              ? Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showMore = true; // Reveal all products
                      });
                      widget.onShowMore(); // Trigger the callback
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6472D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "إظهار المزيد",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(), // No button when products are fully shown or there are no extra products
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductItem({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 27,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFFCB5B5),
                        border: Border.all(color: const Color(0xFFEA4335)),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/trash.png',
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 27,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF797D82)),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/edit_icon.png',
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Color.fromRGBO(60, 60, 67, 0.60),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Almarai',
                        letterSpacing: 0.13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Image.asset(
                      imageUrl,
                      width: 30,
                      height: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 7),
                  GestureDetector(
                    onTap: onTap, // When the user taps on the container
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: isSelected ? const Color(0xFF6472D2) : const Color(0xFFF3F3F3),
                          border: Border.all(color: const Color(0xFF939393)),
                        ),
                        child: isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
                              )
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey[300],
          thickness: 1,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}
