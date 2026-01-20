import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;
  final String label;

  const CustomSubmitButton({
    super.key,
    required this.loading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: loading ? null : onPressed,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : Text(label),
          ),
        ),
      ),
    );
  }
}
