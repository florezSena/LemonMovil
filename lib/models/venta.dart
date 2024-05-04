import 'package:lemonapp/models/cliente.dart';

class Venta{
  int idVenta;
  int idCliente;
  DateTime fecha;
  double total;
  int estado;
  Cliente idClienteNavigation;
  Venta(this.idVenta, this.idCliente, this.fecha,this.total, this.estado, this.idClienteNavigation);
  Map<String, dynamic> toJson() {
    return {
      'idVenta': idVenta,
      'idCliente': idCliente,
      'fecha': fecha,
      'total': total,
      'estado': estado,
      'idClienteNavigation': idClienteNavigation,
    };
  }
}