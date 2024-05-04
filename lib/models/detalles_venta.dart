import 'package:lemonapp/models/producto.dart';

class DetallesVenta{
  int idDetalleVenta;
  int idVenta;
  int idProducto;
  double cantidad;
  double precioKilo;
  double subtotal;
  Producto idProductoNavigation;
  DetallesVenta(this.idDetalleVenta, this.idVenta,this.idProducto , this.cantidad,this.precioKilo, this.subtotal, this.idProductoNavigation);
  Map<String, dynamic> detallesVentaToJson() {
    return {
      'idDetalleVenta': idDetalleVenta,
      'idVenta': idVenta,
      'idProducto':idProducto,
      'cantidad': cantidad,
      'precioKilo': precioKilo,
      'subtotal': subtotal,
      'idProductoNavigation': idProductoNavigation,
    };
  }
}