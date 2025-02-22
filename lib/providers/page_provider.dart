import 'package:flutter/cupertino.dart';

class PageProvider with ChangeNotifier{
  static final PageProvider _instance = PageProvider._internal();
  factory PageProvider() => _instance;
  PageProvider._internal();

  bool minimizedValue = true;
  final navigatorKey = GlobalKey<NavigatorState>();
  bool isSecondaryPageValue = false;

  bool get minimized => minimizedValue;
  set minimized(bool minimized) {
    minimizedValue = minimized;
    notifyListeners();
  }

  bool get isSecondaryPage => isSecondaryPageValue;
  set isSecondaryPage(bool isSecondaryPage) {
    isSecondaryPageValue = isSecondaryPage;
    notifyListeners();
  }

  void updateIsSecondaryPage(){
    isSecondaryPage = navigatorKey.currentState?.canPop() ?? false;
  }

}
