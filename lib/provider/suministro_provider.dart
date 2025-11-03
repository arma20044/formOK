import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/model/login_model.dart';

final selectedNISProvider = NotifierProvider<SelectedNISNotifier, SuministrosList?>(
  SelectedNISNotifier.new,
);

class SelectedNISNotifier extends Notifier<SuministrosList?> {
  @override
  SuministrosList? build() => null;

  void set(SuministrosList? nis) => state = nis;
  void clear() => state = null;
}
