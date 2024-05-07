import 'package:flutter/material.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:provider/provider.dart';
class ProductVentaCard extends StatefulWidget {
  const ProductVentaCard({super.key, required this.producto, required this.onProductSelected});
  final Producto producto;
  final Function onProductSelected;
  @override
  State<ProductVentaCard> createState() => _ProductVentaCardState();
}

class _ProductVentaCardState extends State<ProductVentaCard> {
  @override
  Widget build(BuildContext context) {
    List<DetallesVenta> detalles=context.watch<VentasProvider>().productosAVender;
    List<int> idsDetalles = detalles.map((detalle) => detalle.idProducto).toList();
    Producto producto = widget.producto;
    String stringEstado=producto.estado==1?"Activo":"Inactivo";
    String precioFormateado= producto.costo.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');

    return ExpansionTile(
      trailing: Container(
        padding:const EdgeInsets.all(1),
        decoration: BoxDecoration(
          color:primaryColor,
          borderRadius: BorderRadius.circular(5),
          border:Border.all(color:Colors.transparent,width: 0)
        ),
        child: IconButton(
          onPressed: () {
            if (idsDetalles.contains(producto.idProducto)) {
              alertFinal(context, false, "Este producto ya está agregado");
            } else {
              widget.onProductSelected(context, producto);
            }
          },
          icon:const Icon(Icons.add, color: Colors.white,size: 30,),
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
          subtitle: SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text('#Producto: ${producto.idProducto}\nCantidad: ${producto.cantidad}\nCosto: \$$precioFormateado\nDescripción: ${producto.descripcion=="null"?"sin descripcion":producto.descripcion}\nEstado: $stringEstado',softWrap: true,)),
        ),
      ],
    );
  }
}

