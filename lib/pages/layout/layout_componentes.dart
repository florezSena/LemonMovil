
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}