import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/ventas/visualizar_venta.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:lemonapp/widgets/retroceder.dart';
class VentaCard extends StatefulWidget {
  const VentaCard({super.key, required this.venta});
  final Venta venta;
  @override
  State<VentaCard> createState() => _VentaCardCardState();
}

class _VentaCardCardState extends State<VentaCard> {

  @override
  Widget build(BuildContext context) {
    Venta venta = widget.venta;
    String stringEstado=venta.estado==1?"Realizada":"Anulada";

    return ExpansionTile(
      trailing: TextButton(
        onPressed: () {
          if(venta.estado==1){
            _alertaAnularVenta(context,venta);
          }
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
              Flexible(child: SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text('#Cliente: ${venta.idClienteNavigation.documento}\nTotal de la venta: ${venta.total}\nEstado: $stringEstado\nCliente: ${venta.idClienteNavigation.nombreRazonSocial}',softWrap: true,))),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Column(
                  
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(page: VisualizarVenta(venta: venta)),
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


void _alertaAnularVenta(BuildContext context,Venta ventaAAnular) {
  int x=0;
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
              x=1;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((value) async{
    if(x==1){
      await anularVenta(ventaAAnular).then((response){
        if(response){
          alertFinal(context, true, 'Venta anulada');
        }else{
          alertFinal(context, false, 'Error al anular la venta');
        }
      });
    }
  });
}

