import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_provider.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false)
                    .login(_usernameController.text, _passwordController.text);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}