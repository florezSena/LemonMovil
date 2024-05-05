import 'package:flutter/material.dart';
class CarritoVenta extends StatefulWidget {
  const CarritoVenta({super.key});

  @override
  State<CarritoVenta> createState() => _CarritoVentaState();
}

class _CarritoVentaState extends State<CarritoVenta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Text("Productos a vender", style: TextStyle(fontSize: 24.0),),
                  ],
                )),
            ],
          )
        )
      ),
    );
  }
}