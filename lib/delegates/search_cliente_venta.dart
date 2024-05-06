import 'package:flutter/material.dart';
import 'package:lemonapp/models/cliente.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:lemonapp/widgets/cliente_venta_card.dart';

class SearchClienteVenta extends SearchDelegate<Cliente?>{
  @override
  String get searchFieldLabel=>'Buscar cliente';
  
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
      future: getClientes(query), 
      builder: (context,snapshot){
        final clientes=snapshot.data??[];
        if(clientes.isEmpty && query!=""){
          return const Center(child: Text("Cliente no econtrado"));
        }else if(clientes.isEmpty && query==""){
          return const Center(child: Text("Ingrese el nombre del cliente a buscar"));
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context,index){
                final cliente=clientes[index];
                return Container(
                  margin: index == clientes.length - 1 
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
                  child: ClienteVentaCard(cliente:cliente,onClienteSelected: close, )
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
      future: getClientes(query), 
      builder: (context,snapshot){
        final clientes=snapshot.data??[];
        if(clientes.isEmpty && query!=""){
          return const Center(child: Text("Cliente no econtrado"));
        }else if(clientes.isEmpty && query==""){
          return const Center(child: Text("Ingrese el nombre del cliente a buscar"));
        }
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context,index){
                final cliente=clientes[index];
                return Container(
                  margin: index == clientes.length - 1 
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
                  child: ClienteVentaCard(cliente:cliente,onClienteSelected: close, )
                );
              }
            
            ),
          ),
        );
      },
    );
  }
}

