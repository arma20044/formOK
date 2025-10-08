import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/core/enviromens/enrivoment.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../provider/theme_provider.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    Future<void> _launchUrl(String key) async {
      final url = dotenv.env[key];
      if (url == null) return;

      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception('No se pudo abrir $url');
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // DrawerHeader
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: authState.when(
              data: (state) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state.state == AuthState.authenticated)
                    Text(
                      '${state.user?.nombre} ${state.user?.apellido}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mi Cuenta',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
              error: (_, __) => const Text('Error cargando usuario', style: TextStyle(color: Colors.white)),
            ),
          ),

          // Estado de autenticación
          authState.when(
            data: (state) => Column(
              children: [
                if (state.state == AuthState.authenticated)
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Cerrar Sesión'),
                    onTap: () {
                      Navigator.pop(context);
                      ref.read(authProvider.notifier).logout();
                    },
                  ),
                if (state.state == AuthState.unauthenticated ||
                    state.state == AuthState.error)
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Acceder'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
              ],
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),

          const Divider(),

          // Modo Oscuro
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Modo Oscuro'),
            onTap: () {
              Navigator.pop(context);
              ref.read(themeProvider.notifier).toggleTheme();
            },
          ),

          // Valorar App
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

          // Políticas de Privacidad
          ListTile(
            leading: const Icon(Icons.app_blocking),
            title: const Text('Políticas de Privacidad'),
            onTap: () {
              Navigator.pop(context);
              _launchUrl("POLITICAS_PRIVACIDAD");
            },
          ),

          // Redes sociales
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.youtube,
                      color: Colors.red, size: 50),
                  onPressed: () => _launchUrl("YOUTUBE_URL"),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.facebook,
                      color: Colors.blue, size: 50),
                  onPressed: () => _launchUrl("FACEBOOK_URL"),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.xTwitter,
                      color: Colors.black, size: 50),
                  onPressed: () => _launchUrl("X_URL"),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.instagram,
                      color: Colors.orange, size: 50),
                  onPressed: () => _launchUrl('INSTAGRAM_URL'),
                ),
              ],
            ),
          ),

          // Version
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
