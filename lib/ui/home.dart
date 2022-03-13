import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_bloc/blocs/videos_bloc.dart';
import 'package:youtube_bloc/delegates/data_search.dart';
import 'package:youtube_bloc/models/video.dart';
import 'package:youtube_bloc/widgets/video_tile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideosBloc videosBloc = BlocProvider.getBloc<VideosBloc>();
    return Scaffold(
        appBar: AppBar(
          title: SizedBox(
            height: 25,
            child: Image.asset("assets/images/youtube_transparent_logo.png"),
          ),
          elevation: 0,
          backgroundColor: Colors.black12,
          actions: [
            IconButton(icon: Icon(Icons.stars), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String? result = await showSearch(
                      context: context, delegate: DataSearch());
                  if (result != null) videosBloc.inSearch.add(result);
                }),
          ],
        ),
        body: StreamBuilder<List<Video>?>(
          stream: videosBloc.outVideos,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            if(snapshot.hasData) {
              return ListView.builder(
                itemCount: (snapshot.data?.length ?? -1),
                itemBuilder: (context, index) {
                  if (index < (snapshot.data?.length ?? -1)) {
                    return VideoTile(video: snapshot.data![index], onTap: () {},);
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
                  } else {
                    return Container();
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
