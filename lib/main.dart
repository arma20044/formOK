import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/theme/app_theme.dart';
import 'package:form/core/auth/auth_provider.dart';
import 'package:form/core/enviromens/Enrivoment.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/presentation/auth/login_screen.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/menu/main_menu.dart';
import 'package:form/provider/theme_provider.dart';


import 'presentation/components/menu/menu_data.dart';

void main() {
  runApp(
    ProviderScope(
    child:   MyApp()
    )
  );
}

class MyApp extends  ConsumerWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

       final theme = ref.watch(themeProvider);

  
    

    return  MaterialApp.router(
          routerConfig: appRouter,
          title: 'Flutter Auth',
          theme: theme,
          
        
      
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    

    

    return MaterialApp(
      theme: AppTheme(selectedColor: 3).getTheme(),
      
          title: 'Flutter Auth',
      home: Scaffold(
        endDrawer: const CustomDrawer(),
        appBar: AppBar(
          //backgroundColor: ThemeProvider().themeData.primaryColor,
      
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
      ),
    );
  }
}
