import 'package:flutter/material.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/services/service_venta.dart';

class VisualizarVenta extends StatelessWidget {
  const VisualizarVenta({super.key, required this.venta, required this.nVenta});
  final Venta venta;
  final int nVenta;
  @override
  Widget build(BuildContext context) {
    Future <List<DetallesVenta>> detallesVenta=getDetalleVentas(venta.idVenta);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.only(top: 20.0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.monetization_on),
                    const Padding(padding: EdgeInsets.only(left: 5)),
                    Flexible(
                      child: Text(
                        "Venta: #$nVenta",
                        softWrap: true,
                        style: const TextStyle(
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
                  title: Text("Fecha ${venta.fecha}\nTotal: \$${venta.total}\nEstado: ${venta.estado==1?"Realizada":"Anulada"}\nCliente: ${venta.idClienteNavigation.nombreRazonSocial}"),
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
                      return SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child:Text("${snapshot.error}"),
                        ),
                      );
                    }else{
                      List<DetallesVenta> detallesVenta = snapshot.data!;
                      return ListView.builder(
                        itemCount: detallesVenta.length,
                        itemBuilder: (context, index) {
                          DetallesVenta detalleVenta = detallesVenta[index];
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
                              title: Text("Subtotal: \$${detalleVenta.subtotal}"),
                              subtitle: Text("#Producto:${detalleVenta.idProducto}\nProducto: ${detalleVenta.idProductoNavigation.nombre}\n(Kg) vendidos: ${detalleVenta.cantidad}\nPrecio (Kg): \$${detalleVenta.precioKilo}"),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: (){
          Navigator.pop(context);
        },
        foregroundColor: Colors.white,
        child:const Icon(Icons.arrow_back),
      ),
    );
  }
}