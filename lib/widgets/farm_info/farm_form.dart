import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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

  // اختيار صورة من الجهاز أو الكاميرا
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // اختيار ملف PDF
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

  // اختيار وقت العمل (بداية ونهاية)
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
              _buildFormField(label: 'اسم المزرعة', hint: 'اسم المزرعة'),
              _buildFormField(label: 'موقع المزرعة', hint: 'تحديد الموقع'),
              _buildFilePicker(),
              _buildWorkTimePicker(),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
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

  /// **ويدجت اختيار صورة المزرعة**
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
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: const Text("اختر من الجهاز"),
              ),
            ),
            const SizedBox(width: 10),
           
          ],
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

  /// **ويدجت اختيار وقت العمل (بداية ونهاية)**
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
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(true),
                child: _buildTimeField("وقت البداية", _startTime),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _selectTime(false),
                child: _buildTimeField("وقت النهاية", _endTime),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  /// **ويدجت اختيار ملف PDF**
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

  /// **ويدجت إدخال نص عام**
  Widget _buildFormField({required String label, required String hint}) {
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

  /// **ويدجت إدخال وقت العمل**
  Widget _buildTimeField(String label, TimeOfDay? time) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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
}
