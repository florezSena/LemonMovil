
import 'package:flutter/material.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
void alertFinal(BuildContext context,bool tipo,String descripcion) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Text(tipo?"Exito":"Error"),
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
  );
}