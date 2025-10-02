import 'package:flutter/material.dart';

// Tab 1
class Tab1 extends StatelessWidget {
  final TextEditingController controller;

  const Tab1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Campo Tab 1'),
        validator: (value) =>
            value == null || value.isEmpty ? 'Debe completar Tab 1' : null,
      ),
    );
  }
}

// Tab 2
class Tab2 extends StatelessWidget {
  final TextEditingController controller;

  const Tab2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Campo Tab 2'),
        validator: (value) =>
            value == null || value.isEmpty ? 'Debe completar Tab 2' : null,
      ),
    );
  }
}

// Tab 3
class Tab3 extends StatelessWidget {
  final TextEditingController controller;

  const Tab3({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: 'Campo Tab 3'),
        validator: (value) =>
            value == null || value.isEmpty ? 'Debe completar Tab 3' : null,
      ),
    );
  }
}
