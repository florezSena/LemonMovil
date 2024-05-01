import 'package:flutter/material.dart';

class ProductosProvider with ChangeNotifier{
  final bool _resetListProductos=true;

  bool get resetListP=>_resetListProductos;

  void resetList(){
    notifyListeners();
  }
}