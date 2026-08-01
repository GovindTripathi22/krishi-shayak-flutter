import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../logger/app_logger.dart';

enum NetworkStatus { online, offline }

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, NetworkStatus>((ref) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StateNotifier<NetworkStatus> {
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  ConnectivityNotifier() : super(NetworkStatus.online) {
    _init();
  }

  void _init() async {
    final results = await Connectivity().checkConnectivity();
    _updateStatus(results);

    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      state = NetworkStatus.offline;
      AppLogger.warning('NetworkStatus: Device is OFFLINE');
    } else {
      state = NetworkStatus.online;
      AppLogger.info('NetworkStatus: Device is ONLINE');
    }
  }

  bool get isOnline => state == NetworkStatus.online;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
