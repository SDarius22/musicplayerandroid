import 'package:flutter/cupertino.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PageProvider with ChangeNotifier{
  static final PageProvider _instance = PageProvider._internal();
  factory PageProvider() => _instance;
  PageProvider._internal();

  bool minimizedValue = true;
  bool isSecondaryPageValue = false;
  int playerWidgetCurrentPageValue = 1;
  final playerController = PanelController();
  final navigatorKey = GlobalKey<NavigatorState>();


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

  int get playerWidgetCurrentPage => playerWidgetCurrentPageValue;
  set playerWidgetCurrentPage(int playerWidgetCurrentPage) {
    playerWidgetCurrentPageValue = playerWidgetCurrentPage;
    notifyListeners();
  }

  void updateIsSecondaryPage(){
    isSecondaryPage = navigatorKey.currentState?.canPop() ?? false;
  }

}
