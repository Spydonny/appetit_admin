import 'package:flutter/material.dart';

class InsetDropdown<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const InsetDropdown({
    super.key,
    this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF5F5F5); // светлый фон

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          // светлая подсветка сверху-слева
          BoxShadow(
            offset: Offset(-3, -3),
            blurRadius: 6,
            color: Colors.white,
          ),
          // мягкая серая тень снизу-справа
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 6,
            color: Color(0xFFBDBDBD),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText ?? "",
            style: const TextStyle(color: Colors.grey),
          ),
          dropdownColor: backgroundColor,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          isExpanded: true,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

