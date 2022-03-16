import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_bloc/blocs/favoritos_bloc.dart';
import 'package:youtube_bloc/blocs/videos_bloc.dart';
import 'package:youtube_bloc/delegates/data_search.dart';
import 'package:youtube_bloc/models/video.dart';
import 'package:youtube_bloc/widgets/video_tile.dart';

import 'favoritos.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideosBloc videosBloc = BlocProvider.getBloc<VideosBloc>();
    final FavoritosBloc favoritosBloc = BlocProvider.getBloc<FavoritosBloc>();
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 25,
            child: Image.asset("assets/images/youtube_transparent_logo.png"),
          ),
          elevation: 0,
          actions: [
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<Map<String, Video>>(
                stream: favoritosBloc.outFavoritos,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return Text(
                    "${snapshot.data?.length}",
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  );
                },
              ),
            ),
            IconButton(
                icon: const Icon(Icons.stars),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FavoritosPage(),
                    ),
                  );
                }),
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async {
                  String? result = await showSearch(
                      context: context, delegate: DataSearch());
                  if (result != null) videosBloc.inSearch.add(result);
                }),
          ],
        ),
        body: StreamBuilder<List<Video>?>(
          stream: videosBloc.outVideos,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data!.length) {
                    return VideoTile(
                      video: snapshot.data![index],
                      onTap: () {},
                    );
                  } else if (index > 1) {
                    videosBloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else if (snapshot.connectionState ==
                          ConnectionState.active &&
                      snapshot.data?.length == 0) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Busque alguma coisa!",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    );
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
