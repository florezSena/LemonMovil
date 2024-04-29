import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchProducto extends SearchDelegate<Producto?>{
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
            return _ProductItem(productoI: product);
          }

        );
      },
      );
  
  }

}

class _ProductItem extends StatefulWidget{
  final Producto productoI;
  const _ProductItem({required this.productoI});

  @override
  State<_ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<_ProductItem> {
  
  @override
  
  Widget build(BuildContext context){
    Producto producto = widget.productoI;
    return ExpansionTile(
                            trailing: Switch(
                              value: producto.estado==1?true:false,
                              onChanged: (value) => setState(() {
                                
                              }),
                            ),
                            backgroundColor: Colors.transparent,
                            tilePadding: const EdgeInsets.only(left: 0),
                            title: Text(producto.nombre),
                            subtitle: producto.cantidad<1?const Text("Producto con poco stock",style: TextStyle(color: Colors.grey),):null,
                            shape: RoundedRectangleBorder( 
                              side:const BorderSide( 
                                color: Colors.transparent, 
                                width: 0,
                              ),
                              borderRadius: BorderRadius.circular(5.0), // Redondeo de las esquinas
                            ),
                            children: [
                              
                              ListTile(
                                contentPadding:const EdgeInsets.all(0),
                                subtitle: Text('#Producto: ${producto.idProducto}\nCantidad: ${producto.cantidad}\nCosto: ${producto.precio}\nDescripcion: ${producto.descripcion}\nEstado: '),
                              ),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child:const Icon(Icons.edit,color: Colors.white,size: 30,)
                                  ),
                                  ElevatedButton(
                                    onPressed: ()async {
                                      
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      shadowColor: Colors.transparent, 
                                      // minimumSize: Size(12,12)
                                    ),
                                    child:const Icon(Icons.delete,color: Colors.white,size: 30,)
                                  ),
                                ],
                              )
                            ],
                          );
  }
}