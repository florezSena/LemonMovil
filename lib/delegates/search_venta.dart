import 'package:flutter/material.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:lemonapp/widgets/venta_card.dart';

class SearchVenta extends SearchDelegate<Venta?>{
  @override
  String get searchFieldLabel=>'Buscar venta';
  
  @override
  List<Widget>? buildActions(BuildContext context) {
    if(query==""){
      return [
        IconButton(onPressed: ()=>close(context,null), icon:const Icon(Icons.clear))
      ];
    }
    return [
      IconButton(onPressed: ()=>query="", icon:const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: ()=>close(context,null), 
      icon:const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: getVentasQuery(query), 
      builder: (context,snapshot){
        final ventas=snapshot.data??[];
        if(ventas.isEmpty && query!=""){
          return const Center(child: Text("Venta no econtrada"));
        }else if(ventas.isEmpty && query==""){
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (context,index){
                final venta=ventas[index];
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
                  child: VentaCard(venta:venta)
                );
              }
            
            ),
          ),
        );
      },
      );

  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getVentasQuery(query), 
      builder: (context,snapshot){
        final ventas=snapshot.data??[];
        if(ventas.isEmpty && query!=""){
          return const Center(child: Text("Venta no econtrada"));
        }else if(ventas.isEmpty && query==""){
          return const Center(child: CircularProgressIndicator());
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: ventas.length,
              itemBuilder: (context,index){
                final venta=ventas[index];
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
                  child: VentaCard(venta:venta)
                );
              }
            ),
          ),
        );
      },
    );
  }
}

