import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form/presentation/components/drawer/auth_drawer_section.dart';
import 'package:form/presentation/components/drawer/auth_header_section.dart';
import '../../../provider/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:form/core/enviromens/enrivoment.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
     final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final themeState = ref.watch(themeNotifierProvider);

    Future<void> _launchUrl(String key) async {
      await dotenv.load(fileName: ".env");

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
          // Header separado
          const AuthHeaderSection(),

          // Login / Logout
          const AuthDrawerSection(),

          const Divider(),

          // Modo Oscuro
          ListTile(
            leading: const Icon(Icons.contrast),
            title: themeState.value!.isDarkMode ? Text('Modo Claro') : Text("Modo Oscuro"),
            onTap: () {
              Navigator.pop(context);
              themeNotifier.toggleDarkMode();
            },
          ),

          // Valorar App
          ListTile(
            leading: const Icon(Icons.favorite_border_outlined),
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
            leading: const Icon(Icons.info_outline),
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
