import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/presentation/components/common/checkbox_group.dart';
import 'package:flutter_riverpod/legacy.dart';


// Estado del formulario
class FormStateTerminosCondiciones {
  final String selectedDropdown;
  final List<CustomCheckbox> tab4Checkboxes;

  FormStateTerminosCondiciones({
    this.selectedDropdown = '',
    this.tab4Checkboxes = const [],
  });

  FormStateTerminosCondiciones copyWith({
    String? selectedDropdown,
    List<CustomCheckbox>? tab4Checkboxes,
  }) {
    return FormStateTerminosCondiciones(
      selectedDropdown: selectedDropdown ?? this.selectedDropdown,
      tab4Checkboxes: tab4Checkboxes ?? this.tab4Checkboxes,
    );
  }
}

// Notifier del formulario
class FormNotifier extends StateNotifier<FormStateTerminosCondiciones> {
  FormNotifier() : super(FormStateTerminosCondiciones());

  /// Actualiza el dropdown y reemplaza la lista de checkboxes
  void updateDropdown(String value, List<CustomCheckbox> options) {
    state = state.copyWith(
      selectedDropdown: value,
      tab4Checkboxes: options,
    );
  }

  /// Alterna el valor de un checkbox por índice
  void toggleCheckbox(int index, bool value) {
    if (index < 0 || index >= state.tab4Checkboxes.length) return;

    final updatedCheckboxes = [...state.tab4Checkboxes];
    final current = updatedCheckboxes[index];
    updatedCheckboxes[index] = CustomCheckbox(
      fragments: current.fragments,
      value: value,
    );

    state = state.copyWith(tab4Checkboxes: updatedCheckboxes);
  }

  /// Validar si todos los checkboxes están marcados
  bool areAllCheckboxesChecked() {
    return state.tab4Checkboxes.every((cb) => cb.value);
  }
}

// Provider global
final formProvider = StateNotifierProvider<FormNotifier, FormStateTerminosCondiciones>(
  (ref) => FormNotifier(),
);
