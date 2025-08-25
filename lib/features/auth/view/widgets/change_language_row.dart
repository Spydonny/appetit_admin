import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeLanguageRow extends StatelessWidget {
  const ChangeLanguageRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () =>
              context.setLocale(const Locale('ru')),
          child: const Text("RU"),
        ),
        ElevatedButton(
          onPressed: () =>
              context.setLocale(const Locale('kk')),
          child: const Text("KZ"),
        ),
      ],
    );
  }
}
