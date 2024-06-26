import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/products/edit_product.dart';
import 'package:lemonapp/providers/metodos_provider.dart';
import 'package:lemonapp/providers/productos_provider.dart';
import 'package:lemonapp/services/service_product.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:lemonapp/widgets/retroceder.dart';
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
    bool isMetodo=context.watch<MetodosProvider>().isMetodoExecuteGet;

    String precioFormateado= producto.costo.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');

    return ExpansionTile(
      trailing: Switch(
        
        inactiveTrackColor: Colors.white,
        inactiveThumbColor: Colors.grey.shade600,
        value: producto.estado==1,
        onChanged: (value) {

          if(isMetodo==false){
            context.read<MetodosProvider>().metodoExecuting();
            _alertaCambiarEstado(context, producto).then((value) {
              if(value==0){
                setState(() {
                  producto.estado=producto.estado==1?0:1;
                });
              }
            });
          }

        }
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
              
              Flexible(child: SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text('#Producto: ${producto.idProducto}\nCantidad: ${producto.cantidad}\nCosto: \$$precioFormateado\nDescripción: ${producto.descripcion=="null"?"sin descripción":producto.descripcion}\nEstado: $stringEstado',softWrap: true,))),
              Padding(
                padding: const EdgeInsets.only(right: 9),
                child: Column(
                  
                  children: [
                    GestureDetector(
                      onTap: () {
                        if(producto.estado==1){
                          Navigator.push(
                            context,
                            SlidePageRoute(page: EditProduct(produtoSelect: producto,)),
                          );
                        }
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
                      onTap: () {
                        if(producto.estado==1){
                          if(!isMetodo){
                            _alertaEliminarProducto(context, producto);
                          }
                        }
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









  Future<int> _alertaCambiarEstado(BuildContext context,Producto productoACambiar) async{
    int x =0;
    Completer<int> completer = Completer<int>();
    
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // barrierDismissible: false, para que no pueda darle a cualquier lado
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
                x=1;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    ).then(
    (value) async {
      if(x==1){
        alertaCargando(context);
        await cambiarEstado(productoACambiar).then((response){
          Navigator.pop(context);
          context.read<MetodosProvider>().metodoExecuted();

          context.read<ProductosProvider>().updateProductList(productoACambiar);
          
          if(response){
            completer.complete(1);
            return alertFinal(context, response, "Estado actualizado");
          }else{
             completer.complete(0);

            return alertFinal(context, response, "Estado no actualizado");
          }
        });
      }else{
          context.read<MetodosProvider>().metodoExecuted();
      }
    }
  );
  return completer.future;
}




void _alertaEliminarProducto(BuildContext context,Producto productoAEliminar) {
  int x=0;
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
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
              x=1;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((value) async{
    if(x==1){
      alertaCargando(context);
      await eliminarProducto(productoAEliminar).then((response){
        Navigator.pop(context);
        context.read<MetodosProvider>().metodoExecuted();
        if(response){
          
          context.read<ProductosProvider>().deleteProducttList(productoAEliminar.idProducto);
          alertFinal(context, true, 'Producto eliminado');
        }else{
          alertFinal(context, false, 'Este producto no se puede eliminar');
        }
      });
    }
  });
  
}






