import 'package:flutter/material.dart';
import 'package:lemonapp/models/detalles_venta.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/widgets/text_form_fields/ventas/text_form_carrito.dart';
import 'package:provider/provider.dart';

void modalAddProduct(BuildContext context,Producto producto)  {
  final formKey = GlobalKey<FormState>();
  TextEditingController precioController=TextEditingController(text: "");
  TextEditingController cantidadAComprarController=TextEditingController(text: "");
  precioController.text=producto.costo.toInt().toString();
  showModalBottomSheet(
    context: context, 
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder:(context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.95,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.only(top: 20.0,bottom: 40.0), // Margen superior de 20.0
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_basket),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      "Agregando un producto",
                      style: TextStyle(
                        fontSize: 24.0, // Tamaño de la fuente de 24.0
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: [
                    const Text("Nombre del producto", style: TextStyle(fontSize: 20),),
                    textFormName(producto),
                    const Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),

                    const Text("Cantidad disponible", style: TextStyle(fontSize: 20),),
                    textFormCantidadDisponible(producto),
                    const Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),

                    const Text("Precio (Kg)", style: TextStyle(fontSize: 20),),                    
                    textFormPrecio(precioController,producto),
                    const Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),

                    const Text("(Kg) a vender", style: TextStyle(fontSize: 20),),                    
                    textFormCantidadAVender(cantidadAComprarController,producto),            
                    const Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),
                    const Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),
                    
                    ElevatedButton(
                      onPressed: () async{
                        double cantidadAvender= double.parse(cantidadAComprarController.text);
                        double precioKilo= double.parse(precioController.text);
                        double subtotal=cantidadAvender*precioKilo;
                        subtotal = double.parse(subtotal.toStringAsFixed(2));
                        if (formKey.currentState!.validate()) {
                          context.read<VentasProvider>().addProductCarrito(DetallesVenta(0, 0, producto.idProducto, cantidadAvender, precioKilo, subtotal, producto));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize:const Size(double.infinity,45),
                        
                        backgroundColor: primaryColor,
                        shape:const RoundedRectangleBorder( // Configura los bordes
                        borderRadius: BorderRadius.all(Radius.circular(5)), 
                      ),
                      ),
                      child:const Text('Guardar',style: TextStyle(color: Colors.white),)
                    ),
                    const Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.pop(context);
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },  
  );
}