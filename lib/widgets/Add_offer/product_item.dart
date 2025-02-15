import 'package:flutter/material.dart';

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
                    onTap: onTap,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: Container(
                        width: 15,
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
