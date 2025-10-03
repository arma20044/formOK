import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/api/mi_ande_api.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/model/model.dart';
import 'package:form/presentation/components/drawer/custom_drawer.dart';

import '../../../infrastructure/infrastructure.dart';
import '../../../repositories/repositories.dart';

class ConsultaFacturasScreen extends ConsumerWidget {
  const ConsultaFacturasScreen({super.key});

  


  @override
  Widget build(BuildContext context, WidgetRef ref) {

 final _formKey = GlobalKey<FormState>();
  final TextEditingController _nisController = TextEditingController();

    final authState = ref.watch(authProvider);

    final token = authState.value?.user?.token;


    void _consultar() async {
    if (_formKey.currentState!.validate()) {
      final nis = _nisController.text;
      // Aquí puedes llamar tu API o lógica con el NIS
      final repoConsultaFacturas = ConsultaFacturasRepositoryImpl(
        ConsultaFacturasDatasourceImpl(MiAndeApi()),
      );

      if(token == null){
          ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Su sesion ha expirado, debe volver a logearse')));
        throw Exception('Su sesion ha expirado, debe volver a logearse');
      }

      ConsultaFacturas consultaFacturasResponse = await repoConsultaFacturas
          .getConsultaFacturas(nis, 15.toString(),token!);
      
      if (consultaFacturasResponse.error!) {
         ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(consultaFacturasResponse.errorValList![0])));
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Consultando NIS: $nis')));
    }
  }

   return Scaffold(
      endDrawer: CustomDrawer(),
      appBar: AppBar(title: const Text('Consulta NIS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nisController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'NIS',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un NIS';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Solo números permitidos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _consultar,
                  child: const Text('Consultar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

