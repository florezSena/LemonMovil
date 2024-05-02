import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/products/products_index.dart';
import 'package:lemonapp/pages/ventas/ventas_index.dart';
class LayoutIndex extends StatefulWidget {
  const LayoutIndex({super.key});

  @override
  State<LayoutIndex> createState() => _LayoutIndex();
}

class _LayoutIndex extends State<LayoutIndex> {
  int _pageActual=0;
  final List<Widget> _pagesList= [
    const PrdouctosIndex(),
    const VentasIndex()
  ];
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith( // Para la barra de notificaciones
            statusBarColor: Colors.black.withOpacity(0)
          ), 
          backgroundColor:primaryColor,
          title:const Text("LEMON",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          actions: [
            IconButton(
              icon:const Icon(Icons.logout, color: Colors.white,),
              onPressed: (){
              },
            ),
          ],
        ),
        body: _pagesList[_pageActual],
        bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _pageActual=index;
          });
        },
        currentIndex:_pageActual,
        items: const [
          BottomNavigationBarItem(icon:Icon( Icons.shopping_basket),label: "Productos"),
          BottomNavigationBarItem(icon:Icon( Icons.monetization_on),label: "Ventas")
        ],
      ),
      ),
    );
  }
}