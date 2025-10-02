import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form/core/auth/auth_provider.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/auth/auth_notifier.dart';
import '../../../provider/theme_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    Future<void> _launchUrl(String key) async {
      final url = dotenv.env[key]; // leer del .env
      if (url == null) return;

      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir $url');
      }
    }

    //final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // elimina el padding superior
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Mi Cuenta',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          authState.when(
            data: (user) {
              if (user != null) {
                return Text("Usuario: ${user.jWTtoken}");
              } else {
                return const Text("No logueado");
              }
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text("Error: $e"),
          ),
         authState.asData?.value?.jWTtoken == null ?
 ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Acceder'),
            onTap: () {
              Navigator.pop(context); // cerrar el drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ) : Text(''),
        
         authState.asData?.value?.jWTtoken == null ?
          ListTile(
            leading: const Icon(Icons.manage_accounts_outlined),
            title: const Text('Registrate'),
            onTap: () {
              Navigator.pop(context);
              // acción para ir a Configuración
            },
          ): Text(''),
          authState.asData?.value?.jWTtoken != null ? ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context);
              //authProvider.logout();
            },
          ):Text(''),
          Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Modo Oscuro'),
            onTap: () {
              Navigator.pop(context);
              // acción para ir a About
              // themeProvider.toggleTheme();
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_blocking),
            title: const Text('Valorar App'),
            onTap: () {
              Navigator.pop(context);
              if (Platform.isAndroid) {
                _launchUrl("VALORAR_APP_ANDROID");
              } else {
                _launchUrl("VALORAR_APP_IOS");
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.app_blocking),
            title: const Text('Políticas de Privacidad'),
            onTap: () {
              Navigator.pop(context);
              _launchUrl("POLITICAS_PRIVACIDAD");
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.youtube,
                    color: Colors.red,
                    size: 50,
                  ),
                  onPressed: () {
                    _launchUrl("YOUTUBE_URL");
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.facebook,
                    color: Colors.blue,
                    size: 50,
                  ),
                  onPressed: () {
                    _launchUrl("FACEBOOK_URL");
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.xTwitter,
                    color: Colors.black,
                    size: 50,
                  ),
                  onPressed: () {
                    _launchUrl("X_URL");
                  },
                ),
                IconButton(
                  icon: const FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Colors.orange,
                    size: 50,
                  ),
                  onPressed: () {
                    _launchUrl('INSTAGRAM_URL');
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'Version ${Environment.appVersion.android.version} - ${Environment.appVersion.android.fecha}',
            ),
          ),
        ],
      ),
    );
  }
}
