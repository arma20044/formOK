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
        icon: Icons.campaign,
        label: 'Falta de Energía',
        // onTap: (context) =>  Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ParentScreen(tipoReclamo: 'FE'),

        //   ),
        // ),
        onTap: (context) =>
            context.push('/reclamosFaltaEnergia', extra: {'tipoReclamo': 'FE'}),
      ),
      MenuItemModel(
        id: 'co',
        icon: Icons.request_quote,
        label: 'Comercial/Facturación',
        //badge: '5',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ReclamosScreen(tipoReclamo: 'CO'),
          ),
        ),
      ),
      MenuItemModel(
        id: 'map',
        icon: Icons.light,
        label: 'Alumbrado Público',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ReclamosScreen(tipoReclamo: 'AP'),
          ),
        ),
      ),
      MenuItemModel(
        id: 'map',
        icon: Icons.flash_off,
        label: 'Denunciá el Robo de Energía',
        onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ReclamosScreen(tipoReclamo: 'CX'),
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
        onTap: (context) =>
            context.push('/consultaFacturas'),
      ),
      MenuItemModel(
        id: 'history',
        icon: Icons.edit_document,
        label: 'Solicitudes',
        // onTap: () => debugPrint('Historial'),
      ),
      MenuItemModel(
        id: 'yoFacturoMiLuz',
        icon: Icons.electric_meter,
        label: 'Yo Facturo mi Luz',
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
            onTap: (context) =>
            context.push('/miCuenta'),
      ),
    ],
  ),
];
