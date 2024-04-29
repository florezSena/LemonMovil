
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  bool _isPosting=false;
  bool _alertDuplicated=false;
  TextEditingController nameController=TextEditingController(text: "");
  TextEditingController? descripcionController = TextEditingController();

  Future <bool> _duplicateName() async {
    String nombreDupli= nameController.text;
    final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/GetProductByName?nombre=$nombreDupli");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
      },
    );
    bool duplicated=false;

    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData=jsonDecode(body);

      for (var element in jsonData) {
        
        if(nombreDupli.toLowerCase()==element["nombre"].toString().toLowerCase()){
          duplicated=true;
        }
            
      }
      
      return duplicated;
      
    }else{
      throw Exception("Fallo la conexion a la api");
    }
  }
  Future<bool>  _postProductos() async {
    String? descripcionProducto;
    if(descripcionController!=null){
      descripcionProducto=descripcionController!.text;
    }
    Producto producto = Producto(
      0,
      nameController.text,
      0,
      0,
      descripcionProducto,
      1,
    );
    // Convertir el objeto a JSON
    String productoJson = jsonEncode(producto);
    final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/InsertProduct");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
        'Content-Type': 'application/json'
      },
      body: productoJson,
    );

    

    if(response.statusCode==200){
      return true;
    }else{
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
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
                  child: Text(
                    "Registrar producto",
                    style: TextStyle(
                      fontSize: 24.0, // Tamaño de la fuente de 24.0
                    ),
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
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate() && _isPosting==false) {

                        setState(() {
                          _isPosting=true;
                        });

                        await _duplicateName().then((nameDuplicated) async{
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
                            await _postProductos().then((respuesta){
                              if(respuesta){
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text('Producto creado exitosamente',style: TextStyle(color:Colors.white),),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: primaryColor,
                                  ),
                                );
                                Navigator.pop(context,true);
                              }else{
                                setState(() {
                                  _isPosting=false;
                                });
                                ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  const SnackBar(
                                    content: Text('Error al crear el producto',style: TextStyle(color:Colors.white),),
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
                    child:const Text('Guardar',style: TextStyle(color: Colors.white),)
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
                )
              ],
            ),
          )
        ),
      )
    );
  }
}