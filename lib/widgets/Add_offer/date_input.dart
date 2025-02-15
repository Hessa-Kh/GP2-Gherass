import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final String label;

  const DateInput({super.key, required this.label});

  @override
  _DateInputState createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 160,
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
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: Color(0xFF101010),
              fontFamily: 'Almarai',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F4F0),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                        : '',
                    style: TextStyle(
                      color: Color(0xFF101010),
                      fontFamily: 'Almarai',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color: Color(0xFF101010),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}