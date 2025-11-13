import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class CustomPhoneField extends FormField<String> {
  CustomPhoneField({
    super.key,
    required TextEditingController controller,
    String label = "Número de teléfono",
    bool required = true,
    bool enabled = true,
    Function(String)? onChanged,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) : super(
          initialValue: controller.text,
          validator: (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return 'Ingrese Número de Celular del Titular';
            }
            if (validator != null) return validator(value);
            return null;
          },
          onSaved: onSaved,
          builder: (field) {
            final theme = Theme.of(field.context);
            final onlyPYCountry =
                countries.where((c) => c.code == 'PY').toList();

            final bool hasError = field.errorText != null;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
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
                          : theme.colorScheme.onSurface.withOpacity(0.8),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: hasError
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.colorScheme.error,
                        width: 2,
                      ),
                    ),
                    errorText: field.errorText,
                  ),
                  onChanged: (PhoneNumber phone) {
                   // final value = phone.completeNumber;
                   // controller.text = value;
                    field.didChange(phone.number);
                    //onChanged?.call(value);
                  },
                ),
              ],
            );
          },
        );
}
