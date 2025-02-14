import 'package:flutter/material.dart';

class InfoField extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String>? onEdit;

  const InfoField({
    super.key,
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  _InfoFieldState createState() => _InfoFieldState();
}

class _InfoFieldState extends State<InfoField> {
  bool isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleEdit() {
    if (isEditing) {
      // Save the edited text
      if (widget.onEdit != null) {
        widget.onEdit!(_controller.text);
      }
    }
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: Color(0xFF333333),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 13),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF936002).withAlpha((0.2 * 255).toInt()), // Fixed withOpacity()
                blurRadius: 9,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: isEditing
                    ? TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Almarai',
                        ),
                      )
                    : Text(
                        widget.value,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Almarai',
                        ),
                      ),
              ),
              IconButton(
                icon: Icon(
                  isEditing ? Icons.check : Icons.edit,
                  color: const Color(0xFF797D82), // Updated pen color
                ),
                onPressed: toggleEdit,
              ),
            ],
          ),
        ),
        const SizedBox(height: 17),
      ],
    );
  }
}
