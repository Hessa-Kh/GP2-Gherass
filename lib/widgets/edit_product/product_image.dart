import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductImageUpload extends StatefulWidget {
  const ProductImageUpload({super.key});

  @override
  _ProductImageUploadState createState() => _ProductImageUploadState();
}

class _ProductImageUploadState extends State<ProductImageUpload> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(147, 96, 2, 0.20),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          _image == null
              ? Image.asset(
                  'assets/images/image_test.png',
                  fit: BoxFit.contain,
                  width: 290,
                  height: 210,
                  semanticLabel: 'Product image placeholder',
                )
              : Image.file(
                  _image!,
                  fit: BoxFit.contain,
                  width: 290,
                  height: 210,
                ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(225, 255, 255, 255),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            child: const Text('تعديل صورة المنتج'),
          ),
        ],
      ),
    );
  }
}
