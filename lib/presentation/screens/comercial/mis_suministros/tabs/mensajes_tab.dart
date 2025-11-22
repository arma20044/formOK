import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/model/login_model.dart';
import 'package:form/presentation/components/comercial/number_list_component.dart';
import 'package:form/provider/servicios_nis_provider.dart';

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
          ref.read(numberListAsyncProvider.notifier).fetchNumbers(nis,  token);
        });
      }
    });

    return asyncNumbers.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (numbers) => NumberListWidget(
        numbers: numbers,
        onToggleService: (number, serviceName, value) {
          ref.read(numberListAsyncProvider.notifier).toggleService(number, serviceName, value);
        },
        onDeleteNumber: (number) {
          ref.read(numberListAsyncProvider.notifier).deleteNumber(number);
        },
      ),
    );
  }
}

