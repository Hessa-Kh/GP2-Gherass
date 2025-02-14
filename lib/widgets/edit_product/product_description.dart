import 'package:flutter/material.dart';

class ProductDescription extends StatefulWidget {
  const ProductDescription({super.key});

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: 'بروكلي طازج');
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
      padding: const EdgeInsets.all(20), // Matching the padding of ProductNameCard
      height: 150, // Increased height for more space for typing
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
        crossAxisAlignment: CrossAxisAlignment.start, // Align the text to top for more visible space
        children: [
          GestureDetector(
            onTap: _toggleEdit, // Toggle edit mode
            child: Image.asset(
              'assets/images/edit_icon.png',
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 10), // Space between icon and text
          Expanded(
            child: isEditing
                ? TextField(
                    controller: _controller,
                    maxLines: null, // Allow multiline text
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color.fromRGBO(121, 125, 130, 1),
                      fontSize: 16,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                    onSubmitted: (_) => _saveEdit(), // Save on Enter
                    autofocus: true,
                  )
                : GestureDetector(
                    onTap: _toggleEdit, // Enable edit when text is tapped
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
