// lib/presentation/components/menu/menu_data.dart
import 'package:flutter/material.dart';
import 'package:form/presentation/components/reclamos/reclamo_screen_padre.dart';
import 'package:form/presentation/screens/reclamos/reclamos_falta_energia_screen.dart';
import 'package:go_router/go_router.dart';
import 'menu_models.dart';

final List<MenuGroup> menuGroups = [
  MenuGroup(
    title: 'Reclamos',
    items: [
      MenuItemModel(
        id: 'fe',
        icon: Icons.fact_check,
        label: 'Falta de Energía',
        // onTap: (context) =>  Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ParentScreen(tipoReclamo: 'FE'),
            
        //   ),
        // ),
        onTap: (context) => context.push('/reclamosFaltaEnergia',extra: {
          'tipoReclamo' : 'CO'
        }),
      ),
      MenuItemModel(
        id: 'co',
        icon: Icons.people,
        label: 'Comercial/Facturación',
        badge: '5',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ParentScreen(tipoReclamo: 'CO',),
          ),
        ),
      ),
      MenuItemModel(
        id: 'map',
        icon: Icons.map,
        label: 'Alumbrado Público',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ParentScreen(tipoReclamo: 'AP'),
          ),
        ),
      ),
      MenuItemModel(
        id: 'map',
        icon: Icons.bolt,
        label: 'Denunciá el Robo de Energía',
        // onTap: () => debugPrint('Mapa'),
      ),
    ],
  ),
  MenuGroup(
    title: 'Comercial',
    items: [
      MenuItemModel(
        id: 'new',
        icon: Icons.document_scanner,
        label: 'Consulta de Facturas',
        // onTap: () => debugPrint('Nuevo'),
      ),
      MenuItemModel(
        id: 'history',
        icon: Icons.history,
        label: 'Historial',
        // onTap: () => debugPrint('Historial'),
      ),
      MenuItemModel(
        id: 'reports',
        icon: Icons.bar_chart,
        label: 'Reportes',
        enabled: false,
      ),
    ],
  ),
  MenuGroup(
    title: 'Otros',
    items: [
      MenuItemModel(
        id: 'cuenta',
        icon: Icons.person,
        label: 'Mi Cuenta',
        // onTap: () => debugPrint('Configuración'),
      ),
    ],
  ),
];
