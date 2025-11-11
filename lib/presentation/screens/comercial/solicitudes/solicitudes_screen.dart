import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/datos_fijos/lista_solicitudes_comerciales.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/presentation/components/comercial/solicitudes/custom_info_card_solicitudes.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

class SolicitudesScreen extends ConsumerStatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  ConsumerState<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends ConsumerState<SolicitudesScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Solicitudes")),
      endDrawer: CustomDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: itemsSolicitudesComerciales.length,
        itemBuilder: (context, index) {
          final item = itemsSolicitudesComerciales[index];

          if (authState.value!.state == AuthState.authenticated &&
              item.necesitaAuth != null &&
              item.necesitaAuth!) {
            return CustomInfoCardSolicitudes(
              title: item.title,
              description: item.description,
              buttonText: item.buttonText,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Presionaste: ${item.title}')),
                );
              },
            );
          } else {
            return CustomInfoCardSolicitudes(
              title: item.title,
              description: item.description,
              buttonText: item.buttonText,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Presionaste: ${item.title}')),
                );
              },
            );
          }
        },
      ),
    );
  }
}
