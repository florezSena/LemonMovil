
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lemonapp/models/venta.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/services/service_venta.dart';
import 'package:provider/provider.dart';
Future<bool> alertFinal(BuildContext context,bool? tipo,String descripcion) async{
  Completer<bool> completer = Completer<bool>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            tipo!=null?Text(tipo?"Exito":"Error"):const Text(""),
            const Padding(padding: EdgeInsets.all(10)),
            Text(descripcion,style:const TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(primaryColor)
            ),
            child: const Text('Aceptar',style: TextStyle(color: Colors.white),),
            onPressed: () async{
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((value) {
      completer.complete(true);
  });
  return completer.future;
}

Future <bool> alertaCancelarVenta(BuildContext context) async{
  Completer<bool> completer = Completer<bool>();
  showModalBottomSheet(
    context: context,
    //Con el true utiliza todo el height disponible
    isScrollControlled: true,
    builder: (BuildContext context) {
      //Si envuelvo el alertDialog en un FractionallySizedBox puedo modificar cuanto height puede utilizar el showModdal
      return AlertDialog(
        title: const Text("¿Estas seguro de cancelar la venta?"),
        actions: [
          const Text("Se perderán los detalles agregados si das en aceptar"),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style:const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                  backgroundColor: MaterialStatePropertyAll(Colors.black)
                ),
                child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.pop(context,false);
                },
              ),
              TextButton(
                style:const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                  backgroundColor: MaterialStatePropertyAll(primaryColor)
                ),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  context.read<VentasProvider>().deleteAllProductCarrito();
                  context.read<VentasProvider>().deleteCliente();
                  Navigator.pop(context,true);
                },
              ),
            ],
          ),
        ],
      );
    },
    backgroundColor: Colors.transparent,
  ).then((value){
     if (value != null && value) {
      completer.complete(true);
    } else {
      completer.complete(false);
    }
  });
  return completer.future;
}

void alertaValidacionDeVista(BuildContext context,String title,String subtitle) async{

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,

    context: context, 
    builder:(context) {
      return AlertDialog(
        title: Text(title),
        actions: [
          Text(subtitle),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                style:const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                  backgroundColor: MaterialStatePropertyAll(Colors.black)
                ),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.pop(context,true);
                },
              ),
            ],
          ),
        ],
      );  
    },
  );
  
}

Future<bool> alertaRealizarVenta(BuildContext context) async{
  Completer<bool> completer = Completer<bool>();

  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,

    context: context, 
    builder:(context) {
      return AlertDialog(
        title:const Text("¿Estas seguro de realizar la venta?"),
        actions: [
          const Text("Verifica que todos los datos esten correctos"),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style:const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                  backgroundColor: MaterialStatePropertyAll(Colors.black)
                ),
                child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.pop(context,false);
                },
              ),
              TextButton(
                style:const ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
                  backgroundColor: MaterialStatePropertyAll(primaryColor)
                ),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
                onPressed: () {
                  Navigator.pop(context,true);
                },
              ),
            ],
          ),
        ],
      );  
    },
  ).then((value){
     if (value != null && value) {
      completer.complete(true);
    } else {
      completer.complete(false);
    }
  });
  return completer.future;
}


void alertaCargando(BuildContext context){
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: false,
    context: context, 
    builder:(context) {
      return PopScope(
        canPop: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.50,
            top: MediaQuery.of(context).size.height * 0.50,
          ),
          child:const AlertDialog(
            title: Text("Cargando..."),
            actions: [
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );  
    },
  );
}



Future<bool> alertaAnularVenta(BuildContext context,Venta ventaAAnular) async{
  Completer<bool> completer = Completer<bool>();
  
  int x=0;
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Estas seguro de anular la venta?'),
        actions: [
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(Colors.black)
            ),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(primaryColor)
            ),
            child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
            onPressed: () async{
              x=1;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((value) async{
    if(x==1){
      alertaCargando(context);
      await anularVenta(ventaAAnular).then((response){
        Navigator.pop(context);
        if(response){
          completer.complete(true);
          alertFinal(context, true, 'Venta anulada');
        }else{
          completer.complete(false);
          alertFinal(context, false, 'Error al anular la venta');
        }
      });
    }else{
      completer.complete(false);
    }
  });
  return completer.future;
}


Future<bool> alertaCerrarSesion(BuildContext context) async{
  Completer<bool> completer = Completer<bool>();
  int x=0;
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('¿Estas seguro de cerrar sesion?'),
        actions: [
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(Colors.black)
            ),
            child: const Text('Cancelar', style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(primaryColor)
            ),
            child: const Text('Aceptar', style: TextStyle(color: Colors.white),),
            onPressed: () async{
              x=1;
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((value){
    if(x==1){
      completer.complete(true);  
    }else{
      completer.complete(false);
    }
  });
  return completer.future;
}

Future<bool> alertasLogin(BuildContext context,bool? tipo,String descripcion) async{
  Completer<bool> completer = Completer<bool>();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            tipo!=null?Text(tipo?"Exito":"Error"):const Text(""),
            const Padding(padding: EdgeInsets.all(10)),
            Text(descripcion,style:const TextStyle(fontSize: 20)),
          ],
        ),
        actions: [
          TextButton(
            style:const ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
              backgroundColor: MaterialStatePropertyAll(Colors.black)
            ),
            child: const Text('Aceptar',style: TextStyle(color: Colors.white),),
            onPressed: () async{
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  ).then((value) {
      completer.complete(true);
  });
  return completer.future;
}