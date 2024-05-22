import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
String httpUrl="http://florezsena-001-site1.ltempurl.com/api";

Future<void> guardarToken(String clave, String valor) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: clave, value: valor);
}

Future<String?> obtenerToken(String clave) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: clave);
}
Future<void> deleteToken(String clave) async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: clave);
}
Future<String>  login(String usuarioString,String passwordString) async {
  final Uri url = Uri.parse("$httpUrl/Accesos/Login");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json'  
    },
    body:  jsonEncode({"usuario": usuarioString, "password": passwordString}),
  );

  

  if(response.statusCode==200){
    String body = utf8.decode(response.bodyBytes);
    final jsonData=jsonDecode(body);
    List<int> permisos = List<int>.from(jsonData["permisos"]);
    
    if(jsonData['success']){
      if(permisos.contains(5) && permisos.contains(6)){
        String tokenString=jsonData["result"];
        guardarToken("Token", tokenString);
        return "Exito";
      }else{
        return "No contienes los permisos para acceder al aplicativo";
      }
      
    }
    return "${jsonData["message"]}";
  }else{
    return "Error";
  }
}