import 'package:flutter/material.dart';

typedef DisplayBuilder<T> = String Function(T item);

class DropdownCustom<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final DisplayBuilder<T>? displayBuilder;
  final String? Function(T?)? validator;

  const DropdownCustom({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
    this.displayBuilder,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      items: items
          .map((e) => DropdownMenuItem<T>(
                value: e,
                child: Text(displayBuilder != null ? displayBuilder!(e) : e.toString()),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
