import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemonapp/main.dart';
import 'package:lemonapp/services/config.dart';
import 'package:lemonapp/widgets/alertas_widget.dart';
import 'package:lemonapp/widgets/retroceder.dart';

const Color primaryColor = Color(0xFF077336);

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith( // Para la barra de notificaciones
        statusBarColor: Colors.black.withOpacity(0)
      ), 
      backgroundColor:primaryColor,
      title:const Text("LEMON",style: TextStyle(color: Colors.white),),
      centerTitle: true,
      actions: [
        IconButton(
          icon:const Icon(Icons.logout, color: Colors.white,),
          onPressed: (){
            alertaCerrarSesion(context).then((value){
              if(value){
                deleteToken("Token").then((value){
                    Navigator.pushReplacement(
                      context,
                      SlidePageRoute(page:const MyApp()),
                    );
                });
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

void errorSesion(BuildContext context,String descripcion){

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            const Text("Error de sesion"),
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
    deleteToken("Token").then((value){
        Navigator.pushReplacement(
          context,
          SlidePageRoute(page:const MyApp()),
        );
    });
  });
}