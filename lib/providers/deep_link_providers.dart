import 'package:deep_link_native_to_flutter/blocs/deep_link_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod/riverpod.dart';

Provider<DeepLinkBloc> deepLinkProvider(BuildContext context) =>
    Provider<DeepLinkBloc>((ref) => DeepLinkBloc(context: context));
