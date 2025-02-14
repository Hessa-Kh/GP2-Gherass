import 'package:flutter/material.dart';

class ProductNameCard extends StatefulWidget {
  const ProductNameCard({super.key});

  @override
  _ProductNameCardState createState() => _ProductNameCardState();
}

class _ProductNameCardState extends State<ProductNameCard> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'بروكلي');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveEdit() {
    setState(() {
      isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(147, 96, 2, 0.20),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _toggleEdit, // Toggles edit mode
            child: Image.asset(
              'assets/images/edit_icon.png',
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 10), // Spacing between icon and text
          Expanded(
            child: isEditing
                ? TextField(
                    controller: _controller,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color.fromRGBO(121, 125, 130, 1),
                      fontSize: 16,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                    onSubmitted: (_) => _saveEdit(), // Saves on Enter key
                    autofocus: true,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  )
                : GestureDetector(
                    onTap: _toggleEdit, // Enable editing when text is tapped
                    child: Text(
                      _controller.text,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color.fromRGBO(121, 125, 130, 1),
                        fontSize: 16,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
