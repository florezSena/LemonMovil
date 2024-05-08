import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/widgets/detalle_card.dart';
import 'package:provider/provider.dart';

class FinalVenta extends StatelessWidget {
  const FinalVenta({super.key, required this.detallesVenta, required this.cliente});
  final List<DetallesVenta> detallesVenta;
  final Cliente? cliente;
  @override
  Widget build(BuildContext context){
    String total=context.watch<VentasProvider>().totalVentaGet.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]}.');
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.64,
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.only(top: 20.0),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text("Informacion de la venta", style: TextStyle(fontSize: 24.0),),
                  ],
                )
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle:const TextStyle(color: Colors.black),
                  hintText:"Fecha: ${DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.now())}"

                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle:const TextStyle(color: Colors.black),
                  hintText: "Cliente: ${cliente==null?"":cliente!.nombreRazonSocial}"
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle:const TextStyle(color: Colors.black),
                  hintText: "Total: \$$total"
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text("Detalles de la venta:", style: TextStyle(fontSize: 18),),
              Expanded(
                child: Builder(builder:(context) {
                  return ListView.builder(
                    itemCount: detallesVenta.length,
                    itemBuilder: (BuildContext context, int index) {
                      DetallesVenta detalle = detallesVenta[index];
                      return Container(
                      margin: const EdgeInsets.only(top: 20),
                      padding:const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5, 
                        ),
                        
                        borderRadius: BorderRadius.circular(5),
                      ),
          
                      child:DetalleCard(detalle: detalle,mostrarDelete: false,)
                      );
                    },
                  );
                },)
              )
            ],
          ),
        ),
      ),
    );
  }
}