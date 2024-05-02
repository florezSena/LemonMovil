import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lemonapp/providers/productos_provider.dart';
import 'package:lemonapp/widgets/product_card.dart';
import 'package:provider/provider.dart';

class SearchProducto extends SearchDelegate<Producto?>{
  int _deleteId=-1;
  Future<List<Producto>>  _getProductos(String nombreSearch) async {
    
    final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/GetProductByName?nombre=$nombreSearch");
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
    }else{
      throw Exception("Fallo la conexion a la api");
    }
  }
  @override
  String get searchFieldLabel=>'Buscar producto';
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    if(query==""){
      return [
      
        IconButton(onPressed: ()=>close(context,null), icon:const Icon(Icons.clear))

      ];
    }
    return [
      
      IconButton(onPressed: ()=>query="", icon:const Icon(Icons.clear))

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: ()=>close(context,null), 
      icon:const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _deleteId=context.watch<ProductosProvider>().productDeleteL;
    return FutureBuilder(
      future: _getProductos(query), 
      builder: (context,snapshot){
        final productos=snapshot.data??[];
        if(productos.isEmpty && query!=""){
          return const Center(child: Text("Producto no econtrado"));
        }else if(productos.isEmpty && query==""){
          return const Center(child: Text("Ingrese el nombre del producto a buscar"));
        }
        if(context.watch<ProductosProvider>().productDeleteL!=0){
          productos.removeWhere((element) => element.idProducto==context.watch<ProductosProvider>().productDeleteL);
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context,index){
                final product=productos[index];
                return Container(
                  margin: index == productos.length - 1 
                  ? const EdgeInsets.only(bottom: 130.0,top:20)
                  : const EdgeInsets.only(top: 20),
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5, 
                    ),
                    
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ProductCard(producto:product )
                );
              }
            
            ),
          ),
        );
      },
      );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _deleteId=context.watch<ProductosProvider>().productDeleteL;
    return FutureBuilder(
      future: _getProductos(query), 
      builder: (context,snapshot){
        final productos=snapshot.data??[];
        if(productos.isEmpty && query!=""){
          return const Center(child: Text("Producto no econtrado"));
        }else if(productos.isEmpty && query==""){
          return const Center(child: Text("Ingrese el nombre del producto a buscar"));
        }
        if(_deleteId!=0){
          productos.removeWhere((element) => element.idProducto==context.watch<ProductosProvider>().productDeleteL);
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context,index){
                final product=productos[index];
                return Container(
                  margin: index == productos.length - 1 
                  ? const EdgeInsets.only(bottom: 130.0,top:20)
                  : const EdgeInsets.only(top: 20),
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 0.5, 
                    ),
                    
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: ProductCard(producto:product )
                );
              }
            
            ),
          ),
        );
      },
    );
  }
}

