import 'package:flutter/material.dart';

class MetodosProvider with ChangeNotifier{
  bool _isMetodosExecute=false;
  bool _isModalExecute=false;

  bool get isMetodoExecuteGet=>_isMetodosExecute;
  bool get isModalExecuteGet=>_isModalExecute;

  void metodoExecuting(){
    _isMetodosExecute=true;
    notifyListeners();
  }
  void metodoExecuted(){
    _isMetodosExecute=false;
    notifyListeners();
  }

  void modalExecuting(){
    _isModalExecute=true;
    notifyListeners();
  }
  void modalExecuted(){
    _isModalExecute=false;
    notifyListeners();
  }
  
}