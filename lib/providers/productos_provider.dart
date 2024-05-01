import 'package:flutter/material.dart';

class ProductosProvider with ChangeNotifier{
  bool _resetListProductos=false;

  bool get resetListP=>_resetListProductos;

  void resetList(){
    _resetListProductos=true;
    notifyListeners();
  }

  void resetListFalse(){
    _resetListProductos=false;
  }
}