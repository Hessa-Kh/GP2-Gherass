import 'package:flutter/material.dart';

class ProductionDateSelector extends StatefulWidget {
  const ProductionDateSelector({super.key});

  @override
  _ProductionDateSelectorState createState() => _ProductionDateSelectorState();
}

class _ProductionDateSelectorState extends State<ProductionDateSelector> {
  int selectedDay = DateTime.now().day;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  List<int> getDays() => List.generate(31, (index) => index + 1);
  List<int> getMonths() => List.generate(12, (index) => index + 1);
  List<int> getYears() =>
      List.generate(50, (index) => DateTime.now().year - index);

  void _selectDate(int day, int month, int year) {
    setState(() {
      selectedDay = day;
      selectedMonth = month;
      selectedYear = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تاريخ الإنتاج',
            style: TextStyle(
              color: Color(0xFF797D82),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
              letterSpacing: 0.16,
            ),
          ),
          const SizedBox(height: 21),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildDropdown('اليوم', getDays(), selectedDay,
                  (val) => _selectDate(val, selectedMonth, selectedYear)),
              const SizedBox(width: 17),
              _buildDropdown('الشهر', getMonths(), selectedMonth,
                  (val) => _selectDate(selectedDay, val, selectedYear)),
              const SizedBox(width: 17),
              _buildDropdown('السنة', getYears(), selectedYear,
                  (val) => _selectDate(selectedDay, selectedMonth, val)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<int> items, int selectedItem,
      ValueChanged<int> onChanged) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF797D82),
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Almarai',
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xFFEBE8E2),
            ),
            child: DropdownButton<int>(
              value: selectedItem,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
              items: items.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Center(child: Text(value.toString())),
                );
              }).toList(),
              onChanged: (value) => onChanged(value!),
            ),
          ),
        ],
      ),
    );
  }
}
