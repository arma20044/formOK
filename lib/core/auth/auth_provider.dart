import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form/core/auth/auth_notifier.dart';
import 'package:form/model/login_model.dart';

final authProvider =
    AsyncNotifierProvider<AuthNotifier, Login?>(() => AuthNotifier());
