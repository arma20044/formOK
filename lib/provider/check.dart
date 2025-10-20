import 'package:flutter_riverpod/legacy.dart';
import 'package:form/presentation/components/common/checkbox_group.dart';

final tab4CheckboxProvider =
    StateNotifierProvider<Tab4CheckboxNotifier, List<CustomCheckbox>>(
  (ref) => Tab4CheckboxNotifier(),
);

class Tab4CheckboxNotifier extends StateNotifier<List<CustomCheckbox>> {
  Tab4CheckboxNotifier() : super([]);

  void setCheckboxes(List<CustomCheckbox> options) {
    // Conserva valores previos si existen
    final newState = options.map((option) {
      final existing = state.firstWhere(
        (e) => e.fragmentsToText() == option.fragmentsToText(),
        orElse: () => option,
      );
      return CustomCheckbox(
        fragments: option.fragments,
        value: existing.value,
      );
    }).toList();

    state = newState;
  }

  void toggle(int index, bool value) {
    final updated = [...state];
    updated[index] = CustomCheckbox(
      fragments: updated[index].fragments,
      value: value,
    );
    state = updated;
  }
}
