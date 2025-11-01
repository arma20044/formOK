import 'package:flutter/material.dart';
import 'package:form/model/constans/mensajes_servicios.dart';

class NumberListWidget extends StatelessWidget {
  final List<NumberItem> numbers;
  final void Function(int number, String serviceName, bool value) onToggleService;
  final void Function(int number) onDeleteNumber;

  const NumberListWidget({
    super.key,
    required this.numbers,
    required this.onToggleService,
    required this.onDeleteNumber,
  });

  @override
  Widget build(BuildContext context) {
    if (numbers.isEmpty) {
      return const Center(child: Text('No hay números en la lista'));
    }

    return ListView.builder(
      itemCount: numbers.length,
      itemBuilder: (context, index) {
        final item = numbers[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Número: ${item.number}'),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDeleteNumber(item.number),
                ),
              ],
            ),
            children: item.services.map((service) {
              return SwitchListTile(
                title: Text(service.name),
                value: service.isSelected,
                onChanged: (value) =>
                    onToggleService(item.number, service.name, value),
                secondary: Icon(
                  service.isSelected ? Icons.check_circle : Icons.cancel,
                  color: service.isSelected ? Colors.green : Colors.red,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}