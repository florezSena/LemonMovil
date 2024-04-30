import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lemonapp/delegates/search_producto.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/products/add_product.dart';
import 'package:lemonapp/services/service_product.dart';


class PrdouctosIndex extends StatefulWidget {
  const PrdouctosIndex({super.key});

  @override
  State<PrdouctosIndex> createState() => _PrdouctosIndexState();
}

class _PrdouctosIndexState extends State<PrdouctosIndex> {
  late Future<List<Producto>> _listaProductos;
  bool _isRefreshing = false;
  bool _isAlertaCambiarEstado=false;

  
  @override
  void initState() {
    super.initState();
    _listaProductos=getProductos();
  }
  
  Future<void> _refresh() async {
    setState(() {
      _isRefreshing=true;
    });
    _listaProductos=getProductos();
    setState(() {
      _isRefreshing=false;
    });
  }
  @override
  Widget build(BuildContext context) {
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
                  child:const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        "Gestión de Productos",
                        style: TextStyle(
                          fontSize: 24.0,
                          
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
                          bool switchEstado= producto.estado==1 ? true : false;
                          String stringEstado=producto.estado==1 ? "Activo" : "Inactivo";
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
        
                            child: ExpansionTile(
                              trailing: Switch(
                                
                                inactiveTrackColor: Colors.white,
                                inactiveThumbColor: Colors.grey.shade600,
                                value: switchEstado,
                                onChanged: (value) => setState(() {
                                  
                                  _alertaCambiarEstado(context,producto).then((value) {
                                    if(value){
                                      if(_isAlertaCambiarEstado==false){
                                        setState(() {
                                          _isAlertaCambiarEstado=true;
                                        });
                                        ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                          const SnackBar(
                                            content: Text('Estado cambiado exitosamente',style: TextStyle(color:Colors.white),),
                                            duration: Duration(seconds: 3),
                                            backgroundColor: primaryColor,
                                          ),
                                        ).closed.then((value) {
                                          setState(() {
                                            _isAlertaCambiarEstado=false;
                                          });
                                        });
                                      }
                                      setState(() {
                                        switchEstado = !switchEstado;
                                      });
                                    }else{
                                      ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        const SnackBar(
                                          content: Text('Error al cambiar el estado',style: TextStyle(color:Colors.white),),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.black,
                                        ),
                                      );
                                    }
                                  },);
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
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      
                                      Text('#Producto: ${producto.idProducto}\nCantidad: ${producto.cantidad}\nCosto: ${producto.precio}\nDescripcion: ${producto.descripcion!.length > 30 ? producto.descripcion!.substring(0, 25) + '\n' + producto.descripcion!.substring(25) : producto.descripcion}\nEstado: $stringEstado'),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 9),
                                        child: Column(
                                          
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color:producto.estado==1?primaryColor:Colors.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border:producto.estado==1?Border.all(color:Colors.transparent,width: 2): Border.all(color:Colors.grey.shade600,width: 2)
                                                ),
                                                child: Icon(Icons.edit, color: producto.estado==1?Colors.white:Colors.grey.shade600,size: 30, ))
                                            ),
                                            Padding(padding: EdgeInsets.only(bottom: 17)),
                                            GestureDetector(
                                              onTap: ()async {
                                                await _alertaEliminarProducto(context, producto).then((value){
                                                  if(value){
                                                    ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Producto eliminado exitosamente',style: TextStyle(color:Colors.white),),
                                                        duration: Duration(seconds: 3),
                                                        backgroundColor: primaryColor,
                                                      ),
                                                    );
                                                    setState(() {
                                                      productos.removeAt(index);
                                                    });
                                                  }else{
                                                    ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Un producto asociado no puede ser eliminado',style: TextStyle(color:Colors.white),),
                                                        duration: Duration(seconds: 3),
                                                        backgroundColor: Colors.black,
                                                      ),
                                                    );
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color:producto.estado==1?primaryColor:Colors.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border:producto.estado==1?Border.all(color:Colors.transparent,width: 2): Border.all(color:Colors.grey.shade600,width: 2)
                                                ),
                                                child: Icon(Icons.delete, color: producto.estado==1?Colors.white:Colors.grey.shade600,size: 30,)
                                                )
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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










Future <bool> _alertaCambiarEstado(BuildContext context,Producto productoACambiar) async{
  Completer<bool> completer = Completer<bool>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Estas seguro de cambiar el estado?'),
        actions: [
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(Colors.black)
            ),
            child: const Text('Cancelar',style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(primaryColor)
            ),
            child: const Text('Aceptar',style: TextStyle(color: Colors.white),),
            onPressed: () async{
              Navigator.pop(context);
              await cambiarEstado(productoACambiar).then((response){
                completer.complete(response);
              });
            },
          ),
        ],
      );
    },
  );
  return completer.future;
}



Future<bool> _alertaEliminarProducto(BuildContext context,Producto productoAEliminar) async{
  Completer<bool> completer = Completer<bool>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Estas seguro de eliminar el producto?'),
        actions: [
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(Colors.black)
            ),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(primaryColor)
            ),
            child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
            onPressed: () async{
              Navigator.pop(context);
              await eliminarProducto(productoAEliminar).then((response){
                completer.complete(response);
              });
            },
          ),
        ],
      );
    },
  );
  return completer.future;
}

