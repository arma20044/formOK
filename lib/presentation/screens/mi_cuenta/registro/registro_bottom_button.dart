import 'package:flutter/material.dart';

class RegistroBottomButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const RegistroBottomButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text("Registrar"),
      ),
    );
  }
}
