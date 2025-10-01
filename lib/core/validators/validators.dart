class Validators {
  static bool notNull(Object? value) => value != null;
  static bool notEmpty(String? value) => value != null && value.trim().isNotEmpty;
  static bool isNumeric(String? value) => value != null && RegExp(r'^\d+$').hasMatch(value);
  static bool allValid(List<bool> checks) => checks.every((e) => e);
}
