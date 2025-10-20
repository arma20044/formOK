import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:form/provider/terminos.dart';

import '../../../../components/common/checkbox_group.dart';

class Tab4 extends ConsumerWidget {
  final GlobalKey<FormState> formKey;

  const Tab4({super.key, required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkboxes = ref.watch(formProvider.select((s) => s.tab4Checkboxes));

    if (checkboxes.isEmpty) {
      return const Center(child: Text('Seleccione una opción en Tab1'));
    }

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormField<bool>(
            initialValue: checkboxes.every((c)=> c.value),
            validator: (_) {
              final allChecked = checkboxes.every((c) => c.value);
              if (!allChecked) return 'Debe aceptar todos los términos';
              return null;
            },
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxGroup(
                  checkboxes: checkboxes,
                  onChanged: (updatedList) {
                    for (var i = 0; i < updatedList.length; i++) {
                      ref
                          .read(formProvider.notifier)
                          .toggleCheckbox(i, updatedList[i].value);
                    }
      
                     // ✅ notificar al FormField que hubo cambios
                    final allChecked = updatedList.every((c) => c.value);
                    field.didChange(allChecked);
                  },
                ),
                 if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
