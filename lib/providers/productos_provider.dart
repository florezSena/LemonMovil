import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart' as product;

class ProductosProvider with ChangeNotifier{
  bool _resetListProductos=false;
  int  _idProducto=0;
  product.Producto? _productoAdd;
  product.Producto? _productoUpdate;

  bool get resetListP=>_resetListProductos;
  int get productDeleteL=>_idProducto;
  product.Producto? get productAdd=>_productoAdd;
  product.Producto? get productUpdate=>_productoUpdate;


  void resetList(){
    _resetListProductos=true;
    notifyListeners();
  }
  void resetListFalse(){
    _resetListProductos=false;
  }

  void addProductList(product.Producto producto ){
    _productoAdd=producto;
    notifyListeners();
  }
  void resetProductAdd(){
    _productoAdd=null;
  }

  void updateProductList(product.Producto producto ){
    _productoUpdate=producto;
    notifyListeners();
  }
  void resetProductUpdate(){
    _productoUpdate=null;
  }

  void deleteProducttList(int idProducto){
    _idProducto=idProducto;
    notifyListeners();
  }
  void resetIdProducto(){
    _idProducto=0;
  }



}