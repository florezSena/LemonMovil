import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/providers/productos_provider.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:lemonapp/widgets/product_venta_card.dart';
import 'package:provider/provider.dart';

class SearchProductoVenta extends SearchDelegate<Producto?>{
  int _deleteId=-1;
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
      future: getProductosVenta(query), 
      builder: (context,snapshot){
        final productos=snapshot.data??[];
        if(productos.isEmpty && query!=""){
          return const Center(child: Text("Producto no econtrado"));
        }else if(productos.isEmpty && query==""){
          return const Center(child: CircularProgressIndicator());
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
                  child: ProductVentaCard(producto:product,onProductSelected: close, )
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
      future: getProductosVenta(query), 
      builder: (context,snapshot){
        final productos=snapshot.data??[];
        if(productos.isEmpty && query!=""){
          return const Center(child: Text("Producto no econtrado"));
        }else if(productos.isEmpty && query==""){
          return const Center(child: CircularProgressIndicator());
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
                  child: ProductVentaCard(producto:product,onProductSelected: close, )
                );
              }
            
            ),
          ),
        );
      },
    );
  }
}

