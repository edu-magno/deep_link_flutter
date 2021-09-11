import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class DeepLinkBloc {
  final stream = EventChannel('https.magnurs.deep.link.com/event');
  final platform = MethodChannel('https.magnurs.deep.link.com/channel');

  StreamController<String?> _stateController = StreamController();
  Stream<String?> get state => _stateController.stream;
  Sink<String?> get stateSink => _stateController.sink;

  BuildContext context;
  DeepLinkBloc({required this.context}) {
    startUri().then((uri) => _onRedirected(uri));
    stream.receiveBroadcastStream().listen((event) => _onRedirected(event));
  }

  Future<String?> startUri() async {
    try {
      return platform.invokeMethod('deepLink');
    } catch (err) {
      return "Failed to invoke deepLink method. Error: $err";
    }
  }

  _onRedirected(String? uri) {
    // Here can be any uri analysis, checking tokens etc, if it’s necessary
    // Throw deep link URI into the BloC's stream
    stateSink.add(uri);
    _handleDeepLink(uri);
  }

  Future<void> _handleDeepLink(String? uri) async {
    if (uri != null) {
      final uriParsed = Uri.parse(uri);

      if (uriParsed.path != "") {
        navigatorHandler(uriParsed.path, {...uriParsed.queryParameters});
      }
    }
  }

  void navigatorHandler(String path, Map<String, dynamic> arguments) {
    print('NAVIGATE TO $path');
    Navigator.pushNamed(context, path, arguments: arguments);
  }

  void dispose() {
    _stateController.close();
  }
}
