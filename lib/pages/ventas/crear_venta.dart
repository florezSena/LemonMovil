import 'package:flutter/material.dart';
import 'package:lemonapp/delegates/search_cliente_venta.dart';
import 'package:lemonapp/delegates/search_producto_venta.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/ventas/crear_venta/carrito_venta.dart';
import 'package:lemonapp/pages/ventas/crear_venta/select_cliente.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:lemonapp/widgets/modal_add_producto.dart';
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
    bool mostrarBotonCancelar=context.watch<VentasProvider>().botonCancelarGet;
    bool showBotonCliente=context.watch<VentasProvider>().botonClienteGet;
    Cliente? cliente=context.watch<VentasProvider>().clienteGet;


    Color colorSiguiente;
    if(isCarrito==false){
      colorSiguiente=Colors.black;
    }else if(mostrarBotonCancelar==false && isCliente==false){
      colorSiguiente=Colors.black;
    }else{
      colorSiguiente=primaryColor;
    }
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
                  if(value!=0 && isCarrito==true){
                    context.read<VentasProvider>().deleteBotonCancelar();
                    context.read<VentasProvider>().showBotonCliente();

                  }else if(value==0){
                    context.read<VentasProvider>().resetBotonCancelar();
                    context.read<VentasProvider>().deleteBotonCliente();

                  }
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
                  children: [
                    CarritoVenta(),
                    SelecetCliente(),
                    Text("${cliente==null?"1":cliente.correo}",),
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
                mostrarBotonCancelar?ElevatedButton(
                  onPressed: (){
                    showSearch(context: context, delegate: SearchProductoVenta()).then((value){
                      if(value!=null){
                        modalAddProduct(context,value);
                      }
                    });
                  }, 
                  style: ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,45),
                    backgroundColor: primaryColor,
                    side: const BorderSide(color:primaryColor,width: 1),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ),
                  child:const Text("Agregar producto", style: TextStyle(color: Colors.white),),
                ):const SizedBox(),

                const Padding(padding: EdgeInsets.only(top: 5)),
                showBotonCliente?ElevatedButton(
                  onPressed: (){
                    showSearch(context: context, delegate: SearchClienteVenta()).then((value){
                      if(value!=null){
                        context.read<VentasProvider>().addCliente(value);
                      }
                    });
                  }, 
                  style: ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,45),
                    backgroundColor: primaryColor,
                    side: const BorderSide(color:primaryColor,width: 1),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ),
                  child:const Text("Agregar cliente", style: TextStyle(color: Colors.white),),
                ):const SizedBox(),
                const Padding(padding: EdgeInsets.only(top: 5)),

                ElevatedButton(
                  onPressed: (){
                    if(_tabController.index==0 && isCarrito){
                      context.read<VentasProvider>().deleteBotonCancelar();
                      context.read<VentasProvider>().showBotonCliente();
                      _tabController.index=1;
                    }else if(_tabController.index==1 && isCliente){
                      _tabController.index=2;
                      context.read<VentasProvider>().deleteBotonCliente();
                    }else if(_tabController.index==0 && isCarrito==false){
                      alertaValidacionDeVista(context,"No tienes productos agregados","Debes agregar almenos un producto para continuar con el registro de la venta");
                    }
                    else if(_tabController.index==1 && isCliente==false){
                      alertaValidacionDeVista(context,"No elegiste el cliente","Debes elegir un cliente continuar con el registro de la venta");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,45),
                    backgroundColor: colorSiguiente,
                    side:BorderSide(color: colorSiguiente,width: 1),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ),
                  child:const Text("Siguiente", style: TextStyle(color: Colors.white),),
                ),
                const Padding(padding: EdgeInsets.only(top: 5)),
                mostrarBotonCancelar==false? ElevatedButton(
                  onPressed: (){
                    if(_tabController.index==1){
                      context.read<VentasProvider>().deleteBotonCliente();
                      context.read<VentasProvider>().resetBotonCancelar();
                      _tabController.index=0;
                    }else if(_tabController.index==2){
                      _tabController.index=1;
                      context.read<VentasProvider>().showBotonCliente();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:const Size(double.infinity,45),
                    backgroundColor:Colors.black,
                    side:const BorderSide(color:Colors.black,width: 1),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ),
                  child:const Text("Volver", style: TextStyle(color: Colors.white),),
                ):const SizedBox(),
                mostrarBotonCancelar?ElevatedButton(
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
                ):const SizedBox(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}