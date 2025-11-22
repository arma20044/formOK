import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/theme/app_theme.dart';
import 'package:form/core/router/app_router.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:form/presentation/components/menu/main_menu.dart';
import 'package:form/presentation/screens/splash_screen.dart';
import 'package:form/provider/theme_provider.dart';
import 'package:go_router/go_router.dart';
import 'presentation/components/menu/menu_data.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

/// ⚡ Provider container global para acceder desde cualquier parte
final container = ProviderContainer();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateAsync = ref.watch(themeNotifierProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: rootScaffoldMessengerKey,

      /// ⚠️ Estos se usan SOLO como fallbacks mientras carga el provider
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      /// ❌ Antes estaba fijo en light → NO permitía modo oscuro
      /// ✔ Ahora vendrá desde el `themeState`
      themeMode: ThemeMode.system,

      routerConfig: router,

      /// Builder se ejecuta SIEMPRE → aquí aplicamos el tema dinámico
      builder: (context, child) {
        return themeStateAsync.when(
          data: (themeState) {
            final appTheme = AppTheme(
              selectedColor: themeState.selectedColor,
              isDarkMode: themeState.isDarkMode,
            ).getTheme();

            return Theme(
              data: appTheme,
              child: child!,
            );
          },
          loading: () => const SplashScreen(),
          error: (e, st) => Center(child: Text('Error cargando tema: $e')),
        );
      },
    );
  }
}

/// ------------------------------------------------------
/// HOME
/// ------------------------------------------------------
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
          child: IconButton(
            icon: Icon(Icons.star, color: Colors.yellow[600], size: 50),
            onPressed: () => GoRouter.of(context).push('/favoritos'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: MainMenu(
          groups: menuGroups,
          iconSize: 44,
        ),
      ),
    );
  }
}
