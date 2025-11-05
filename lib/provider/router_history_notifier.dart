import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class RouteHistoryNotifier extends StateNotifier<Map<String, Uri?>> {
  RouteHistoryNotifier() : super({'previous': null, 'current': null});

  void update(Uri newUri) {
    state = {
      'previous': state['current'],
      'current': newUri,
    };
  }
}

final routeHistoryProvider =
    StateNotifierProvider<RouteHistoryNotifier, Map<String, Uri?>>(
        (ref) => RouteHistoryNotifier());
