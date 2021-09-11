import 'package:deep_link_native_to_flutter/deep_link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('TESTE')),
        ),
        body: DeepLinkBuilder(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('no deeplink'),
              );
            } else {
              return Center(
                child: Text('${snapshot.data}'),
              );
            }
          },
        ),
      ),
    );
  }
}
