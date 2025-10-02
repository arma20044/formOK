import 'package:flutter/material.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/menu/main_menu.dart';

import 'presentation/components/menu/menu_data.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
   await dotenv.load(fileName: ".env"); // Carga las variables
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menú Principal 3 Columnas',
      theme: ThemeData(primarySwatch: Colors.green),
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
          child: Icon(Icons.star,color: Colors.yellow[600],size: 60),
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
