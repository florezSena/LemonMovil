import 'package:flutter/material.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:lemonapp/widgets/venta_card.dart'; //Para formaterar la fecha a dipo hora:minuto
class VentasIndex extends StatefulWidget {
  const VentasIndex({super.key});

  @override
  State<VentasIndex> createState() => _VentasIndexState();
}

class _VentasIndexState extends State<VentasIndex> {
  late Future<List<Venta>> _listaVentas;
  @override
  void initState() {
    super.initState();
    _listaVentas=getVentas();
  }
  Future<void> _refresh() async {
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child:Center(
          child: 
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9, // 80% del ancho
            child: Column(
              children: [
                Container(
                  margin:const EdgeInsets.only(top: 20.0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.monetization_on),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Flexible(
                        child: Text(
                          "Gestión de Ventas",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 24.0,
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    (){};
                  },
                  child: Container(
                  
                    margin:const EdgeInsets.only(top: 20.0,bottom: 5.0),
                    decoration: BoxDecoration( // Para el borde redondeado
                      borderRadius: BorderRadius.circular(5.0), 
                      border: Border.all(color: Colors.grey, width: 1.0)
                    ),
                    child:const ListTile( // ListTile dentro del Container
                      title: Text("Buscar venta"), 
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 10),
                      // Considera agregar íconos (leading, trailing) o padding si lo deseas 
                    ), 
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Venta>>(
                  future: _listaVentas,
                  
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
                    }else {
                      int nVenta= 0;
                      List<Venta> ventas = snapshot.data!;
                      return ListView.builder(
                        itemCount: ventas.length,
                        itemBuilder: (context, index) {
                          Venta venta = ventas[index];
                          nVenta++;
                          return Container(
                            margin: index == ventas.length - 1 
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
        
                            child: VentaCard(venta: venta, nVenta: nVenta)
                            );
                          },
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      
    );
  }
}