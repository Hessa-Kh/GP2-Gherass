import 'package:flutter/material.dart';


class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      // Ensures the entire widget is centered
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensures it only takes necessary space
        children: [
          Container(
            width: 73,
            height: 73,
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
              shape: BoxShape.circle,
              image: DecorationImage(
                // ✅ Added image inside the circular box
                image: AssetImage(
                    'assets/images/profile-circle.png'), // ✅ Replace with your image path
                fit: BoxFit
                    .cover, // ✅ Ensures the image fills the circle properly
              ),
            ),
          ),
          SizedBox(height: 22),
          Text(
            name,
            style: TextStyle(
              color: Color(0xFF101010),
              fontSize: 16,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}




class NameDisplay extends StatelessWidget {
  final String name;

  const NameDisplay({Key? key, required this.name}) : super(key: key);

  @override
   Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 23, horizontal: 20), // ✅ Adjusted padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0x33936002),
            blurRadius: 9,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // ✅ Ensures content starts from the left
        children: [
          Image.asset(
            'assets/images/edit-2.png',
            width: 20,
            height: 20,
          ), // ✅ Moved image to the far left
          SizedBox(width: 10), // ✅ Adds spacing between the image and text
          Expanded( // ✅ Ensures text takes available space without pushing image
            child: Align(
              alignment: Alignment.centerRight, // ✅ Ensures text stays aligned to the right
              child: Text(
                name,
                textAlign: TextAlign.right, // ✅ Keeps text properly aligned
                style: TextStyle(
                  color: Color(0xFF797D82),
                  fontSize: 16,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Accountscreen extends StatelessWidget {
  const Accountscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(  // Wrapping the entire body in a scrollable widget
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(60),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 57),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Center( // Ensures "الحساب" is centered
                    child: Text(
                      'الحساب',
                      style: TextStyle(
                        color: Color(0xFF101010),
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  SizedBox(height: 61),
                  ProfileHeader(name: 'سعيد الصقر'),
                  SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerRight, // Ensures Arabic text aligns right
                    child: Text(
                      'الأسم',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  NameDisplay(name: 'سعيد محمد الصقر'),
                  SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight, // Ensures Arabic text aligns right
                    child: Text(
                      'رقم الجوال',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  NameDisplay(name: '+9660552032344'),
                  SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight, // Ensures Arabic text aligns right
                    child: Text(
                      'البريد الالكتروني',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  NameDisplay(name: 'alsaqer1@gmail.com'),
                  SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight, // Ensures Arabic text aligns right
                    child: Text(
                      'كلمة المرور',
                      style: TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  NameDisplay(name: '**************'),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Define action for the button here
                    },
                    child: Text(
                      'تأكيد',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF93C249), // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      minimumSize: Size(189, 50),
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.07),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PersonalInfoTab extends StatelessWidget {
  const PersonalInfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Personal Information Content'),
    );
  }
}

class FarmInfoTab extends StatelessWidget {
  const FarmInfoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('Farm Information Content'),
    );
  }
}

class AccountInfoTabs extends StatefulWidget {
  const AccountInfoTabs({Key? key}) : super(key: key);

  @override
  _AccountInfoTabsState createState() => _AccountInfoTabsState();
}

class _AccountInfoTabsState extends State<AccountInfoTabs> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 33),
          decoration: BoxDecoration(
            color: Color(0x1E78788C),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12), // ✅ Slightly increased padding
                    decoration: BoxDecoration(
                      color: _selectedIndex == 0 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: _selectedIndex == 0
                          ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: Offset(0, 3))]
                          : null,
                    ),
                    child: Center( // ✅ Ensures text is centered in the button
                      child: Text(
                        'المعلومات الشخصيه',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedIndex == 0 ? Colors.black : Color(0xFF797D82), // ✅ Fix: Change text color on selection
                          fontSize: 14, // ✅ Slightly increased font size
                          fontWeight: FontWeight.w500, // ✅ Added better font weight
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12), // ✅ Slightly increased padding
                    decoration: BoxDecoration(
                      color: _selectedIndex == 1 ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: _selectedIndex == 1
                          ? [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: Offset(0, 3))]
                          : null,
                    ),
                    child: Center( // ✅ Ensures text is centered in the button
                      child: Text(
                        'معلومات المزرعة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _selectedIndex == 1 ? Colors.black : Color(0xFF797D82), // ✅ Fix: Change text color on selection
                          fontSize: 14, // ✅ Slightly increased font size
                          fontWeight: FontWeight.w500, // ✅ Added better font weight
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        AnimatedSwitcher( // ✅ Added animation for better tab transition
          duration: Duration(milliseconds: 300),
          child: _selectedIndex == 0 ? PersonalInfoTab() : FarmInfoTab(),
        ),
      ],
    );
  }
}
