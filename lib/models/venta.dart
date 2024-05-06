import 'package:lemonapp/models/cliente.dart';

class Venta{
  int idVenta;
  int idCliente;
  DateTime fecha;
  double total;
  int estado;
  Cliente idClienteNavigation;
  Venta(this.idVenta, this.idCliente, this.fecha,this.total, this.estado, this.idClienteNavigation);
  //de Tipo Venta a Json
  Map<String, dynamic> ventaToJson() {
    return {
      'idVenta': idVenta,
      'idCliente': idCliente,
      'fecha': fecha.toIso8601String(),
      'total': total,
      'estado': estado,
    };
  }
  static Venta ventaFromJson(Map<String, dynamic> json) {
    return Venta(
      json['idVenta'],
      json['idCliente'],
      json['fecha'],
      json['total']==null?0:json['total'].toDouble(),
      json['estado'],
      json["idClienteNavigation"]
    );
  }
}