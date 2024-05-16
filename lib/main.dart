import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/layout/layout_index.dart';
import 'package:lemonapp/pages/login/login_index.dart';
import 'package:lemonapp/providers/productos_provider.dart';
import 'package:lemonapp/providers/metodos_provider.dart';
import 'package:lemonapp/providers/ventas_provider.dart';
import 'package:lemonapp/services/config.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MetodosProvider()),
        ChangeNotifierProvider(create: (_) => ProductosProvider()),
        ChangeNotifierProvider(create: (_) => VentasProvider()),

      ],
      child:const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.light.copyWith( // Para la barra de notificaciones
                statusBarColor: Colors.black.withOpacity(0)
              ), 
              backgroundColor:const Color(0xFF077336),
              title:const Text("LEMON",style: TextStyle(color: Colors.white),),
              centerTitle: true,
            ),
             body:const Center(
                child: CircularProgressIndicator(),
              ),
           );
          }else if(snapshot.hasError){
              return Text('Error: ${snapshot.error}');
          }else{
            bool isAuth = snapshot.data ?? false;
            return isAuth ? const LayoutIndex() : const LoginIndex();
          }
        },
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<bool> checkAuthStatus() async {
    final token = await obtenerToken("Token");
    return token != null;
  }
}
