import 'package:flutter/material.dart';
import '../widgets/edit_farm_profile_widgets/farm_header.dart';
import '../widgets/edit_farm_profile_widgets/confirm_button.dart';
import '../widgets/edit_farm_profile_widgets/info_field.dart';

class FarmInfoScreen extends StatefulWidget {
  const FarmInfoScreen({super.key});

  @override
  FarmInfoScreenState createState() => FarmInfoScreenState();
}

class FarmInfoScreenState extends State<FarmInfoScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  // State variables for InfoField values
  String workHours = '';
  String farmDescription = '';
  String farmLocation = '';
  String contactDetails = '';
  String farmName = '';

  String personalName = '';
  String phoneNumber = '';
  String email = '';

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabSelected(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    setState(() {
      _selectedIndex = index;
    });
  }

  // Function to handle confirm button click
  void _onConfirmPressed() {
    // Here you can handle data submission or save it
    print("Confirmed! Saving Data...");
    print("Work Hours: $workHours");
    print("Farm Description: $farmDescription");
    print("Farm Location: $farmLocation");
    print("Contact Details: $contactDetails");
    print("Farm Name: $farmName");
    print("Personal Name: $personalName");
    print("Phone Number: $phoneNumber");
    print("Email: $email");

    // You can save this data to a database or API here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("تم حفظ المعلومات بنجاح!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  _farmInfoPage(),
                  _personalInfoPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _farmInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const FarmHeader(),
          const SizedBox(height: 20),
          InfoField(
              label: 'اسم المزرعة',
              value: farmName,
              onEdit: (newValue) => setState(() => farmName = newValue)),
          InfoField(
              label: 'اوقات العمل',
              value: workHours,
              onEdit: (newValue) => setState(() => workHours = newValue)),
          InfoField(
              label: 'وصف المزرعه',
              value: farmDescription,
              onEdit: (newValue) => setState(() => farmDescription = newValue)),
          InfoField(
              label: 'موقع المزرعه',
              value: farmLocation,
              onEdit: (newValue) => setState(() => farmLocation = newValue)),
          InfoField(
              label: 'بيانات التواصل',
              value: contactDetails,
              onEdit: (newValue) => setState(() => contactDetails = newValue)),
          const SizedBox(height: 20),
          TabSelector(onTabSelected: _onTabSelected, selectedIndex: _selectedIndex),
          const SizedBox(height: 20),
          ConfirmButton(onPressed: _onConfirmPressed),
        ],
      ),
    );
  }

  Widget _personalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 36.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          TabSelector(onTabSelected: _onTabSelected, selectedIndex: _selectedIndex),
          const SizedBox(height: 20),
          ConfirmButton(onPressed: _onConfirmPressed),
        ],
      ),
    );
  }
}

class TabSelector extends StatelessWidget {
  final Function(int) onTabSelected;
  final int selectedIndex;
  const TabSelector({super.key, required this.onTabSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0x1E78788C),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          _buildTab(title: 'معلومات المزرعة', index: 0),
          _buildTab(title: 'المعلومات الشخصيه', index: 1),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required int index}) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: selectedIndex == index ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            boxShadow: selectedIndex == index
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF797D82),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
