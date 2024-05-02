
import 'package:flutter/material.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/providers/productos_provider.dart';
import 'package:lemonapp/services/service_product.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key,required this.produtoSelect});
  final Producto produtoSelect;

  @override
  State<EditProduct> createState() => _EditProduct();
}

class _EditProduct extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isPosting=false;
  bool _alertDuplicated=false;
  TextEditingController nameController=TextEditingController(text: "");
  TextEditingController? descripcionController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    Producto productSelect=widget.produtoSelect;
    nameController.text=productSelect.nombre;
    descripcionController!.text=productSelect.descripcion=="null"?"":productSelect.descripcion??"";
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:primaryColor,
        title:const Text("LEMON",style:TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon:const Icon(Icons.logout, color: Colors.white,),
            onPressed: (){},
          ),
        ],
      ),
      body: Center(child: 
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Form(
            key: _formKey,
            
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
                        "Editar Producto",
                        style: TextStyle(
                          fontSize: 24.0, // Tamaño de la fuente de 24.0
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Nombre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: primaryColor,
                        ),
                      ),
                    ),
                    validator:(value){
                      RegExp regexName = RegExp(r'^[a-zA-ZñÑ]+(?: [a-zA-ZñÑ]+)*$');
                      if (value!.isEmpty) {
                        return "El nombre es necesario";
                      }else if(value.length<3 || value.length>30){
                        return "El nombre no puede tener menos de 3 o mas de 30 caracteres";
                      } else if (!regexName.hasMatch(value)) {
                        return "Nombre invalido";
                      } else {
                        return null;
                      }
                    }
                  ),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    hintText: 'Descripcion',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                        focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: primaryColor,
                        ),
                      ),
                  ),
                  validator:(value){
                    RegExp regexDescripcion = RegExp(r'^(?:[^\s]+(?:\s[^\s]+)*)?$');
                    if (value!.isNotEmpty) {
                      if(value.length>50){
                        return "La descripcion no puede tener mas de 50 caracteres";
                      } else if (!regexDescripcion.hasMatch(value)) {
                        return "Descripcion no valida";
                      }
                    }
                    return null;
                  }
                ),
                const Padding(padding: EdgeInsets.only(bottom: 40)),
                _isPosting==true?const Center(
                  child: Column(
                    children: [
                      Text("Cargando..."),
                      Padding(padding: EdgeInsets.only(bottom: 15)),
                      CircularProgressIndicator(),
                    ],
                  ),
                ):const Text("LEMON"),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate() && _isPosting==false) {

                        setState(() {
                          _isPosting=true;
                        });
                        productSelect.nombre=nameController.text;
                        productSelect.descripcion=descripcionController?.text;


                        await duplicateNameUpdate(productSelect).then((nameDuplicated) async{
                          if (nameDuplicated==true){
                            setState(() {
                              _isPosting=false;
                            });
                            if(_alertDuplicated==false){
                              setState(() {
                                _alertDuplicated=true;
                              });
                              ScaffoldMessenger.of(context)
                              .showSnackBar(
                                const SnackBar(
                                  content: Text('Este nombre ya esta registrado',style: TextStyle(color:Colors.white),),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.black,
                                ),
                              ).closed.then((_){
                                setState(() {
                                  _alertDuplicated=false;
                                });
                              });
                            }
                          }else{
                            productSelect.descripcion=productSelect.descripcion==""?null:productSelect.descripcion;
                            await putProduct(productSelect).then((respuesta){
                              if(respuesta){
                                context.read<ProductosProvider>().updateProductList(productSelect);
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text('Producto actualizado',style: TextStyle(color:Colors.white),),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                                Navigator.pop(context,productSelect);
                              }else{
                                setState(() {
                                  _isPosting=false;
                                });
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text('Error al actualizar el producto',style: TextStyle(color:Colors.white),),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Colors.black,
                                  ),
                                );
                              }
                            });
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape:const RoundedRectangleBorder( // Configura los bordes
                      borderRadius: BorderRadius.all(Radius.circular(5)), 
                    ),
                    ),
                    child:const Text('Actualizar',style: TextStyle(color: Colors.white),)
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      Navigator.pop(context);
                    }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 10.0), // Ajusta la altura
                    shape:const RoundedRectangleBorder( // Configura los bordes
                      borderRadius: BorderRadius.all(Radius.circular(5)), 
                    ),
                  ),
                  child:const Text('Cancelar',style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        ),
      )
    );
  }
}