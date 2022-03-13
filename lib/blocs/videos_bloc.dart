import 'dart:async';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_bloc/models/video.dart';

import '../api.dart';

class VideosBloc implements BlocBase {
  Api? api;
  List<Video>? videos;
  final _videosController = StreamController<List<Video>?>.broadcast();
  Stream<List<Video>?> get outVideos => _videosController.stream;
  final StreamController _searchController = StreamController<String?>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(dynamic search) async {
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api?.search(search);
    } else {
      videos = ((videos ?? []) + (await api?.nextPage() ?? []));
    }
    _videosController.sink.add(videos);
  }

  @override
  void addListener(VoidCallback listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => throw UnimplementedError();

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }
}
