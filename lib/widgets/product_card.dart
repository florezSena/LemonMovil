import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/providers/alertas_provider.dart';
import 'package:lemonapp/providers/metodos_provider.dart';
import 'package:lemonapp/services/service_product.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.producto});
  final Producto producto;
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    Producto producto = widget.producto;
    String stringEstado=producto.estado==1?"Activo":"Inactivo";
    bool isAlert=context.watch<AlertsProvider>().isAlertExecuteGet;
    bool isMetodo=context.watch<MetodosProvider>().isMetodoExecuteGet;
    return ExpansionTile(
      trailing: Switch(
        
        inactiveTrackColor: Colors.white,
        inactiveThumbColor: Colors.grey.shade600,
        value: producto.estado==1,
        onChanged: (value) async {
          if(!isMetodo){
            context.read<MetodosProvider>().metodoExecuting();
            await _alertaCambiarEstado(context,producto).then((value) {
              context.read<MetodosProvider>().metodoExecuted();

              if(isAlert==false){
                                    context.read<AlertsProvider>().alertExecuting();

                if(value==1){
                  ScaffoldMessenger.of(context)
                  .showSnackBar(
                    const SnackBar(
                      content: Text('Estado cambiado exitosamente',style: TextStyle(color:Colors.white),),
                      duration: Duration(seconds: 3),
                      backgroundColor: primaryColor,
                    ),
                  ).closed.then((value){
                    context.read<AlertsProvider>().alertExecuted();
                  });
                }else if(value==2){
                  ScaffoldMessenger.of(context)
                  .showSnackBar(
                    const SnackBar(
                      content: Text('Error al cambiar el estado',style: TextStyle(color:Colors.white),),
                      duration: Duration(seconds: 3),
                      backgroundColor: Colors.black,
                    ),
                  );
                }else{

                }
              }
            },);
            
          }
        },
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
              
              Flexible(child: SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text('#Producto: ${producto.idProducto}\nCantidad: ${producto.cantidad}\nCosto: ${producto.precio}\nDescripcion: ${producto.descripcion}\nEstado: $stringEstado',softWrap: true,))),
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: Column(
                  
                  children: [
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Container(
                        padding:const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color:producto.estado==1?primaryColor:Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border:producto.estado==1?Border.all(color:Colors.transparent,width: 2): Border.all(color:Colors.grey.shade600,width: 2)
                        ),
                        child: Icon(Icons.edit, color: producto.estado==1?Colors.white:Colors.grey.shade600,size: 30, ))
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 17)),
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
                        padding:const EdgeInsets.all(5),
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
      );
  }
}









Future <int> _alertaCambiarEstado(BuildContext context,Producto productoACambiar) async{
  Completer<int> completer = Completer<int>();
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
              completer.complete(0);
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
                completer.complete(response==true?1:2);
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






