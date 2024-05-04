
import 'package:flutter/material.dart';
class SlidePageRoute extends PageRouteBuilder {
  final Widget page;
  SlidePageRoute({required this.page})
  : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //4 animaciones= sale la pagina desde la derecha:
      const begin = Offset(1.0,0.0);
      //Sale la pagina desde la izquierda
      //const begin = Offset(-1.0,0.0);
      //Sale la pagina desde abajo:
      //const begin = Offset(0.0,1.0);
      //Sale la pagina desde arriba:
      //const begin = Offset(0.0,-1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}