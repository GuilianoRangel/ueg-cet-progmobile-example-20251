import 'package:collegeapi/collegeapi.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routefly/routefly.dart';

import '../../main.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({super.key});

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}
class _LoginScreenPageState extends State<LoginScreenPage> {
  AppApi? api;
  late AuthAPIApi? authApi;
  final TextEditingController _loginTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    this.initApi(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Imagem centralizada
            Center(
              child: Image.asset(
                'assets/imgs/login_universidade.png',
                height: 150,
              ),
            ),
            const SizedBox(height: 32),

            // 2. Input para login
            TextField(
              decoration: InputDecoration(
                labelText: 'Login',
                border: OutlineInputBorder(),
              ),
              controller: _loginTextController,
            ),
            const SizedBox(height: 16),

            // 3. Input para password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              controller: _passwordTextController,
            ),
            const SizedBox(height: 8),

            // 4. Link abaixo do input password para criar usuário
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navegar para tela de criação de usuário
                },
                child: const Text('Criar usuário'),
              ),
            ),
            const SizedBox(height: 16),

            // 5. Botão para login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  this.login();
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void initApi(BuildContext context) {
    if(this.api == null){
      this.api = context.read<AppApi>();
      this.authApi = api?.api.getAuthAPIApi();
    }
  }

  void login() {
    var authDTO = AuthDTO((a) => a
    ..login = _loginTextController.text
    ..password = _passwordTextController.text,
    );
    this.authApi?.login(authDTO: authDTO).then((value) {
      print(value);

      this.api?.token.value = value.data?.accessToken ?? "";
      Routefly.navigate(routePaths.lib.app);
    },onError: (error) {
      if(error.response?.statusCode == 400){
        showSnackBar(context, error.response?.data['message']);
      }else if(error.response?.statusCode == 403){
        showSnackBar(context, error.response?.data['message']);
        Routefly.navigate(routePaths.auth.login);
      } else {
        showSnackBar(context, "Erro: " + error.toString());
        print("DEBUG: Erro ao fazer login2:" + error.toString());
      }
    });
  }
}
