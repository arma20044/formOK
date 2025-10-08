// lib/presentation/components/menu/menu_data.dart
import 'package:flutter/material.dart';
import 'package:form/presentation/screens/comercial/consulta_facturas_screen.dart';
import 'package:form/presentation/screens/mi_cuenta/mi_cuenta_screen.dart';
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
        onTap: (context) =>
            context.push('/reclamosFaltaEnergia', extra: {'tipoReclamo': 'CO'}),
      ),
      MenuItemModel(
        id: 'co',
        icon: Icons.people,
        label: 'Comercial/Facturación',
        badge: '5',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ParentScreen(tipoReclamo: 'CO'),
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
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ParentScreen(tipoReclamo: 'CX'),
          ),
        ),
      ),
    ],
  ),
  MenuGroup(
    title: 'Comercial',
    items: [
      MenuItemModel(
        id: 'consulta_factura',
        icon: Icons.document_scanner,
        label: 'Consulta de Facturas',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ConsultaFacturasScreen()),
        ),
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
            onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MiCuentaScreen()),
        ),
      ),
    ],
  ),
];
