import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemonapp/pages/layout/layout_componentes.dart';
import 'package:lemonapp/pages/layout/layout_index.dart';
import 'package:lemonapp/services/config.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:lemonapp/widgets/retroceder.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginIndex extends StatefulWidget {
  const LoginIndex({super.key});
  @override
  State<LoginIndex> createState() => _LoginIndex();
}

class _LoginIndex extends State<LoginIndex> {
  bool _isPosting=false;
  TextEditingController usuarioController=TextEditingController(text: "");
  TextEditingController passwordController=TextEditingController(text: "");
  bool _showPassword = true;


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
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
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
                          controller: usuarioController,
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
                          obscureText: _showPassword,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
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
                        const Padding(padding: EdgeInsets.only(top:20)),
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
                            if(_isPosting==false){
                              alertaCargando(context);
                              _isPosting=true;
                              login(usuarioController.text, passwordController.text).then((value) {
                                _isPosting=false;
                                Navigator.pop(context);
                                if(value){
                                  Navigator.pushReplacement(
                                    context,
                                    SlidePageRoute(page:const LayoutIndex()),
                                  );
                                }else{
                                  alertFinal(context, false, "Usuario no encontrado");
                                }
                              });
                            }
                          }, 
                          child: const Text("Ingresar", style: TextStyle(color: Colors.white),)
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                launchUrlString("https://www.google.com");
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 15),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black, width: 2)),
                                ),
                                child: const Text("¿Olvidaste tu contraseña?",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)
                              )
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 20.0))
                      ],  
                    )
                  ),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}