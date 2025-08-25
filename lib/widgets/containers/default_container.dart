import 'package:flutter/material.dart';

class DefaultContainer extends StatelessWidget {
  const DefaultContainer({super.key, this.width, this.height, this.color = Colors.white12,
    this.padding = const EdgeInsets.all(32), this.margin = const EdgeInsets.all(8), required this.child,
  });
  final Widget child;
  final Color color;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      padding: padding,
      margin: margin,
      child: child,
    );
  }
}
