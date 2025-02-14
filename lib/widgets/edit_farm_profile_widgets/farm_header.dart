import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmHeader extends StatefulWidget {
  const FarmHeader({super.key});

  @override
  _FarmHeaderState createState() => _FarmHeaderState();
}

class _FarmHeaderState extends State<FarmHeader> {
  String farmName = "جاري التحميل...";
  String farmLogoUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchFarmData();
  }

  Future<void> _fetchFarmData() async {
    try {
      DocumentSnapshot farmSnapshot = await FirebaseFirestore.instance
          .collection('farms')
          .doc('FARM_ID') // Replace with actual farm document ID
          .get();

      if (farmSnapshot.exists) {
        setState(() {
          farmName = farmSnapshot['name'] ?? "اسم غير متوفر";
          farmLogoUrl = farmSnapshot['logo'] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching farm data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Text(
          'معلومات المزرعة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        const SizedBox(height: 24),
        ClipOval(
          child: farmLogoUrl.isNotEmpty
              ? Image.network(
                  farmLogoUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                )
              : Container(
                  width: 80,
                  height: 80,
                  color: const Color(0xFF292D32),
                  child: const Icon(Icons.image, color: Colors.white),
                ),
        ),
        const SizedBox(height: 21),
        Text(
          farmName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
