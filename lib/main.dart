import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/theme/app_theme.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/core/theme/light_theme.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/menu/main_menu.dart';
import 'package:form/presentation/screens/splash_screen.dart';
import 'package:form/provider/theme_provider.dart';

import 'presentation/components/menu/menu_data.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider.notifier);
    final themeState = ref.watch(themeNotifierProvider);
    final router = ref.watch(goRouterProvider);

   return MaterialApp(
      title: 'App Verde',
      debugShowCheckedModeBanner: false,
      theme: AppTheme(
        selectedColor: themeState.selectedColor,
        isDarkMode: themeState.isDarkMode,
      ).getTheme(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const CustomDrawer(),
        appBar: AppBar(
          title: Center(
            child: Image.asset('assets/images/logoande.png', height: 50),
          ),

          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(Icons.star, color: Colors.yellow[600], size: 50),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: MainMenu(
            groups: menuGroups, // ✅ datos externos unificados
            iconSize: 44,
          ),
        ),
      
    );
  }
}
