import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/config/datos_fijos/lista_solicitudes_comerciales.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/core/auth/model/auth_state.dart';
import 'package:form/model/comercial/info_item_comercial_solicitud.dart';
import 'package:form/presentation/components/comercial/solicitudes/custom_info_card_solicitudes.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';
import 'package:go_router/go_router.dart';

class SolicitudesScreen extends ConsumerStatefulWidget {
  const SolicitudesScreen(this.publico, {super.key});
  final bool publico;

  @override
  ConsumerState<SolicitudesScreen> createState() => _SolicitudesScreenState();
}



class _SolicitudesScreenState extends ConsumerState<SolicitudesScreen> {

List<InfoItem> filtrarSolicitudes({
  required bool isAuthenticated,
  required bool isClienteComercial,
}) {
  return itemsSolicitudesComerciales.where((item) {
    
    // 1) Si NO está autenticado → mostrar solo los que NO requieren auth
    if (!isAuthenticated) {
      return item.necesitaAuth == false;
    }

    // 2) Si está autenticado → si es cliente general, ocultar "Tú Fraccionamiento"
    if (isAuthenticated && !isClienteComercial) {
      if (item.title == "Tú Fraccionamiento") return false;
    }

    // 3) Si es comercial → mostrar todo
    return true;

  }).toList();
}




  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    final isAuthenticated = authState.value?.state == AuthState.authenticated;

    final user = authState.value?.user;
    final esClienteComercial = user?.tipoCliente == '1';

  

final isClienteComercial =
    authState.value?.user?.tipoCliente == "1"; // ajusta según tu modelo

final listaFinal = filtrarSolicitudes(
  isAuthenticated: isAuthenticated,
  isClienteComercial: isClienteComercial,
);



    return Scaffold(
      appBar: AppBar(title: const Text("Solicitudes")),
      endDrawer: const CustomDrawer(),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: listaFinal.length,
        itemBuilder: (context, index) {
          final item = listaFinal[index];

          return CustomInfoCardSolicitudes(
            title: item.title,
            description: item.description,
            buttonText: item.buttonText,
            onPressed: () {
              context.push(item.path);
            },
          );
        },
      ),
    );
  }
}
