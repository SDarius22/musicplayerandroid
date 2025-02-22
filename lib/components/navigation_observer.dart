import 'package:flutter/cupertino.dart';
import 'package:musicplayerandroid/providers/page_provider.dart';

class SecondNavigatorObserver extends NavigatorObserver {
  SecondNavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    PageProvider().updateIsSecondaryPage();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    PageProvider().updateIsSecondaryPage();
    
  }
}