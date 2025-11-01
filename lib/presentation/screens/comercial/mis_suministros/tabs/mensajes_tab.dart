import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/model/constans/mensajes_servicios.dart';
import 'package:form/presentation/components/comercial/number_list_component.dart';

class MensajesTab extends ConsumerWidget {
  const MensajesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final numbers = ref.watch(numberListProvider);
    final List<NumberItem> numbers = [
      NumberItem(
        number: 101,
        services: [
          ServiceItem(name: 'Opción A'),
          ServiceItem(name: 'Opción B'),
        ],
      ),
      NumberItem(
        number: 102,
        services: [
          ServiceItem(name: 'Opción A'),
          ServiceItem(name: 'Opción B'),
          ServiceItem(name: 'Opción C'),
        ],
      ),
    ];
    return Column(
      children: [
        Expanded(
          child: NumberListWidget(
            numbers: numbers,
            onToggleService: (number, serviceName, value) {
              /* ref
                    .read(numberListProvider.notifier)
                    .toggleService(number, serviceName, value);*/
            },
            onDeleteNumber: (number) {
              /// ref.read(numberListProvider.notifier).deleteNumber(number);
            },
          ),
        ),
      ],
    );
  }
}
