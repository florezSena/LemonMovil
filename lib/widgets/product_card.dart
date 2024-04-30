import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';

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
    String descripcionString= producto.descripcion==null?"Producto sin descripcion":"${producto.descripcion}";


    return ExpansionTile(
      trailing: GestureDetector(
        onTap: () {
        
        },
        child: Container(
                                                padding: EdgeInsets.all(5),

          decoration: BoxDecoration(
                                                  color:producto.estado==1?primaryColor:Colors.white,
                                                  borderRadius: BorderRadius.circular(5),
                                                  border:producto.estado==1?Border.all(color:Colors.transparent,width: 2): Border.all(color:Colors.grey.shade600,width: 2)
                                                ),
          child: const Icon(Icons.search_sharp,size: 30,)
        ),
        
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
          subtitle: Text('#Producto: ${producto.idProducto}\nCantidad: ${producto.cantidad}\nCosto: ${producto.precio}\nDescripcion: ${descripcionString.length > 30 ? descripcionString.substring(0, 25) + '\n' + descripcionString.substring(25) : descripcionString}\nEstado: $stringEstado'),
        ),
      ],
    );
  }
}
























