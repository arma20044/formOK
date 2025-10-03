import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/providers.dart';
import '../../model/auth_state.dart';

class DropdownItem {
  final String id;
  final String name;
  DropdownItem({required this.id, required this.name});
}

List<DropdownItem> dropDownItems = [
  DropdownItem(id: 'TD001', name: 'C.I. Civil'),
  DropdownItem(id: 'TD002', name: 'RUC'),
  DropdownItem(id: 'TD004', name: 'Pasaporte'),
];

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final emailController = TextEditingController();
  final passwordController = TextEditingController();
  DropdownItem? selectedTipDocumento;

    return Scaffold(
      body: Center(
        child: authState is AuthChecking
            ? const CircularProgressIndicator()
            : authState is AuthUnauthenticated
                ? Column(
                  children: [
                    DropdownButtonFormField<DropdownItem>(
              value: selectedTipDocumento,
              hint: const Text("Seleccionar Tipo de Documento"),
              items: dropDownItems
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      ))
                  .toList(),
              onChanged: (value) {
               
                  selectedTipDocumento = value;
               
              },
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).login(
                                emailController.text,
                                passwordController.text,
                                selectedTipDocumento!.id,
                              );
                        },
                        child: const Text("Login"),
                      ),
                  ],
                )
                : authState is AuthAuthenticated
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Token: ${authState.token}"),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                            },
                            child: const Text("Logout"),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
      ),
    );
  }
}
