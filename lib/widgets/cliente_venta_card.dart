import 'package:flutter/material.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
class ClienteVentaCard extends StatefulWidget {
  const ClienteVentaCard({super.key, required this.cliente, required this.onClienteSelected});
  final Cliente cliente;
  final Function onClienteSelected;
  @override
  State<ClienteVentaCard> createState() => _ClienteVentaCardState();
}

class _ClienteVentaCardState extends State<ClienteVentaCard> {

  @override
  Widget build(BuildContext context) {
    Cliente cliente = widget.cliente;
    String stringEstado=cliente.estado==1?"Activo":"Inactivo";
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
            widget.onClienteSelected(context,cliente);
          },
          icon:const Icon(Icons.add, color: Colors.white,size: 30,),
        ),
      ),
      backgroundColor: Colors.transparent,
      tilePadding: const EdgeInsets.only(left: 0),
      title: Text(cliente.nombreRazonSocial),
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
          subtitle: SizedBox(width: MediaQuery.of(context).size.width * 0.6,child: Text('Documento: ${cliente.documento}\nCantidad: ${cliente.correo}\nCosto: ${cliente.telefono}\nEstado: $stringEstado',softWrap: true,)),
        ),
      ],
    );
  }
}

