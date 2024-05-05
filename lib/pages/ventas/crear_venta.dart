import 'package:flutter/material.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/ventas/crear_venta/carrito_venta.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:provider/provider.dart';

class CrearVenta extends StatefulWidget {
  const CrearVenta({super.key});

  @override
  State<CrearVenta> createState() => _CrearVentaState();
}

class _CrearVentaState extends State<CrearVenta>with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 3, vsync: this);
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isCarrito=context.watch<VentasProvider>().carritoVentaGet;
    bool isCliente=context.watch<VentasProvider>().clienteVentaGet;
    bool ventaCancelada=false;
    return DefaultTabController(
      length: 3,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          //Que quermeos hacer cuando salgamos de la pagina
          if(ventaCancelada==false){
            alertaCancelarVenta(context).then((value){
              if(value){
                ventaCancelada=true;
                Navigator.pop(context);
              }else{
                ventaCancelada=false;
              }
            });
          }
        },
        child: Scaffold(
          appBar:const CustomAppBar(),
          body: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs:const [
                  Tab(icon: Icon(Icons.shopping_bag_outlined),),
                  Tab(icon: Icon(Icons.person),),
                  Tab(icon: Icon(Icons.monetization_on_outlined),),
                ],
                onTap: (value) {
                  if(isCarrito==false){
                    _tabController.index=0;
                  }else if(isCliente==false && value==2){
                    _tabController.index=1;
                  }
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics:const NeverScrollableScrollPhysics(),
                  children: const[
                    CarritoVenta(),
                    Text("2",),
                    Text("3",),
                  ]
                ),
              )
            ],
          ),
          floatingActionButton: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: (){
                    context.read<VentasProvider>().addProductCarrito(DetallesVenta(1, 1, 1, 1, 1, 1, Producto(1, "nombre", 1, 1, "descripcion", 1)));
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,45),
                    backgroundColor: isCarrito==true?primaryColor:Colors.black,
                    side:BorderSide(color: isCarrito==true?primaryColor:Colors.black,width: 1),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ),
                  child:const Text("Siguiente", style: TextStyle(color: Colors.white),),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                ElevatedButton(
                  onPressed: (){
                    alertaCancelarVenta(context).then((value) {
                      if(value){
                        ventaCancelada=true;
                        Navigator.pop(context);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,45),
                    backgroundColor: Colors.black,
                    side:const BorderSide(color: Colors.black,width: 1),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ),
                  child:const Text("Cancelar", style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}