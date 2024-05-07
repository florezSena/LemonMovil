import 'package:flutter/material.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/widgets/detalle_card.dart';
import 'package:provider/provider.dart';
class CarritoVenta extends StatefulWidget {
  const CarritoVenta({super.key});

  @override
  State<CarritoVenta> createState() => _CarritoVentaState();
}

class _CarritoVentaState extends State<CarritoVenta> {
  @override
  Widget build(BuildContext context) {
    List<DetallesVenta> productosAVender=context.watch<VentasProvider>().productosAVender;
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
                    Text("Productos a vender", style: TextStyle(fontSize: 24.0),),
                  ],
                )),
              Expanded(
                child: Builder(builder:(context) {
                  return ListView.builder(
                    itemCount: productosAVender.length,
                    itemBuilder: (BuildContext context, int index) {
                      DetallesVenta detalle = productosAVender[index];
                      return Container(
                      margin: index == productosAVender.length - 1 
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
          
                      child:DetalleCard(detalle: detalle,mostrarDelete: true,)
                      );
                    },
                  );
                },)
              )
            ],
          )
        ),
      ),
    );
  }
}