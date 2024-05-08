import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemonapp/models/producto.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';

Widget textFormName(Producto producto) {
  return TextFormField(
    textAlign: TextAlign.center,
    enabled: false,
    decoration: InputDecoration(
      fillColor: Colors.grey[300],
      filled: true,
      hintText: producto.nombre,
      hintStyle:const TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
    ),
  );
}

Widget textFormCantidadDisponible(Producto producto) {
  return TextFormField(
    textAlign: TextAlign.center,
    enabled: false,
    decoration: InputDecoration(
      fillColor: Colors.grey[300],
      filled: true,
      hintText: "${producto.cantidad}",
      hintStyle:const TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
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
  );
}

Widget textFormPrecio(TextEditingController textEditinPrecio,Producto producto) {
  return TextFormField(
    controller: textEditinPrecio,

    keyboardType: TextInputType.number,

    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly, // Solo dígitos
    ],

    decoration: InputDecoration(
      hintText: "Precio (Kg)",
      hintStyle:const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
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
      RegExp regexPrecio = RegExp(r'^\d+(\.\d{1,2})?$');
      if (value!.isEmpty) {
        return "El precio es necesario";
      } else if (!regexPrecio.hasMatch(value)) {
        return "Cantidad invalida";
      }else if(double.parse(value)<producto.costo){
        return("El precio no puede ser menor al precio inicial: \$${producto.costo}");
      }else if(double.parse(value)<100){
        return("El precio no puede ser menor a \$100");
      } else {
        return null;
      }
    }
  );
}

Widget textFormCantidadAVender(TextEditingController textEditinCantidadAVender,Producto producto) {
  return TextFormField(
    controller:textEditinCantidadAVender,
    decoration: InputDecoration(
      hintText: "Cantidad a vender",
      hintStyle:const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
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

    keyboardType:const TextInputType.numberWithOptions(decimal: true),

    validator:(value){
      RegExp regexCantidadAvender = RegExp(r'^\d+(\.\d{1,2})?$');
      if (value!.isEmpty || double.parse(value)==0) {
        return "La cantidad a vender es necesaria";
      } else if (!regexCantidadAvender.hasMatch(value)) {
        return "Cantidad invalida";
      }else if(double.parse(value)>producto.cantidad){
        return("Cantidad a vender mayor a la disponible");
      } else {
        return null;
      }
    }
  );
}
