import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/datos_fijos/lista_solicitudes_comerciales.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/presentation/components/comercial/solicitudes/custom_info_card_solicitudes.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:go_router/go_router.dart';

class SolicitudesScreen extends ConsumerStatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  ConsumerState<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends ConsumerState<SolicitudesScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // ✅ Determinamos si el usuario está autenticado
    final isAuthenticated =
        authState.value?.state == AuthState.authenticated;

    // ✅ Filtramos la lista según autenticación y campo necesitaAuth
    final filteredItems = itemsSolicitudesComerciales.where((item) {
      // Si está autenticado → mostrar solo los que necesitan auth
      if (isAuthenticated) {
        return item.necesitaAuth == true;
      }
      // Si NO está autenticado → mostrar solo los que NO necesitan auth
      return item.necesitaAuth != true;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Solicitudes")),
      endDrawer: const CustomDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];

          return CustomInfoCardSolicitudes(
            title: item.title,
            description: item.description,
            buttonText: item.buttonText,
            onPressed: () {
              context.push('/solicitudAbastecimiento');

         
        
            },
          );
        },
      ),
    );
  }
}
