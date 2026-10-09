import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:d_rocket/d_rocket.dart';

/// Converts connectivity_plus results into d_rocket's engine-neutral state.
class ConnectivityPlusNetworkState {
  const ConnectivityPlusNetworkState._();

  /// Maps the active connectivity transports to a d_rocket state.
  static ConnectivityState fromResults(
    List<ConnectivityResult> results,
  ) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return ConnectivityState.offline;
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityState.wifi;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityState(
        networkType: NetworkType.ethernet,
        isOnline: true,
      );
    }
    if (results.contains(ConnectivityResult.vpn)) {
      return ConnectivityState(
        networkType: NetworkType.vpn,
        isOnline: true,
      );
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityState.cellular;
    }
    return const ConnectivityState(
      networkType: NetworkType.unknown,
      isOnline: true,
    );
  }
}
