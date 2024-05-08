import 'package:flutter/material.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/models/detalles_venta.dart';

class VentasProvider with ChangeNotifier{
  bool _carritoVenta = false;
  bool _clienteVenta = false;
  bool _botonCancelar = true;
  bool _botonCliente = false;
  bool _botonRelizar = false;
  double _totalVenta=0;

  List<DetallesVenta> productosAVender=[];
  Cliente? _clienteSeleccionado;

  bool get carritoVentaGet=>_carritoVenta;

  bool get clienteVentaGet=>_clienteVenta;

  bool get botonCancelarGet=>_botonCancelar;

  bool get botonClienteGet=>_botonCliente;

  bool get botonRealizarGet=>_botonRelizar;

  double get totalVentaGet=>_totalVenta;


  Cliente? get clienteGet=> _clienteSeleccionado;

  void deleteBotonRelizar(){
    _botonRelizar=false;
    notifyListeners();
  }
  void showBotonRealizar(){
    _botonRelizar=true;
    notifyListeners();
  }

  void deleteBotonCliente(){
    _botonCliente=false;
    notifyListeners();
  }
  void showBotonCliente(){
    _botonCliente=true;
    notifyListeners();
  }
  void deleteBotonCancelar(){
    _botonCancelar=false;
    notifyListeners();
  }
  void resetBotonCancelar(){
    _botonCancelar=true;
    notifyListeners();
  }

  void addCliente(Cliente cliente){
    _clienteSeleccionado = cliente;
    _clienteVenta=true;
    notifyListeners();
  }
  
  void deleteCliente(){
    _clienteSeleccionado=null;
    _clienteVenta=false;
    notifyListeners();
  }

  void addProductCarrito(DetallesVenta producto){
    productosAVender.add(producto);
    _carritoVenta=true;
    _totalVenta+=producto.subtotal;
    notifyListeners();
  }
  
  void deleteProductCarrito(DetallesVenta producto){
    productosAVender.remove(producto);
    _totalVenta-=producto.subtotal;

    if(productosAVender.isEmpty){
      _carritoVenta=false;
      _totalVenta=0;
    }
    notifyListeners();
  }
  void deleteAllProductCarrito(){
    productosAVender.clear();
    _carritoVenta=false;
    _totalVenta=0;
    notifyListeners();
  }
}