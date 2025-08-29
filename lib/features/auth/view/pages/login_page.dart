import 'package:appetit_admin/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/widgets.dart';
import '../../../../core/core.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final logoAppetite = AppIcons.logoAppetite;

  final loginCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  void _login() {
    getIt<AuthService>().login(emailOrPhone: loginCtrl.text, password: passwordCtrl.text);
    context.go('/menu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizedBox(),
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

                const Text(
                  "Вход",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                InsetTextField(
                  controller: loginCtrl,
                  hintText: "Логин",
                ),
                const SizedBox(height: 8),
                InsetTextField(
                  controller: passwordCtrl,
                  hintText: "Пароль",
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                AuthButton(
                  onPressed: _login,
                  child: const Text("Войти"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
