import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final StreamController<List<ConnectivityResult>> _connectivityController = StreamController<List<ConnectivityResult>>();
  Stream<List<ConnectivityResult>> get connectionStream => _connectivityController.stream;


  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((event) {
      _connectivityController.add(event);
    });
  }
}
