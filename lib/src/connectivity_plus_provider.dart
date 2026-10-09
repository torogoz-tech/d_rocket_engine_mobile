import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:d_rocket/d_rocket.dart';

import 'connectivity_plus_network_state.dart';

/// [ConnectivityProvider] backed by package:connectivity_plus.
///
/// connectivity_plus reports available network transports. It does not
/// guarantee that the public Internet or the sync server is reachable; sync
/// failures are still handled by d_rocket's retry policy.
class ConnectivityPlusProvider implements ConnectivityProvider {
  /// Creates a provider backed by [connectivity].
  ConnectivityPlusProvider({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
  }

  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  final StreamController<ConnectivityState> _changes =
      StreamController<ConnectivityState>.broadcast(sync: true);
  ConnectivityState _current = ConnectivityState.offline;

  @override
  Future<ConnectivityState> current() async {
    final List<ConnectivityResult> results =
        await _connectivity.checkConnectivity();
    final ConnectivityState state =
        ConnectivityPlusNetworkState.fromResults(results);
    _publish(state);
    return state;
  }

  @override
  Stream<ConnectivityState> get changes => _replayChanges();

  @override
  Future<bool> get isOnline async => (await current()).isOnline;

  @override
  Future<bool> get isUnmetered async => (await current()).isUnmetered;

  /// Releases the platform stream subscription and local stream controller.
  Future<void> dispose() async {
    await _subscription.cancel();
    await _changes.close();
  }

  void _onChanged(List<ConnectivityResult> results) {
    _publish(ConnectivityPlusNetworkState.fromResults(results));
  }

  void _publish(ConnectivityState state) {
    if (state.networkType == _current.networkType &&
        state.isOnline == _current.isOnline) {
      return;
    }
    _current = state;
    if (!_changes.isClosed) {
      _changes.add(state);
    }
  }

  Stream<ConnectivityState> _replayChanges() {
    late StreamController<ConnectivityState> wrapper;
    StreamSubscription<ConnectivityState>? subscription;
    wrapper = StreamController<ConnectivityState>(
      onListen: () {
        wrapper.add(_current);
        subscription = _changes.stream.listen(
          wrapper.add,
          onError: wrapper.addError,
          onDone: wrapper.close,
        );
      },
      onCancel: () async {
        await subscription?.cancel();
      },
    );
    return wrapper.stream;
  }
}
