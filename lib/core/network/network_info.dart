import 'package:connectivity_plus/connectivity_plus.dart';

/// Network connectivity checker
class NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfo(this._connectivity);

  /// Check if device has internet connection
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();

    // Check if connected to mobile or wifi
    return result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet;
  }

  /// Stream of connectivity changes
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
