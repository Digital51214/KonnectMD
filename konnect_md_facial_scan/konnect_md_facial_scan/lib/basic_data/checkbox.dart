import 'package:flutter/material.dart';

class CircularCheckbox extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CircularCheckbox({
    super.key,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<CircularCheckbox> createState() => _CircularCheckboxState();
}

class _CircularCheckboxState extends State<CircularCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isChecked = !isChecked; // toggle true/false
        });
        widget.onChanged(isChecked); // callback
      },
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: isChecked ? Colors.blue : Colors.white, // fill color
          shape: BoxShape.circle,
          border: Border.all(
            color: isChecked ? Colors.blue : Colors.grey,
            width: 2,
          ),
        ),
        child: isChecked
            ? const Icon(
          Icons.check,
          color: Colors.white,
          size: 16,
        )
            : null,
      ),
    );
  }
}