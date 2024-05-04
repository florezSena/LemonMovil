import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/ventas/visualizar_venta.dart';
class VentaCard extends StatefulWidget {
  const VentaCard({super.key, required this.venta, required this.nVenta});
  final int nVenta;
  final Venta venta;
  @override
  State<VentaCard> createState() => _VentaCardCardState();
}

class _VentaCardCardState extends State<VentaCard> {

  @override
  Widget build(BuildContext context) {
    Venta venta = widget.venta;
    int nVenta=widget.nVenta;
    String stringEstado=venta.estado==1?"Realizada":"Anulada";

    return ExpansionTile(
      trailing: TextButton(
        onPressed: () {
          // Acción a realizar cuando se presiona el botón
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(const Size(75, 20)),
          backgroundColor: MaterialStateProperty.all<Color>(venta.estado==1?Colors.transparent:Colors.grey.shade600), // Color de fondo
          side: MaterialStateProperty.all<BorderSide>(BorderSide(color: Colors.grey.shade600)), // Borde negro
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Radio del borde
            ),
          ),
        ),
        child: Text(
          venta.estado == 1 ? "Anular" : "Anulada",
          style: TextStyle(color: venta.estado==1?Colors.black:Colors.white), // Color del texto
        ),
      ),
      backgroundColor: Colors.transparent,
      tilePadding: const EdgeInsets.only(left: 0),
      title: Text(DateFormat('dd/MM/yyyy\nHH:mm').format(venta.fecha),),
      subtitle: venta.estado==0?const Text("Esta venta ha sido anulada",style: TextStyle(color: Colors.grey),):null,
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
              Flexible(child: SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text('#Venta: $nVenta\nTotal de la venta: ${venta.total}\nEstado: $stringEstado\nCliente: ${venta.idClienteNavigation.nombreRazonSocial}',softWrap: true,))),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Column(
                  
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  VisualizarVenta(venta: venta,nVenta: nVenta,)),
                        );
                      },
                      child: Container(
                        padding:const EdgeInsets.only(top: 3,bottom: 3,left: 20,right: 20),
                        decoration: BoxDecoration(
                          
                          color:Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(5),
                          border:venta.estado==1?Border.all(color:Colors.transparent,width: 2): Border.all(color:Colors.grey.shade600,width: 2)
                        ),
                        child:const Icon(Icons.remove_red_eye, color: Colors.white,size: 30,)
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
