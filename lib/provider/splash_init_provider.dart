import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';

final splashInitProvider = FutureProvider<void>((ref) async {
  const delay = Duration(seconds: 3); // ⬅ parametrizable
  await Future.delayed(delay);

  // Llamás tu authProvider para inicializar
  await ref.read(authProvider.notifier).build();
});
