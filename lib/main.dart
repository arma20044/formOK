import 'package:flutter/material.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/menu/main_menu.dart';
import 'package:form/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'presentation/components/menu/menu_data.dart';



void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

     final themeProvider = Provider.of<ThemeProvider>(context);


    return MaterialApp(
      title: 'Menú Principal 3 Columnas',
      theme: themeProvider.themeData,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const String environmentActual = "desarrollo";
    final EnvironmentConfig Environment = Environments[environmentActual]!;

    print(Environment.hostCtxSiga);

    return Scaffold(
      endDrawer: const CustomDrawer(),
      appBar: AppBar(
        title: Center(
          child: Image.asset('assets/images/logoande.png', height: 60),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(Icons.star, color: Colors.yellow[600], size: 60),
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
