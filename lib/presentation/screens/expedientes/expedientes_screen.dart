import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ExpedienteScreen extends ConsumerStatefulWidget {
  const ExpedienteScreen({super.key});

  @override
  ConsumerState<ExpedienteScreen> createState() => _ExpedienteScreenState();
}

class _ExpedienteScreenState extends ConsumerState<ExpedienteScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  final String url = '${Environment.hostSitioAnde}/expedientes/';

   late final String usuario;
   late final String password;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final loginData = ref.watch(authProvider); // ✔️ permitido
    // usar loginData para inicializar algo
    usuario = loginData.value!.user!.numeroDocumento;
    password = loginData.value!.user!.password;
  }

  @override
  void initState() {
    super.initState();

    

   

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'DebugChannel',
        onMessageReceived: (message) {
          print('🟢 JS Debug: ${message.message}');
          if (message.message.contains("Error de login")) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message.message)));
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (pageUrl) async {
            if (pageUrl.contains('/expedientes')) {
              await _controller.runJavaScript('''
                (function waitForLogin(attempts = 0) {
                  const MAX_ATTEMPTS = 5;

                  const userInput = document.querySelector('input.jdf-frm-control-login[placeholder="Número de CI, RUC o Pasaporte"]');
                  const passInput = document.querySelector('input.jdf-frm-control-login[placeholder="Contraseña"]');
                  const loginButton = Array.from(document.querySelectorAll('button'))
                    .find(b => b.textContent.includes("Acceder al sistema"));

                  DebugChannel.postMessage("Intento #" + attempts);

                  if (userInput && passInput && loginButton) {
                    DebugChannel.postMessage("Inputs encontrados, seteando valores...");

                    const setNativeValue = (element, value) => {
                      const valueSetter = Object.getOwnPropertyDescriptor(element.__proto__, 'value').set;
                      const prototype = Object.getPrototypeOf(element);
                      const prototypeValueSetter = Object.getOwnPropertyDescriptor(prototype, 'value').set;

                      if (valueSetter && valueSetter !== prototypeValueSetter) {
                        valueSetter.call(element, value);
                      } else {
                        prototypeValueSetter.call(element, value);
                      }

                      element.dispatchEvent(new Event('input', { bubbles: true }));
                    };

                    setNativeValue(userInput, "$usuario");
                    setNativeValue(passInput, "$password");

                    DebugChannel.postMessage("Click en el botón de login");
                    loginButton.click();

                    // Revisar error de login después de 1s
                    setTimeout(() => {
                      const errorMsg = document.querySelector('.jdf-login-error');
                      if (errorMsg) {
                        DebugChannel.postMessage("Error de login: " + errorMsg.textContent);
                      }
                    }, 1000);

                  } else if (attempts < MAX_ATTEMPTS) {
                    setTimeout(() => waitForLogin(attempts + 1), 200);
                  } else {
                    DebugChannel.postMessage("No se encontraron inputs después de " + MAX_ATTEMPTS + " intentos.");
                  }
                })();
              ''');
            }

            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(title: const Text('Expedientes')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
