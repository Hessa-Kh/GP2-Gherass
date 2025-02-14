import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FarmForm extends StatefulWidget {
  const FarmForm({super.key});

  @override
  _FarmFormState createState() => _FarmFormState();
}

class _FarmFormState extends State<FarmForm> {
  File? _selectedImage;
  File? _selectedFile;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final ImagePicker _picker = ImagePicker();
  
  final TextEditingController farmNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  // Pick Image from Device
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
Widget _buildTimeField(String label, TimeOfDay? time) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF2F2F2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.access_time, color: Color(0xFFBDBDBD)),
        const SizedBox(width: 10),
        Text(
          time == null ? label : time.format(context),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFFBDBDBD),
            fontFamily: 'Almarai',
          ),
        ),
      ],
    ),
  );
}
  // Pick PDF File
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Pick Work Time (Start & End)
  Future<void> _selectTime(bool isStart) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  // **🔥 Save Data to Firestore & Upload Image**
Future<void> _saveFarmData() async {
  try {
    String? imageUrl;
    String? fileUrl;

    // ✅ Upload Image (if selected)
    if (_selectedImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('farm_logos/${DateTime.now().millisecondsSinceEpoch}.jpg');

      UploadTask uploadTask = ref.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL(); // ✅ Ensures URL is retrieved after upload
    }

    // ✅ Upload PDF File (if selected)
    if (_selectedFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('farm_certificates/${DateTime.now().millisecondsSinceEpoch}.pdf');

      UploadTask uploadTask = ref.putFile(_selectedFile!);
      TaskSnapshot snapshot = await uploadTask;
      fileUrl = await snapshot.ref.getDownloadURL(); // ✅ Ensures URL is retrieved after upload
    }

    // ✅ Save Data to Firestore
    await FirebaseFirestore.instance.collection('farms').add({
      'farm_name': farmNameController.text,
      'location': locationController.text,
      'start_time': _startTime?.format(context) ?? "غير محدد",
      'end_time': _endTime?.format(context) ?? "غير محدد",
      'image_url': imageUrl,
      'file_url': fileUrl, // ✅ Save PDF File URL in Firestore
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم حفظ بيانات المزرعة بنجاح!")),
    );
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("فشل في حفظ البيانات: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 40),
              _buildImagePicker(),
              _buildFormField(label: 'اسم المزرعة', hint: 'اسم المزرعة', controller: farmNameController),
              _buildFormField(label: 'موقع المزرعة', hint: 'تحديد الموقع', controller: locationController),
              _buildFilePicker(),
              _buildWorkTimePicker(),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _saveFarmData, // Call save function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF93C249),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 15,
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    'تأكيد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// **Text Input Fields**
  Widget _buildFormField({required String label, required String hint, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
            fontFamily: 'Almarai',
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// **Pick Image from Device**
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "إرفاق شعار المزرعة",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
            fontFamily: 'Almarai',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("اختر من الجهاز"),
        ),
        if (_selectedImage != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Image.file(_selectedImage!, height: 100),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// **Pick File (PDF)**
  Widget _buildFilePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "إرفاق شهادة المزرعة",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
            fontFamily: 'Almarai',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.attach_file),
          label: const Text("اختر ملف PDF"),
        ),
        if (_selectedFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("تم اختيار الملف: ${_selectedFile!.path.split('/').last}"),
          ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// **Pick Work Time (Start & End)**
  Widget _buildWorkTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "أوقات العمل",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
            fontFamily: 'Almarai',
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: GestureDetector(onTap: () => _selectTime(true), child: _buildTimeField("وقت البداية", _startTime))),
            const SizedBox(width: 10),
            Expanded(child: GestureDetector(onTap: () => _selectTime(false), child: _buildTimeField("وقت النهاية", _endTime))),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
