import 'package:flutter/material.dart';
import 'package:lemonapp/delegates/search_producto.dart';
import 'package:lemonapp/models/producto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lemonapp/pages/products/add_product.dart';
void main() {
  runApp(const MyApp());
}
const Color primaryColor = Color(0xFF077336);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo wtf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'LEMON DEMO by FLOREZ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Producto>> _listaProductos;
  Future<List<Producto>>  _getProductos() async {
    final Uri url = Uri.parse("http://florezsena-001-site1.ltempurl.com/api/Productos/GetProduct");
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJiYXNlV2ViQXBpU3ViamVjdCIsImp0aSI6IjQ3NmE3MTgzLWZlMTAtNGE0MS1hYmNmLWQ2MDVjMDFmOTBmYSIsImlhdCI6IjEyLzA0LzIwMjQgMTo1NzoyMCBhLsKgbS4iLCJpZFVzZXIiOiIxIiwiZXhwIjoyMTIzMTE0MjQwLCJpc3MiOiJodHRwczovL2xvY2FsaG9zdDo3MjAwLyIsImF1ZCI6Imh0dHBzOi8vbG9jYWxob3N0OjcyMDAvIn0.Ao9qSTlj833ByfWpZvkV2FfOrBK5Egms2oRrXAoVEYM',
      },
    );
    List<Producto> productos=[];

    if(response.statusCode==200){
      String body = utf8.decode(response.bodyBytes);

      final jsonData=jsonDecode(body);

      for (var element in jsonData) {
        // print(element["nombre"]);
        productos.add(
          Producto(
            int.parse(element["idProducto"].toString()), 
            element["nombre"].toString(), 
            double.parse(element["cantidad"].toString()), 
            double.parse(element["costo"].toString()), 
            element["descripcion"].toString(), 
            int.parse(element["estado"].toString())
            )
        );
      }

      return productos;
    }else{
      throw Exception("Fallo la conexion a la api");
    }
  }
  @override
  void initState() {
    super.initState();
    _listaProductos=_getProductos();
  }
  Future<void> _refreshProductos() async {
    setState(() {
      _listaProductos = _getProductos();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        title: Text(widget.title,style:const TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon:const Icon(Icons.logout, color: Colors.white,),
            onPressed: _refreshProductos,
          ),
        ],
      ),
      body: Center(
        child: 
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9, // 80% del ancho
          child: Column(
            children: [
              Container(
                margin:const EdgeInsets.only(top: 20.0), // Margen superior de 20.0
                child:const Text(
                  "Gestión de productos",
                  style: TextStyle(
                    fontSize: 24.0, // Tamaño de la fuente de 24.0
                    fontWeight: FontWeight.bold, // Negrita
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: SearchProducto());
                },
                child: Container( // Un Container para mayor flexibilidad de diseño
                  margin:const EdgeInsets.only(top: 20.0,bottom: 5.0),
                  decoration: BoxDecoration( // Para el borde redondeado
                    borderRadius: BorderRadius.circular(5.0), 
                    border: Border.all(color: Colors.grey, width: 1.0)
                  ),
                  child:const ListTile( // ListTile dentro del Container
                    title: Text("Buscar producto"), 
                    dense: true,
                    contentPadding: EdgeInsets.only(left: 10),
                    // Considera agregar íconos (leading, trailing) o padding si lo deseas 
                  ), 
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Producto>>(
                future: _listaProductos,
                
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                    child: CircularProgressIndicator(),
                  );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<Producto> productos = snapshot.data!;
                    return ListView.builder(
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        Producto producto = productos[index];
                        return ListTile(
                          title: Text(producto.nombre),
                      contentPadding:const EdgeInsets.all(0),

                          subtitle: Text('Descripccion: ${producto.descripcion.toString()}\nCantidad: ${producto.cantidad}'),
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddProduct()),
        );
      },
      child: const Icon(Icons.add),
      ),
    );
  }
}
