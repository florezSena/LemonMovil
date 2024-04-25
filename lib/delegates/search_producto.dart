import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchProducto extends SearchDelegate<Producto?>{
  Future<List<Producto>>  _getProductos(String nombreSearch) async {
    final Uri url = Uri.parse("https://47ff-2801-1ca-1-111-71b8-1625-d83a-c66f.ngrok-free.app/api/Productos/GetProductByName?nombre="+nombreSearch);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
      },
    );
    List<Producto> productos=[];

    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData=jsonDecode(body);

      for (var element in jsonData) {
        // print(element["nombre"]);
        productos.add(
          Producto(
            1, 
            element["nombre"].toString(), 
            double.parse(element["cantidad"].toString()), 
            double.parse(element["costo"].toString()), 
            element["descripcion"].toString(), 
            int.parse(element["estado"].toString())
            )
        );
      }
      if(productos.isEmpty){
        productos.add(
          Producto(
            1, 
            "El producto no existe", 
            0.0, 
            0.0, 
            null, 
            1
            )
        );
      }

      return productos;
    }else{
      throw Exception("Fallo la conexion a la api");
    }
  }

  @override
  String get searchFieldLabel=>'Buscar producto';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: ()=>query="", icon: Icon(Icons.clear))

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: ()=>close(context,null), 
      icon: Icon(Icons.arrow_back)
      );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: _getProductos(query), 
      builder: (context,snapshot){
        final productos=snapshot.data??[];
        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context,index){
            final product=productos[index];
            return ListTile(title: Text(product.nombre),);
          }

        );
      },
      );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: _getProductos(query), 
      builder: (context,snapshot){
        final productos=snapshot.data??[];
        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context,index){
            final product=productos[index];
            return _ProductItem(productoI: product, onProductSelected: close);
          }

        );
      },
      );
  
  }

}

class _ProductItem extends StatelessWidget{
  final Producto productoI;
  final Function onProductSelected;
  const _ProductItem({required this.productoI,
  required this.onProductSelected});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        onProductSelected(context,productoI);
      },
      child: ListTile(title: Text(productoI.nombre),),
    );
  }
}