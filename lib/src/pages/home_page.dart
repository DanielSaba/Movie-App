import 'package:flutter/material.dart';
import 'package:movie_proyect/src/providers/pelicula_provides.dart';
import 'package:movie_proyect/src/search/search_delegate.dart';
import 'package:movie_proyect/src/widgets/card_swiper_widget.dart';
import 'package:movie_proyect/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final peliculasprovide = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    peliculasprovide.getPopular();

    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas en Cines'),
          backgroundColor: Colors.indigoAccent,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: Datasearch());
                })
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[_swiperTarjetas(), _footer(context)],
          ),
        ));
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Populares',
                  style: Theme.of(context).textTheme.subtitle1)),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasprovide.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  siguientePagina: peliculasprovide.getPopular,
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: peliculasprovide.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(peliculas: snapshot.data);
        } else {
          return CircularProgressIndicator();
        }
      },
    );

    /* peliculasprovide.getEnCines();
    return CardSwiper(
      peliculas: [1, 2, 3],
    );
  */
  }
}
