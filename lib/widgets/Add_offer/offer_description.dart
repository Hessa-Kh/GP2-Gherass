import 'package:flutter/material.dart';

class OfferDescription extends StatefulWidget {
  const OfferDescription({super.key});

  @override
  _OfferDescriptionState createState() => _OfferDescriptionState();
}

class _OfferDescriptionState extends State<OfferDescription> {
  bool isEditing = false;
  late TextEditingController _controller;
  final String _placeholderText = "أضف وصف العرض هنا...";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      isEditing = true;
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      width: MediaQuery.of(context).size.width * 0.8,
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
        children: [
          SizedBox(
            height: 70,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: _toggleEdit,
                child: Image.asset(
                  'assets/images/edit_icon.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isEditing
                ? TextField(
                    controller: _controller,
                    maxLines: null,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color.fromRGBO(121, 125, 130, 1),
                      fontSize: 14,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.w700,
                    ),
                    autofocus: true,
                    onSubmitted: (_) => _saveEdit(),
                    decoration: InputDecoration(
                      hintText: _placeholderText,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  )
                : GestureDetector(
                    onTap: _toggleEdit,
                    child: Text(
                      _controller.text.isEmpty ? _placeholderText : _controller.text,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _controller.text.isEmpty
                            ? Colors.grey
                            : const Color.fromRGBO(121, 125, 130, 1),
                        fontSize: 14,
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
