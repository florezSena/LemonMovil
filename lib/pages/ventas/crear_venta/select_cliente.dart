import 'package:flutter/material.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:provider/provider.dart';
class SelecetCliente extends StatefulWidget {
  const SelecetCliente({super.key});

  @override
  State<SelecetCliente> createState() => _SelecetClienteState();
}

class _SelecetClienteState extends State<SelecetCliente> {
  @override
  Widget build(BuildContext context) {
    Cliente? clienteVenta = context.watch<VentasProvider>().clienteGet;

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
                child:const  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text("Elegir cliente", style: TextStyle(fontSize: 24.0),),
                  ],
                )),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      const Text("Documento" ,style: TextStyle(fontSize: 20),),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: clienteVenta==null?"Selecciona un cliente":clienteVenta.documento.toString(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      const Text("Nombre o razon social" ,style: TextStyle(fontSize: 20),),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: clienteVenta==null?"Selecciona un cliente":clienteVenta.nombreRazonSocial.toString(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      const Text("Correo" ,style: TextStyle(fontSize: 20),),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: clienteVenta==null?"Selecciona un cliente":clienteVenta.correo.toString(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      const Text("Telefono" ,style: TextStyle(fontSize: 20),),
                      TextFormField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: clienteVenta==null?"Selecciona un cliente":clienteVenta.telefono.toString(),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}