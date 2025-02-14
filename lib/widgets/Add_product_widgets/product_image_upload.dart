import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProductImageUpload extends StatefulWidget {
  final Function(File file) onImageSelected; // Correctly define the callback function

  const ProductImageUpload({super.key, required this.onImageSelected});

  @override
  _ProductImageUploadState createState() => _ProductImageUploadState();
}

class _ProductImageUploadState extends State<ProductImageUpload> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          _image = File(pickedFile.path);
        });
        widget.onImageSelected(_image!); // Pass the selected image to the parent
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في اختيار الصورة: $e')),
      );
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('اختر من المعرض'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('التقط صورة'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      child: Container(
        width: 349,
        height: 349,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(147, 96, 2, 0.2),
              blurRadius: 9,
            ),
          ],
        ),
        child: _image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/gallery-add.png',
                    width: 250,
                    height: 250,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'إضافة صورة المنتج',
                    style: TextStyle(
                      color: Color(0xFFB7B7B7),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Almarai',
                      letterSpacing: 0.16,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  _image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
