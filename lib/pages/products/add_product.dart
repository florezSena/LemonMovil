import 'package:flutter/material.dart';
import 'package:lemonapp/main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lemonapp/models/producto.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  TextEditingController nameController=TextEditingController(text: "");
  
  Future<void>  _postProductos() async {
    Producto producto = Producto(
      0,
      nameController.text,
      0,
      0,
      null,
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
      print("Producto creado exitosamente");
    }else{
      throw Exception("Fallo la conexion a la api");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('agregar un producto'),
      ),
      body: Column(
        children: [
           TextField(
            controller: nameController,
            decoration:const InputDecoration(
              hintText: 'Nombre producto'
            ),
          ),
          ElevatedButton(onPressed: ()=>{
            print(nameController.text),
            _postProductos(),
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            )
          }, child:const Text('Guardar'))
        ],
      ),
    );
  }
}