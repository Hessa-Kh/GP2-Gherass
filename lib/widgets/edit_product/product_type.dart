import 'package:flutter/material.dart';

class ProductTypeCard extends StatefulWidget {
  const ProductTypeCard({super.key});

  @override
  _ProductTypeCardState createState() => _ProductTypeCardState();
}

class _ProductTypeCardState extends State<ProductTypeCard> {
  bool isEditing = false;
  String selectedCategory = 'خضار'; 

  @override
  void initState() {
    super.initState();
    // Debugging: Print the initial category
    print('Initial selectedCategory: $selectedCategory');
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing; // Toggle edit mode
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
            onTap: _toggleEdit, 
            child: Image.asset(
              'assets/images/edit_icon.png',
              width: 20,
              height: 20,
            ),
          ),
          const SizedBox(width: 10), 
          Expanded(
            child: isEditing
                ? DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedCategory = newValue; 
                          isEditing = false; // Exit edit mode after selection
                        });
                        print('Updated selectedCategory: $selectedCategory'); // Debugging
                      }
                    },
                    items: <String>['فواكه', 'خضار', 'اخرى']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(121, 125, 130, 1),
                          ),
                        ),
                      );
                    }).toList(),
                    underline: const SizedBox(),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(121, 125, 130, 1),
                    ),
                  )
                : GestureDetector(
                    onTap: _toggleEdit, // Enter edit mode when text is tapped
                    child: Text(
                      selectedCategory,
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
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
