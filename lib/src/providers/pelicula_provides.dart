import 'dart:async';
import 'dart:convert';

import 'package:movie_proyect/src/models/actores_model.dart';
import 'package:movie_proyect/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  //GET EN CINES
  String _apiKey = '86778982fa6b0be8f1ae8d8bb0e2b542';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  //------------------------------------------------------------------------

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    final dataMovies = new Peliculas.fromJsonList(decodeData['results']);
    print(decodeData['results']);
    return dataMovies.items;
  }

  //------------------------------------------------------------------------
  //GET ENCINES
  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.https(_url, '3/movie/now_playing',
        {'api_key': _apiKey, 'language': _language});
    return await _procesarRespuesta(url);
  }

//GET POPULAR
  Future<List<Pelicula>> getPopular() async {
    if (_cargando) return [];

    _popularesPage++;

    final url = Uri.http(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);

    popularesSink(_populares);
    _cargando = false;

    return resp;
  }

//GET ACTORES
  Future<List<Actor>> getActor(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits',
        {'api_key': _apiKey, 'language': _language});

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.https(_url, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});
    return await _procesarRespuesta(url);
  }
}
