import 'package:flutter/material.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/widgets/detalle_card.dart';

class FinalVenta extends StatelessWidget {
  const FinalVenta({super.key, required this.detallesVenta, required this.cliente});
  final List<DetallesVenta> detallesVenta;
  final Cliente? cliente;
  @override
  Widget build(BuildContext context){
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
              const Text("Ciente:", style: TextStyle(fontSize: 18),),
              TextFormField(
                textAlign: TextAlign.center,
                enabled: false,
                decoration: InputDecoration(
                  hintStyle:const TextStyle(color: Colors.black),
                  hintText: cliente==null?"":cliente!.nombreRazonSocial
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text("Detalles:", style: TextStyle(fontSize: 18),),
              Expanded(
                child: Builder(builder:(context) {
                  return ListView.builder(
                    itemCount: detallesVenta.length,
                    itemBuilder: (BuildContext context, int index) {
                      DetallesVenta detalle = detallesVenta[index];
                      return Container(
                      margin: index == detallesVenta.length - 1 
                      ? const EdgeInsets.only(bottom: 200.0,top:20)
                      : const EdgeInsets.only(top: 20),
                      padding:const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.5, 
                        ),
                        
                        borderRadius: BorderRadius.circular(5),
                      ),
          
                      child:DetalleCard(detalle: detalle,)
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