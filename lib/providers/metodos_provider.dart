import 'package:flutter/material.dart';

class MetodosProvider with ChangeNotifier{
  bool _isMetodosExecute=false;

  bool get isMetodoExecuteGet=>_isMetodosExecute;

  void metodoExecuting(){
    _isMetodosExecute=true;
    notifyListeners();
  }
  void metodoExecuted(){
    _isMetodosExecute=false;
    notifyListeners();
  }
  
}