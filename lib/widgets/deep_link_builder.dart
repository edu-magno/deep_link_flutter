import 'package:deep_link_native_to_flutter/providers/deep_link_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class _DeepLinkWidget extends StatelessWidget {
  final Widget Function(BuildContext context, AsyncSnapshot<String?> snapshot)
      builder;

  _DeepLinkWidget({required this.builder});

  @override
  Widget build(BuildContext context) {
    final stream = context.read(deepLinkProvider(context)).state;
    return StreamBuilder(
      stream: stream,
      builder: builder,
    );
  }
}

class DeepLinkBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AsyncSnapshot<String?> snapshot)
      builder;

  DeepLinkBuilder({required this.builder});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: _DeepLinkWidget(
      builder: builder,
    ));
  }
}
