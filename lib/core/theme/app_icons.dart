import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._(); // приватный конструктор, чтобы нельзя было создать экземпляр

  static const String _basePath = 'assets/images';

  // Logo icons
  static const String logoAppetitePath = '$_basePath/logo_appetite.png';
  static const String logoAppetiteRoundPath = '$_basePath/logo_appetit_round.png';

  // combo
  static const String friesPepsiPath = '$_basePath/fries_pepsi.jpg';

  // snacks
  static const String cheburekiPath = '$_basePath/chebureki.jpg';
  static const String friesPath = '$_basePath/fries.jpg';

  // sauces
  static const String sauceCheesePath = '$_basePath/sauce_cheese.jpg';
  static const String sauceGarlicPath = '$_basePath/sauce_garlic.jpg';
  static const String sauceSpicyPath = '$_basePath/sauce_spicy.jpg';
  static const String sauceTomatoPath = '$_basePath/sauce_tomato.jpg';

  // diches
  static const String shaurmCheesePath = '$_basePath/shaurm_cheese.jpg';
  static const String shaurmChickPath = '$_basePath/shaurm_chick.jpg';
  static const String shaurmClassPath = '$_basePath/shaurm_class.jpg';
  static const String donerPath = '$_basePath/doner.jpg';


  static const AssetImage logoAppetite = AssetImage(logoAppetitePath);
  static const AssetImage logoAppetiteRound = AssetImage(logoAppetiteRoundPath);
  static const AssetImage chebureki = AssetImage(cheburekiPath);
  static const AssetImage doner = AssetImage(donerPath);
  static const AssetImage fries = AssetImage(friesPath);
  static const AssetImage friesPepsi = AssetImage(friesPepsiPath);
  static const AssetImage sauceCheese = AssetImage(sauceCheesePath);
  static const AssetImage sauceGarlic = AssetImage(sauceGarlicPath);
  static const AssetImage sauceSpicy = AssetImage(sauceSpicyPath);
  static const AssetImage sauceTomato = AssetImage(sauceTomatoPath);
  static const AssetImage shaurmCheese = AssetImage(shaurmCheesePath);
  static const AssetImage shaurmChick = AssetImage(shaurmChickPath);
  static const AssetImage shaurmClass = AssetImage(shaurmClassPath);
}