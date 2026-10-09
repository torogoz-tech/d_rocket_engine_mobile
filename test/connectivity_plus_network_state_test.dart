import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:d_rocket/d_rocket.dart';
import 'package:d_rocket_engine_mobile/d_rocket_engine_mobile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityPlusNetworkState', () {
    test('maps no transports to offline', () {
      expect(
        ConnectivityPlusNetworkState.fromResults(const []),
        ConnectivityState.offline,
      );
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.none],
        ),
        ConnectivityState.offline,
      );
    });

    test('maps wifi, ethernet, vpn, and mobile', () {
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.wifi],
        ).networkType,
        NetworkType.wifi,
      );
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.ethernet],
        ).networkType,
        NetworkType.ethernet,
      );
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.vpn],
        ).networkType,
        NetworkType.vpn,
      );
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.mobile],
        ).networkType,
        NetworkType.cellular,
      );
    });

    test('prefers an unmetered transport when multiple are reported', () {
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.mobile, ConnectivityResult.wifi],
        ).networkType,
        NetworkType.wifi,
      );
    });

    test('maps future transports conservatively to unknown online', () {
      expect(
        ConnectivityPlusNetworkState.fromResults(
          const [ConnectivityResult.other],
        ),
        const ConnectivityState(
          networkType: NetworkType.unknown,
          isOnline: true,
        ),
      );
    });
  });
}
