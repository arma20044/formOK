import 'package:flutter/material.dart';
import 'package:form/core/auth/auth_provider.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/menu/main_menu.dart';
import 'package:form/provider/theme_provider.dart';
import 'package:provider/provider.dart';

import 'presentation/components/menu/menu_data.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ChangeNotifierProvider(
        create: (context) => AuthProvider(),
        child: MaterialApp(
          title: 'Flutter Auth',
          theme: themeProvider.themeData,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child)  {
              //return authProvider.isLoggedIn ? const HomeScreen() : const LoginScreen();
              return HomeScreen();
            }
           ),
        
      )
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
        backgroundColor: ThemeProvider().themeData.primaryColor,

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
