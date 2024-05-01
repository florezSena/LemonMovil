import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemonapp/delegates/search_producto.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/products/add_product.dart';
import 'package:lemonapp/providers/productos_provider.dart';
import 'package:lemonapp/providers/metodos_provider.dart';
import 'package:lemonapp/services/service_product.dart';
import 'package:lemonapp/widgets/product_card.dart';
import 'package:provider/provider.dart';


class PrdouctosIndex extends StatefulWidget {
  const PrdouctosIndex({super.key});

  @override
  State<PrdouctosIndex> createState() => _PrdouctosIndexState();
}

class _PrdouctosIndexState extends State<PrdouctosIndex> {
  late Future<List<Producto>> _listaProductos;
  bool _isRefreshing = false;
  bool _isMetodo=false;
  
  @override
  void initState() {
    super.initState();
    _listaProductos=getProductos();
  }
  
  Future<void> _refresh() async {

    if(!_isMetodo){
      setState(() {
        _isRefreshing=true;
      });
      _listaProductos=getProductos();
      setState(() {
        _isRefreshing=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    _isMetodo=context.watch<MetodosProvider>().isMetodoExecuteGet;

    if(context.watch<ProductosProvider>().resetListP&&_isMetodo==false){
      _listaProductos=getProductos();
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child:Center(
          child: 
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // 80% del ancho
            child: Column(
              children: [
                Container(
                  margin:const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Flexible(
                        child: Text(
                          "Gestión de Productos ${_isMetodo}",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 24.0,
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showSearch(context: context, delegate: SearchProducto()).then((value){
                      if(value!=null){
                        //en value hay un dato de tipo Producto
                      }
                    });
                  },
                  child: Container(
                  
                    margin:const EdgeInsets.only(top: 20.0,bottom: 5.0),
                    decoration: BoxDecoration( // Para el borde redondeado
                      borderRadius: BorderRadius.circular(5.0), 
                      border: Border.all(color: Colors.grey, width: 1.0)
                    ),
                    child:const ListTile( // ListTile dentro del Container
                      title: Text("Buscar producto"), 
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 10),
                      // Considera agregar íconos (leading, trailing) o padding si lo deseas 
                    ), 
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Producto>>(
                  future: _listaProductos,
                  
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || _isRefreshing==true) {
                      return const Center(
                      child: CircularProgressIndicator(),
                    );
                    } else if (snapshot.hasError) {
                      return SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Text("${snapshot.error}"),
                        ),
                      );
                    }else {
                      List<Producto> productos = snapshot.data!;
                      return ListView.builder(
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          Producto producto = productos[index];
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
        
                            child: ProductCard(producto: producto)
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProduct()),
          ).then((value) {
            if(value!=null){
              setState(() {
                _refresh();
              });
            }
          });
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      
    );
  }
}


