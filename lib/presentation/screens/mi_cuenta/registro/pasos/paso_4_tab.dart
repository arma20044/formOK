import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:form/provider/terminos.dart';

import '../../../../components/common/checkbox_group.dart';

class Tab4 extends ConsumerWidget {
  const Tab4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkboxes = ref.watch(formProvider.select((s) => s.tab4Checkboxes));

    if (checkboxes.isEmpty) {
      return const Center(child: Text('Seleccione una opción en Tab1'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: CheckboxGroup(
        checkboxes: checkboxes,
        onChanged: (updatedList) {
          for (var i = 0; i < updatedList.length; i++) {
            ref.read(formProvider.notifier).toggleCheckbox(i, updatedList[i].value);
          }
        },
      ),
    );
  }
}
