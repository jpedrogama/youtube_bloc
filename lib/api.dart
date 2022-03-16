import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_bloc/shared/config.dart';

import 'models/video.dart';

class Api {
  String? _search;
  String? _nextToken;

  Future<List<Video>?> search(String search) async {
    _search = search;
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=${Config.apiKey}&maxResults=10"));
    
    return decode(response);
  }

  Future<List<Video>?> nextPage() async {
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=${Config.apiKey}&maxResults=10&pageToken=$_nextToken"));
    return decode(response);
  }

  decode(http.Response response) {
    if (response.statusCode == 200) {
      Map<String, dynamic> dadosJson = json.decode(response.body);
      _nextToken = dadosJson["nextPageToken"];
      List<Video> videos = dadosJson['items'].map<Video>((map) {
        return Video.fromJson(map);
      }).toList();

      return videos;
    } else {
      throw Exception("Falha ao carregar os videos");
    }
  }
}
