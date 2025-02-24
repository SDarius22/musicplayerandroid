import 'package:flutter/cupertino.dart';

class SelectionProvider with ChangeNotifier{
  static final SelectionProvider _instance = SelectionProvider._internal();
  factory SelectionProvider() => _instance;
  SelectionProvider._internal();

  Map<int, String> selected = {};

  void remove(int id){
    selected.remove(id);
    notifyListeners();
  }

  void add(int id, String path){
    selected[id] = path;
    notifyListeners();
  }

  void clear(){
    selected.clear();
    notifyListeners();
  }

  bool contains(int value){
    return selected.containsKey(value);
  }



}
