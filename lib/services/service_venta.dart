import 'dart:convert';
import 'package:intl/intl.dart';
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
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
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
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
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
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
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
          'Authorization': 'Bearer ${await obtenerToken("Token")}',
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
          'Authorization': 'Bearer ${await obtenerToken("Token")}',
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
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
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

Future<List<Cliente>> getClientes(String nombre) async {
  List<Cliente> clientes=[];
  final Uri url = Uri.parse("$httpUrl/Clientes/GetClients");
  try{
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
      },
    );
    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData=jsonDecode(body);
      for (var element in jsonData) {
        String nombreRazonSocial = element['nombreRazonSocial'].toLowerCase();
        String nombreLower=nombre.toLowerCase();
        if (nombreRazonSocial.contains(nombreLower) && element["estado"]==1) {
          clientes.add(
            Cliente(
              element['idCliente'],
              element['tipoDocumento'],
              BigInt.parse(element['documento'].toString()),
              element['nombreRazonSocial'],
              element['correo'],
              element['telefono'],
              element['estado'],
            )
          );
        }
      }
      return clientes;
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

Future<List<Producto>> getProductosVenta(String nombre) async {
  List<Producto> productos=[];
  final Uri url = Uri.parse("$httpUrl/Productos/GetProduct");
  try{
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
      },
    );
    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData=jsonDecode(body);
      for (var element in jsonData) {
        String nombreAbuscar = element['nombre'].toLowerCase();
        String nombreLower=nombre.toLowerCase();
        if (nombreAbuscar.contains(nombreLower) && element["estado"]==1 && element["cantidad"]>0) {
          productos.add(
            Producto(
              int.parse(element["idProducto"].toString()), 
              element["nombre"].toString(), 
              double.parse(element["cantidad"].toString()), 
              double.parse(element["costo"].toString()), 
              element["descripcion"].toString(), 
              int.parse(element["estado"].toString())
            )
          );
        }
      }
      return productos;
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


Future<bool> realizarVenta(List<DetallesVenta> detalles,Cliente? cliente) async {
  double total=0;
  int ultimoIdVenta=0;
  for(DetallesVenta detalle in detalles){
    total+=detalle.subtotal;
  }
  total = double.parse(total.toStringAsFixed(2));

  final Uri url = Uri.parse("$httpUrl/Ventums/InsertVenta");
  try{
    Venta newVenta =Venta(0,cliente!.idCliente,DateTime.now(),total,1,cliente);
    String ventaString = jsonEncode(newVenta.ventaToJson());
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
        'Content-Type': 'application/json'
      },
      body: ventaString
    );

    if(response.statusCode==200){
      final Uri urlUltimaVenta = Uri.parse("$httpUrl/Ventums/GetVentas");
      final response = await http.get(
        urlUltimaVenta,
        headers: {
          'Authorization': 'Bearer ${await obtenerToken("Token")}',
        },
      );

      if(response.statusCode==200){
        String body = utf8.decode(response.bodyBytes);
        final jsonData=jsonDecode(body);
        if (jsonData is List && jsonData.isNotEmpty) {
          jsonData.sort((a, b) => b['idVenta'].compareTo(a['idVenta']));
          ultimoIdVenta = jsonData.first['idVenta'];
        }
      }else{
        return false;
      }
      
      final Uri urlDetalle = Uri.parse("$httpUrl/DetalleVentums/InsertDetalleVenta");
      for(DetallesVenta detalle in detalles){
        detalle.idVenta=ultimoIdVenta;
        String detalleString = jsonEncode(detalle.detallesVentaToJson());
        final responseDetalle = await http.post(
          urlDetalle,
          headers: {
            'Authorization': 'Bearer ${await obtenerToken("Token")}',
            'Content-Type': 'application/json'
          },
          body: detalleString
        );
        if(responseDetalle.statusCode==200){
          detalle.idProductoNavigation.cantidad-=detalle.cantidad;
          String productoJson = jsonEncode(detalle.idProductoNavigation.productoToJson());
          final Uri urlUpdateProduct = Uri.parse("$httpUrl/Productos/UpdateProduct");
          final responseUpdateProducto = await http.put(
            urlUpdateProduct,
            headers: {
              'Authorization': 'Bearer ${await obtenerToken("Token")}',
              'Content-Type': 'application/json'
            },
            body: productoJson
          );
          if(responseUpdateProducto.statusCode!=200){
            return false;
          }
        }else{
          return false;
        }
      }

      return true;
    }
    return false;
  }catch(error){
    throw Exception("Error de catch: $error");
  }
}
Future<List<Venta>> getVentasQuery(String query) async {
  List<Venta> ventas=[];
    final Uri url = Uri.parse("$httpUrl/Ventums/GetVentas");

  try{

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
      },
    );

    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData=jsonDecode(body);

      for (var element in jsonData) {
        // Cliente cliente=  Cliente.clienteFromJson(element['idClienteNavigation']);
        // if(cliente.nombreRazonSocial.toLowerCase().contains(query.toLowerCase())){
        DateTime fechaDeventa=      DateTime.parse(element['fecha']);
        String fechaFormateada=DateFormat('dd/MM/yyyy hh:mm a').format(fechaDeventa);
        if(fechaFormateada.contains(query)){
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
      }
      }
      ventas.sort((a, b) => b.fecha.compareTo(a.fecha));
      return ventas;
  }catch(error){
    throw Exception("Error de catch: $error");
  }
}


Future<Cliente> getClientePordefecto() async {
  Cliente cliente;
  final Uri url = Uri.parse("$httpUrl/Clientes/GetClientById?id=1");
  try{
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
      },
    );
    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData=jsonDecode(body);
      cliente=Cliente.clienteFromJson(jsonData);
      return cliente;
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