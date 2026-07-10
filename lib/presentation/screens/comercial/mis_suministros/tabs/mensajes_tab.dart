import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/infrastructure/infrastructure.dart';
import 'package:form/model/login_model.dart';
import 'package:form/presentation/components/comercial/number_list_component.dart';
import 'package:form/provider/servicios_nis_provider.dart';
import 'package:form/repositories/repositories.dart';

class MensajesTab extends ConsumerStatefulWidget {
  const MensajesTab(this.selectedNIS, {super.key});

  final SuministrosList? selectedNIS;

  @override
  ConsumerState<MensajesTab> createState() => _MensajesTabState();
}

class _MensajesTabState extends ConsumerState<MensajesTab> {
  bool _fetched = false; // evita llamadas múltiples

  @override
  Widget build(BuildContext context) {
    final asyncNumbers = ref.watch(numberListAsyncProvider);
    final authAsync = ref.watch(authProvider);

    // Listener seguro dentro del build
    authAsync.whenData((authData) {
      final token = authData.user?.token;
      final nis = widget.selectedNIS;

      if (!_fetched && token != null && nis != null) {
        _fetched = true;
        // Ejecutar fuera del build
        Future.microtask(() {
          ref.read(numberListAsyncProvider.notifier).fetchNumbers(nis, token);
        });
      }
    });

    return asyncNumbers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (numbers) => NumberListWidget(
        numbers: numbers,
        onToggleService: (number, serviceName, value) {
          ref
              .read(numberListAsyncProvider.notifier)
              .toggleService(number, serviceName, value);
        },
        onDeleteNumber: (number) async {
          final confirmar = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('¿Eliminar número?'),
                content: Text(
                  '¿Estás seguro de que deseas eliminar el número $number?, ésta operación no se puede deshacer.',
                ),
                actions: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), // Retorna false
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () =>
                        Navigator.of(context).pop(true), // Retorna true
                    child: const Text('Eliminar'),
                  ),
                ],
              );
            },
          );

          if (confirmar != true) return;

          if (!context.mounted) return;



          final exito = await ref
              .read(numberListAsyncProvider.notifier)
              .deleteNumber(number, widget.selectedNIS!.nisRad.toString());

          if (!context.mounted) return;

          if (exito) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Número eliminado correctamente'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Error al eliminar el número. Inténtalo de nuevo.',
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
      ),
    );
  }
}
