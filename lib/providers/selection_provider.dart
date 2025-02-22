import 'package:flutter/cupertino.dart';

class SelectionProvider with ChangeNotifier{
  static final SelectionProvider _instance = SelectionProvider._internal();
  factory SelectionProvider() => _instance;
  SelectionProvider._internal();

  List<String> selected = [];

  int get length => selected.length;

  void remove(String value){
    selected.remove(value);
    notifyListeners();
  }

  void add(String value){
    selected.add(value);
    notifyListeners();
  }

  void clear(){
    selected.clear();
    notifyListeners();
  }

  bool contains(String value){
    return selected.contains(value);
  }



}
