# d_rocket_engine_mobile

Mobile integrations for `d_rocket` 2.1.0.

## Connectivity

`ConnectivityPlusProvider` adapts `connectivity_plus` to the core
`ConnectivityProvider` contract:

```dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:d_rocket_engine_mobile/d_rocket_engine_mobile.dart';

final connectivity = ConnectivityPlusProvider(
  connectivity: Connectivity(),
);
```

The adapter emits replayable, deduplicated state changes and maps Wi-Fi,
cellular, Ethernet, VPN, offline, and unknown transports. The plugin only
reports available transports; it does not prove that the Internet or the
sync server is reachable. d_rocket still applies its retry policy when a
request fails.

Call `dispose()` when the owning application context is destroyed.
