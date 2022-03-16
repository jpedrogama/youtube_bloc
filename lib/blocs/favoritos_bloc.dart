import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_bloc/models/video.dart';

class FavoritosBloc implements BlocBase {

  final _favoritosController = BehaviorSubject<Map<String, Video>>.seeded({});
  
  Stream<Map<String, Video>> get outFavoritos => _favoritosController.stream;

  Map<String, Video> _favoritos = {};

  FavoritosBloc(){
    SharedPreferences.getInstance().then((prefs){
      if(prefs.getKeys().contains("favoritos")){
        _favoritos = json.decode(prefs.getString("favoritos")!).map((k, v){
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
        _favoritosController.add(_favoritos);
      }
    });
  }

  void toggledFavorito(Video video) {
    if (_favoritos.containsKey(video.id)) {
       _favoritos.remove(video.id);
    } else {
      _favoritos[video.id] = video;
    }

    _favoritosController.sink.add(_favoritos);
    _saveFavoritos();
  }

  @override
  void addListener(VoidCallback listener) {
   
  }

  @override
  void dispose() {
    _favoritosController.close();
  }

  @override
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
  }

  @override
  void removeListener(VoidCallback listener) {
  }

  void _saveFavoritos() {
  SharedPreferences.getInstance().then((prefs){
    prefs.setString("favoritos", json.encode(_favoritos));
  });
}
}