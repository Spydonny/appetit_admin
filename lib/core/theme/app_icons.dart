import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._(); // приватный конструктор, чтобы нельзя было создать экземпляр

  static const String _basePath = 'assets/images';

  static const String logoAppetitePath = '$_basePath/logo_appetite.png';

  static const AssetImage logoAppetite = AssetImage(logoAppetitePath);
}