import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_bloc/blocs/favoritos_bloc.dart';
import 'package:youtube_bloc/models/video.dart';

import 'video_play_page.dart';

class FavoritosPage extends StatelessWidget {
  const FavoritosPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _favoritosBloc = BlocProvider.getBloc<FavoritosBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: _favoritosBloc.outFavoritos,
        initialData: {},
        builder: (context, snapshot) {
          return ListView(
            children: snapshot.data?.values.map((video) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(video: video),
                    ),
                  );
                },
                onLongPress: () {
                  _favoritosBloc.toggledFavorito(video);
                },
                child: Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Image.network(
                        video.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              video.title,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              video.chanel,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList() ?? [],
          );
        },
      ),
    );
  }
}