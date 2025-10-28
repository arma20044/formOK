import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInputWidget extends StatefulWidget {
  final String? phoneNumber;
  final String? correo;
  final void Function(String)? onSubmit;
  final bool isLoading;
  final String tipoVerificacion;

  const OtpInputWidget({
    super.key,
    this.phoneNumber,
    this.onSubmit,
    this.isLoading = false,
    required this.tipoVerificacion,
    this.correo,
  });

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
        _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      //_focusNodes[index - 1].requestFocus();
    }

    final otp = _controllers.map((c) => c.text).join();
    if (otp.length == 4 && widget.onSubmit != null) {
      //widget.onSubmit!(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.sms, size: 64, color: Colors.blueAccent),
          const SizedBox(height: 20),

          Text(
            widget.tipoVerificacion.contains("CEL")
                ? "Te enviamos un código a tu celular"
                : "Te enviamos un código a tu correo",
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
             widget.tipoVerificacion.contains("CEL")
                ? widget.phoneNumber!
                : widget.correo!
                ,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 32),

          /// Campos OTP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: 60,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => _onChanged(value, index),
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    final otp = _controllers.map((c) => c.text).join();
                    if (otp.length == 4 && widget.onSubmit != null) {
                      widget.onSubmit!(otp);
                    }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text("Confirmar código"),
          ),
        ],
      ),
    );
  }
}
