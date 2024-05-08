import 'package:flutter/material.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:provider/provider.dart';

class DetalleCard extends StatefulWidget {
  const DetalleCard({super.key, required this.detalle, required this.mostrarDelete});
  final DetallesVenta detalle;
  final bool mostrarDelete;

  @override
  State<DetalleCard> createState() => _DetalleCardState();
}

class _DetalleCardState extends State<DetalleCard> {
  @override
  Widget build(BuildContext context) {
    DetallesVenta detalle = widget.detalle;
    bool isMostrarDelete=widget.mostrarDelete;
    String precioFormateado = detalle.precioKilo.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
    String subtotalFormateado = detalle.subtotal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');

    
    return ExpansionTile(
      trailing:isMostrarDelete? IconButton(
        onPressed:(){
          // showModalBottomSheet(
          //   context: context, 
          //   builder:(context) {
          //     return AlertDialog(
          //       title: Text("Confirmar eliminar"),
          //     );
          //   },
          // );
          context.read<VentasProvider>().deleteProductCarrito(detalle);
        },
        icon: const Icon(Icons.delete,color: Colors.black,),
      ):Text("Subtotal: $subtotalFormateado",style: TextStyle(fontSize: 15),),
      backgroundColor: Colors.transparent,
      tilePadding: const EdgeInsets.only(left: 0),
      title: Text(detalle.idProductoNavigation.nombre),
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
          subtitle: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text('(Kg) a vender: ${detalle.cantidad}\nCosto (kg): \$$precioFormateado\nSubtotal: \$$subtotalFormateado')
          ),
        ),
      ],
    );
  }
}