import 'dart:convert';
import 'package:lemonapp/models/producto.dart';
import 'package:http/http.dart' as http;

Future<List<Producto>> getProductos() async {
  List<Producto> productos=[];

  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/GetProduct");
  try{
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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
      print("salir del aplicativo");
      throw Exception("Sin permisos");

    }else{
      print("Error en la peticion");

      throw Exception("Error en la peticion ${response.statusCode}");
    }
  }catch(error){
            print("Error de catch");

    throw Exception("Error de catch: $error");

  }
}



Future<bool>  eliminarProducto(Producto productoAEliminar) async {
  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/DeleteProduct/${productoAEliminar.idProducto}");
  try{
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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
  String productoJson = jsonEncode(productoACambiar);
  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/UpdateProduct");
  try{
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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
  String productoJson = jsonEncode(producto);
  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/InsertProduct");
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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
  String productoJson = jsonEncode(productoEdit);
  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/UpdateProduct");
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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
  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/GetProductByName?nombre=$nombreDupli");
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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
  final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/GetProductByName?nombre=$nombreDupli");
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
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