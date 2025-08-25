import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/theme/app_icons.dart';
import '../widgets/widgets.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logoAppetite = AppIcons.logoAppetite;

  final phoneCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void _login() {
    // TODO: API login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            ChangeLanguageRow(),
          ],
        ),
      ),
      body: Center(
        child: DefaultContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(image: logoAppetite, height: 50),
                const SizedBox(height: 16),

                Text("login".tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                InsetTextField(
                  controller: phoneCtrl,
                  hintText: "phone".tr(),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                InsetTextField(
                  controller: passwordCtrl,
                  hintText: "password".tr(),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                AuthButton(
                  onPressed: _login,
                  child: Text("login".tr()),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
