import 'dart:convert';
import 'package:lemonapp/models/producto.dart';
import 'package:http/http.dart' as http;
import 'package:lemonapp/services/config.dart';



Future<List<Producto>> getProductos() async {
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
        // print(element["nombre"]);
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
      return productos;
    }else if(response.statusCode==403){
      //Salir del aplicativo
      throw Exception("Sin permisos");

    }else{
      throw Exception("Error en la peticion ${response.statusCode}");
    }
  }catch(error){
    throw Exception(error);
  }
}



Future<bool>  eliminarProducto(Producto productoAEliminar) async {
  final Uri url = Uri.parse("$httpUrl/Productos/DeleteProduct/${productoAEliminar.idProducto}");
  try{
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
        'Content-Type': 'application/json'
      },
    );
    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
  }catch(_){
    return false;
  }
}



Future<bool>  cambiarEstado(Producto productoACambiar) async {
  productoACambiar.estado=productoACambiar.estado==1?0:1;
  // Convertir el objeto a JSON
  String productoJson = jsonEncode(productoACambiar.productoToJson());
  final Uri url = Uri.parse("$httpUrl/Productos/UpdateProduct");
  try{
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ${await obtenerToken("Token")}',
        'Content-Type': 'application/json'
      },
      body: productoJson,
    );
    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
  }catch(_){
    return false;
  }
}


Future<bool>  postProductos(String name,String? descripcion) async {
  
  Producto producto = Producto(
    0,
    name,
    0,
    0,
    descripcion==""?null:descripcion,
    1,
  );
  // Convertir el objeto a JSON
  String productoJson = jsonEncode(producto.productoToJson());
  final Uri url = Uri.parse("$httpUrl/Productos/InsertProduct");
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer ${await obtenerToken("Token")}',
      'Content-Type': 'application/json'
    },
    body: productoJson,
  );

  

  if(response.statusCode==200){
    return true;
  }else{
    return false;
  }
}

Future<bool>  putProduct(Producto productoEdit) async {
  String productoJson = jsonEncode(productoEdit.productoToJson());
  final Uri url = Uri.parse("$httpUrl/Productos/UpdateProduct");
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer ${await obtenerToken("Token")}',
      'Content-Type': 'application/json'
    },
    body: productoJson
  );
  

  if(response.statusCode==200){
    return true;
  }else{
    return false;
  }

}

Future <bool> duplicateName(String name) async {
  String nombreDupli= name;
  final Uri url = Uri.parse("$httpUrl/Productos/GetProductByName?nombre=$nombreDupli");
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer ${await obtenerToken("Token")}',
    },
  );
  bool duplicated=false;

  if(response.statusCode==200){
    String body = utf8.decode(response.bodyBytes);

    final jsonData=jsonDecode(body);

    for (var element in jsonData) {
      
      if(nombreDupli.toLowerCase()==element["nombre"].toString().toLowerCase()){
        duplicated=true;
      }
          
    }
    
    return duplicated;
    
  }else{
    throw Exception("Fallo la conexion a la api");
  }
}

Future <bool> duplicateNameUpdate(Producto product) async {
  String nombreDupli= product.nombre;
  final Uri url = Uri.parse("$httpUrl/Productos/GetProductByName?nombre=$nombreDupli");
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer ${await obtenerToken("Token")}',
    },
  );
  bool duplicated=false;

  if(response.statusCode==200){
    String body = utf8.decode(response.bodyBytes);

    final jsonData=jsonDecode(body);

    for (var element in jsonData) {
      
      if(nombreDupli.toLowerCase()==element["nombre"].toString().toLowerCase() && product.idProducto!=element["idProducto"].toInt()){
        duplicated=true;
      }
          
    }
    
    return duplicated;
    
  }else{
    throw Exception("Fallo la conexion a la api");
  }
}