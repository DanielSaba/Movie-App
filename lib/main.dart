import 'package:flutter/material.dart';
import 'package:movie_proyect/src/pages/home_page.dart';
import 'package:movie_proyect/src/pages/pelicula_detalle.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => HomePage(),
        'peliculadetalle': (BuildContext context) => PeliculaDetalle(),
      },
    );
  }
}
