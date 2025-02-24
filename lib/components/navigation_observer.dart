import 'package:flutter/cupertino.dart';
import 'package:musicplayerandroid/providers/selection_provider.dart';

class SecondNavigatorObserver extends NavigatorObserver {
  SecondNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    SelectionProvider().clear();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    SelectionProvider().clear();
  }
}
