import 'package:form/main.dart';
import 'package:form/presentation/components/reclamos/reclamo_screen_padre.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';
import 'package:go_router/go_router.dart';


// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/',
  routes: [

    GoRoute(
      path: '/',
      //name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),

    /*GoRoute(
      path: '/buttons',
      //name: ButtonsScreen.name,
      //builder: (context, state) => const ButtonsScreen(),
    ),*/

    GoRoute(
      path: '/reclamosFaltaEnergia',
      //name: CardsScreen.name,
      builder: (context, state) => const ParentScreen(tipoReclamo: 'FE',)
    ),
  ],
);