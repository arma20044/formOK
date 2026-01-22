import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;
  final bool enabled;
  final Function(String)? onChanged;
  final AutovalidateMode autovalidateMode; // 👈 nuevo parámetro
  final FormFieldValidator<String>? validator;

  const CustomPhoneField({
    super.key,
    required this.controller,
    this.label = "Número de teléfono",
    this.required = true,
    this.enabled = true,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onlyPYCountry =
        countries.where((c) => c.code == 'PY').toList();

    return FormField<String>(
      autovalidateMode: autovalidateMode,
      validator: (value) {
        if (required && (value == null || value.trim().isEmpty)) {
          return 'Ingrese Número de Celular del Titular';
        }
        if (validator != null) return validator!(value);
        return null;
      },
      builder: (field) {
        final bool hasError = field.errorText != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntlPhoneField(
              invalidNumberMessage: "Número de teléfono inválido",
              controller: controller,
              enabled: enabled,
              countries: onlyPYCountry,
              initialCountryCode: 'PY',
              showDropdownIcon: false,
              disableLengthCheck: false,
              languageCode: 'es',
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  color: hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurface.withValues(alpha:  0.8),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: hasError
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorText: field.errorText,
              ),
              onChanged: (PhoneNumber phone) {
                //final value = phone.completeNumber;
                //controller.text = value;
                field.didChange(phone.number);
                onChanged?.call(phone.number);
              },
            ),
          ],
        );
      },
    );
  }
}
