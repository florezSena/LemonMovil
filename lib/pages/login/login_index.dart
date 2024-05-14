import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/layout/layout_index.dart';
import 'package:lemonapp/widgets/retroceder.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginIndex extends StatefulWidget {
  const LoginIndex({super.key});
  @override
  State<LoginIndex> createState() => _LoginIndex();
}

class _LoginIndex extends State<LoginIndex> {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF077336)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith( // Para la barra de notificaciones
            statusBarColor: Colors.black.withOpacity(0)
          ), 
          backgroundColor:const Color(0xFF077336),
          title:const Text("LEMON",style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                child: SizedBox(
                  height: 175.0,
                  width: 400.0,
                  child: Image.asset("assets/lemonlogo.png"),
                ),
              ),
              const Text("Inicia sesión",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Form(
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "correo@gmail.com",
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
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20)),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "************",
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
                        
                      ),
                      Padding(padding: EdgeInsets.only(top:20)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize:const Size(double.infinity,45),
                          backgroundColor: primaryColor,
                          side: const BorderSide(color:primaryColor,width: 1),
                          shape:const RoundedRectangleBorder( // Configura los bordes
                            borderRadius: BorderRadius.all(Radius.circular(5)), 
                          ),
                        ),
                        onPressed: (){
                          Navigator.push(
                            context,
                            SlidePageRoute(page:const LayoutIndex()),
                          );
                        }, 
                        child: Text("Ingresar", style: TextStyle(color: Colors.white),)
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        onPressed: (){
                          launchUrlString("https://www.google.com");
                        }, 
                        child: Text("Olvidaste tu contraseña",style: TextStyle(color: Colors.black),)
                      )
                    ],  
                  )
                ),
              )
            ],
          )
        )
      ),
    );
  }
}