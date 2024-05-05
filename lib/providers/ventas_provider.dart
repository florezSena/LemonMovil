import 'package:flutter/material.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/models/detalles_venta.dart';

class VentasProvider with ChangeNotifier{
  bool _carritoVenta = false;
  bool _clienteVenta = false;
  bool _ventaCancelada = false;

  
  List<DetallesVenta> productosAVender=[];
  Cliente? cliente;

  bool get carritoVentaGet=>_carritoVenta;

  bool get clienteVentaGet=>_clienteVenta;

  bool get ventaCanceladaGet=>_ventaCancelada;

  void cancelarVenta(){
    _clienteVenta=true;
    notifyListeners();
  }
  void resetCancelarVenta(){
    _clienteVenta=false;
    notifyListeners();
  }

  void addCliente(Cliente cliente){
    cliente = cliente;
    _clienteVenta=true;
    notifyListeners();
  }
  
  void deleteCliente(){
    cliente = null;
    _clienteVenta=false;
    notifyListeners();
  }

  void addProductCarrito(DetallesVenta producto){
    productosAVender.add(producto);
    _carritoVenta=true;
    notifyListeners();
  }
  
  void deleteProductCarrito(DetallesVenta producto){
    productosAVender.remove(producto);
    if(productosAVender.isEmpty){
      _carritoVenta=false;
    }
    notifyListeners();
  }
  void deleteAllProductCarrito(){
    productosAVender.clear();
    _carritoVenta=false;
    notifyListeners();
  }



}