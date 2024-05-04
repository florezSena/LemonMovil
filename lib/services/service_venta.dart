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
            Cliente.clienteFromJson(element['idClienteNavigation']),
          )
        );
      }
      ventas.sort((a, b) => b.fecha.compareTo(a.fecha));
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
            Producto.productoFromJson(element['idProductoNavigation']),
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

Future<bool>  anularVenta(Venta ventaAAnular) async {
  try{
    //Traemos los detalles de la venta para saber cual es el producto que debemos restar
    final Uri urlDetallesVenta = Uri.parse("$httpUrl/DetalleVentums/GetDetallesVenta?id=${ventaAAnular.idVenta}");
    final responseDetalleVenta = await http.get(
      urlDetallesVenta,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    //Si la respuesta no es 200 hubo un error
    if(responseDetalleVenta.statusCode!=200){
      return false;
    }
    String body = utf8.decode(responseDetalleVenta.bodyBytes);

    final detallesVentaJson=jsonDecode(body);
    //A cada producto del detalle le vamos a restar la cantidad vendida
    for (var detalleVenta in detallesVentaJson) {
      //Traemos el proudcto del detalle
      final Uri urlGetProduct = Uri.parse("$httpUrl/Productos/GetProductById?id=${detalleVenta["idProducto"]}");
      final responseGetProudct = await http.get(
        urlGetProduct,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if(responseGetProudct.statusCode!=200){
        return false;
      }
      String body = utf8.decode(responseGetProudct.bodyBytes);
      final productoJson=jsonDecode(body);
      
      //Le restamos la cantidad del detalle(hacer un if productoJson["cantidad"]==0 si es necesario)
      productoJson["cantidad"]=productoJson["cantidad"]-detalleVenta["cantidad"];
      String productoJsonNew = jsonEncode(productoJson);
      //Y mandamos a actualizar el producto
      final Uri urlCantidadNew = Uri.parse("$httpUrl/Productos/UpdateProduct");
      final responseCantidadNew = await http.put(
        urlCantidadNew,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: productoJsonNew
      );
      if(responseCantidadNew.statusCode!=200){
        return false;
      }
    }
    
    ventaAAnular.estado=0;
    // Convertir la venta a JSON
    String ventaJson = jsonEncode(ventaAAnular.ventaToJson());
    final Uri urlAnularVenta = Uri.parse("$httpUrl/Ventums/UpdateVenta");
    final responseAnularVenta = await http.put(
      urlAnularVenta,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: ventaJson,
    );
    if(responseAnularVenta.statusCode!=200){
      return false;
    }
    return true;
  }catch(_){
    return false;
  }
}