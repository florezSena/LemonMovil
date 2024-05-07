import 'package:flutter/material.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/products/products_index.dart';
import 'package:lemonapp/pages/ventas/ventas_index.dart';
import 'package:lemonapp/providers/metodos_provider.dart';
import 'package:provider/provider.dart';
class LayoutIndex extends StatefulWidget {
  const LayoutIndex({super.key});

  @override
  State<LayoutIndex> createState() => _LayoutIndex();
}

class _LayoutIndex extends State<LayoutIndex> {
  int _pageActual=1;

  final List<Widget> _pagesList= [
    const PrdouctosIndex(),
    const VentasIndex()
  ];
  @override
  Widget build(BuildContext context){
    bool isMetodo=context.watch<MetodosProvider>().isMetodoExecuteGet;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: const CustomAppBar(),
        body: _pagesList[_pageActual],
        bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if(!isMetodo){
            setState(() {
              _pageActual=index;
            });
          }
        },
        currentIndex:_pageActual,
        items: const [
          BottomNavigationBarItem(icon:Icon( Icons.shopping_bag_outlined),label: "Productos"),
          BottomNavigationBarItem(icon:Icon( Icons.monetization_on),label: "Ventas")
        ],
      ),
      ),
    );
  }
}