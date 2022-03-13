import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_bloc/shared/config.dart';

import 'models/video.dart';

class Api{
  static Future<List<Video>> search(String search) async {
    http.Response response = await http.get(Uri.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=${Config.apiKey}&maxResults=10"));

    if(response.statusCode == 200){
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Video> videos = dadosJson['snepets'].map<Video>((map){
        return Video.fromJson(map);
      }).toList();

      return videos;
    }else{
      throw Exception("Falha ao carregar os videos");
    }
  }
}