import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_provider.dart';
import 'package:form/model/login_model.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

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

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  DropdownItem? selectedTipDocumento;

  @override
  void initState() {
    super.initState();

  
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

     // Listener para cambios en el estado de login
  ref.listen<AsyncValue<Login?>>(authProvider, (previous, next) {
  next.whenOrNull(
    data: (user) {
      if (user != null) {
        // Espera al siguiente frame para que el context esté listo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/'); // Navega al HomeScreen
        });
      }
    },
    error: (error, _) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    },
  );
});


    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
                setState(() {
                  selectedTipDocumento = value;
                });
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
            authState.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (selectedTipDocumento != null) {
                        ref
                            .read(authProvider.notifier)
                            .login(
                              emailController.text,
                              passwordController.text,
                              selectedTipDocumento!.id,
                            );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Debe seleccionar un tipo de documento")),
                        );
                      }
                    },
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
