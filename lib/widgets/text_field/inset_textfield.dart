import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class InsetTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onSubmitted;

  const InsetTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.enabled,
    this.minLines,
    this.maxLines,
    this.onSubmitted,
  });

  @override
  State<InsetTextField> createState() => _InsetTextFieldState();
}

class _InsetTextFieldState extends State<InsetTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF5F5F5); // светлый фон

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            offset: Offset(-3, -3),
            blurRadius: 6,
            color: Colors.white, // светлый верхний блик
          ),
          BoxShadow(
            offset: Offset(3, 3),
            blurRadius: 6,
            color: Color(0xFFBDBDBD), // мягкая серая тень
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscure,
        enabled: widget.enabled,
        minLines: widget.obscureText ? 1 : widget.minLines,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        keyboardType: (widget.maxLines == null || (widget.maxLines ?? 1) > 1)
            ? TextInputType.multiline
            : widget.keyboardType,
        textInputAction: (widget.maxLines == null || (widget.maxLines ?? 1) > 1)
            ? TextInputAction.newline
            : TextInputAction.done,
        onSubmitted: (value) {
          if ((widget.maxLines ?? 1) == 1 && widget.onSubmitted != null) {
            widget.onSubmitted!(value);
          }
        },
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
          )
              : null,
        ),
      ),
    );
  }
}


