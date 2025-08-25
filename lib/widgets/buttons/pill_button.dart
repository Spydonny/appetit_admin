import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.onPressed,
    required this.child, this.colorPrimary, this.colorOnPrimary,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? colorPrimary;
  final Color? colorOnPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        // полностью круглые края
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        ),
        backgroundColor: WidgetStatePropertyAll(colorPrimary ?? cs.primary),
        foregroundColor: WidgetStatePropertyAll(colorOnPrimary ?? cs.onPrimary),
        // без теней — выглядит плоско и монотонно
        elevation: const WidgetStatePropertyAll(0),
        // крупный размер
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(56)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        textStyle: WidgetStatePropertyAll(
          theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
        // отключаем разные оттенки при взаимодействии (оставляем лёгкий ripple)
        overlayColor: WidgetStatePropertyAll(
          (colorOnPrimary ?? cs.onPrimary).withAlpha(20),
        ),
      ),
      child: child,
    );
  }
}
