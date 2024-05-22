import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';

class VisualizarVenta extends StatefulWidget {
  const VisualizarVenta({super.key, required this.venta});
  final Venta venta;

  @override
  State<VisualizarVenta> createState() => _VisualizarVentaState();
}

class _VisualizarVentaState extends State<VisualizarVenta> {
  bool isChanged=false;
  @override
  Widget build(BuildContext context) {
    String totalFormateado = widget.venta.total.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');

    Future <List<DetallesVenta>> detallesVenta=getDetalleVentas(widget.venta.idVenta);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.only(top: 20.0),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.monetization_on),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Flexible(
                      child: Text(
                        "Informacion de la Venta",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:const EdgeInsets.only(top: 20.0,bottom: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5, 
                  ),
                  
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: Text("Fecha ${DateFormat('dd/MM/yyyy\nhh:mm a').format(widget.venta.fecha)}\nCliente: ${widget.venta.idClienteNavigation.nombreRazonSocial}\nIdentificación: ${widget.venta.idClienteNavigation.documento}\nEstado: ${widget.venta.estado==1?"Realizada":"Anulada"}"),
                  subtitle: Text("Total: \$$totalFormateado", style: const TextStyle(color: Colors.black, fontSize: 20),),
                ),
              ),
              Container(
                margin:const EdgeInsets.only(top: 20.0,bottom: 20.0),
                child: const Text("Detalles de la venta", style: TextStyle(fontSize: 25),),
              ),
              Expanded(
                child: FutureBuilder<List<DetallesVenta>>(
                  future: detallesVenta,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                      child: CircularProgressIndicator(),
                    );
                    } else if (snapshot.hasError) {
                      if (snapshot.error is Exception) {
                        // Acceder al mensaje de la Exception
                        String errorMessage = (snapshot.error as Exception).toString();
                        if(errorMessage=="Exception: Exception: Sin permisos"){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            errorSesion(context, "Su usuario se ha actualizado vuelva a iniciar sesion");
                          });
                          return const Text("Error de sesion");
                        }else{
                          return Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: const Card(
                              child: Padding(
                                padding:EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(Icons.error, color: Colors.black, size: 50),
                                    Padding(padding: EdgeInsets.only(top: 15)),
                                    Text('No hay conexión a Internet', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      }else{
                        return Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: const Card(
                            child: Padding(
                              padding:EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(Icons.error, color: Colors.black, size: 50),
                                  Padding(padding: EdgeInsets.only(top: 15)),
                                  Text('Error sin controlar', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }else{
                      List<DetallesVenta> detallesVenta = snapshot.data!;
                      return ListView.builder(
                        itemCount: detallesVenta.length,
                        itemBuilder: (context, index) {
                          DetallesVenta detalleVenta = detallesVenta[index];
                          String subtotalFormateado = detalleVenta.subtotal.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
                          String precioFormateado = detalleVenta.precioKilo.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');


                          return Container(
                            margin: index == detallesVenta.length - 1 
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
        
                            child: ListTile(
                              title: Text("Producto: ${detalleVenta.idProductoNavigation.nombre}"),
                              subtitle: Text("(Kg) vendidos: ${detalleVenta.cantidad}\nPrecio (Kg): \$$precioFormateado\nSubtotal: \$$subtotalFormateado"),
                            )
                          );
                        },
                      );
                    }
                  },
                )
              )
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                if(widget.venta.estado==1){
                  alertaAnularVenta(context,widget.venta).then((value){
                    if(value){
                      setState(() {
                        widget.venta.estado=0;
                        isChanged=true;
                        //Implementar para que al devolver aparezca anulada
                      });
                    }
                  });
                }
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(const Size(75, 48)),
                backgroundColor: MaterialStateProperty.all<Color>(widget.venta.estado==1?primaryColor:Colors.grey.shade600), // Color de fondo
                side: MaterialStateProperty.all<BorderSide>(BorderSide(color:widget.venta.estado==1?primaryColor: Colors.grey.shade600)), // Borde negro
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // Radio del borde
                  ),
                ),
              ),
              child: Text(
                widget.venta.estado == 1 ? "Anular" : "Anulada",
                style:const TextStyle(color:Colors.white), // Color del texto
              ),
            ),
            IconButton(
              onPressed: (){
                Navigator.pop(context,isChanged);
              },
              icon:Container(
                padding:const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:widget.venta.estado==1?primaryColor:Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(10),
                  border:widget.venta.estado==1?Border.all(color:Colors.transparent,width: 2): Border.all(color:Colors.grey.shade600,width: 2)
                ),
                child: const Icon(Icons.arrow_back,size: 30, color: Colors.white,)
              ),
            ),
          ],
        ),
      ),
    );
  }
}