import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/FormProvider.dart';


class Tab1Widget extends StatelessWidget {
  const Tab1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<FormProvider>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: formProvider.departamento,
            items: ['Dep1', 'Dep2', 'Dep3']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: formProvider.setDepartamento,
            validator: (value) => value == null ? "Seleccione un departamento" : null,
            decoration: const InputDecoration(labelText: "Departamento"),
          ),
          const SizedBox(height: 16),
         /* DropdownButtonFormField<String>(
            value: formProvider.ciudad,
            items: (formProvider.departamento == null
                    ? []
                    : ['Ciudad1', 'Ciudad2', 'Ciudad3'])
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: formProvider.setCiudad,
            validator: (value) => value == null ? "Seleccione una ciudad" : null,
            decoration: const InputDecoration(labelText: "Ciudad"),
          ),*/
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: formProvider.tipoReclamo,
            items: ['Reclamo1', 'Reclamo2']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: formProvider.setTipoReclamo,
            validator: (value) => value == null ? "Seleccione un tipo de reclamo" : null,
            decoration: const InputDecoration(labelText: "Tipo de Reclamo"),
          ),
        ],
      ),
    );
  }
}
