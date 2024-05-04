import 'dart:convert';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/services/config.dart';
import 'package:http/http.dart' as http;

Future<List<Venta>> getVentas() async {
  List<Venta> ventas=[];

  final Uri url = Uri.parse("$httpUrl/Ventums/GetVentas");
  try{
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData=jsonDecode(body);

      for (var element in jsonData) {
        ventas.add(
          Venta(
            element['idVenta'],
            element['idCliente'],
            DateTime.parse(element['fecha']),
            element['total'].toDouble(),
            element['estado'],
            Cliente.fromJson(element['idClienteNavigation']),
          )
        );
      }
      
      return ventas;
    }else if(response.statusCode==403){
      //Salir del aplicativo
      throw Exception("Sin permisos");

    }else{
      throw Exception("Error en la peticion ${response.statusCode}");
    }
  }catch(error){
    throw Exception("Error de catch: $error");
  }
}


Future<List<DetallesVenta>> getDetalleVentas(int idVenta) async {
  List<DetallesVenta> detallesVentas=[];

  final Uri url = Uri.parse("$httpUrl/DetalleVentums/GetDetallesVenta?id=$idVenta");
  try{
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData=jsonDecode(body);

      for (var element in jsonData) {
        detallesVentas.add(
          DetallesVenta(
            element['idDetalleVenta'],
            element['idVenta'],
            element['idProducto'],
            element['cantidad'].toDouble(),
            element['precioKilo'].toDouble(),
            element['subtotal'].toDouble(),
            Producto.fromJson(element['idProductoNavigation']),
          )
        );
      }
      
      return detallesVentas;
    }else if(response.statusCode==403){
      //Salir del aplicativo
      throw Exception("Sin permisos");

    }else{
      throw Exception("Error en la peticion ${response.statusCode}");
    }
  }catch(error){
    throw Exception("Error de catch: $error");
  }
}
