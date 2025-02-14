import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  final String option1;
  final String option2;
  final ValueChanged<String> onChanged; // أضف هذا السطر

  const ToggleButton({
    Key? key,
    required this.option1,
    required this.option2,
    required this.onChanged, // أضف هذا السطر
  }) : super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool _isOption1Selected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0x1E78788C),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isOption1Selected = true);
                widget.onChanged(widget.option1); // أضف هذا السطر
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _isOption1Selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: _isOption1Selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.option1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF797D82),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _isOption1Selected = false);
                widget.onChanged(widget.option2); // أضف هذا السطر
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !_isOption1Selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: !_isOption1Selected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  widget.option2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF797D82),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
