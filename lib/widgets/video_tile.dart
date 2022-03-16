import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_bloc/blocs/favoritos_bloc.dart';
import 'package:youtube_bloc/models/video.dart';
import 'package:youtube_bloc/ui/video_play_page.dart';

class VideoTile extends StatelessWidget {
  VideoTile({
    required this.video,
    required this.onTap,
  });

  final Video video;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final FavoritosBloc favBloc = BlocProvider.getBloc<FavoritosBloc>();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(video: video),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(video.thumbnailUrl, fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          video.chanel,
                          style: const TextStyle(
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: favBloc.outFavoritos,
                  initialData: {},
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: Icon(snapshot.data!.containsKey(video.id)
                            ? Icons.star
                            : Icons.star_border),
                        color: Colors.red,
                        onPressed: () {
                          favBloc.toggledFavorito(video);
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
