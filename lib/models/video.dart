class Video {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String chanel;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.chanel,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']['videoId'],
      title: json['snippet']['title'],
      thumbnailUrl: json['snippet']['thumbnails']['high']['url'],
      chanel: json['snippet']['channelTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': {'videoId': id},
      'snippet': {
        'title': title,
        'thumbnails': {
          'high': {'url': thumbnailUrl},
        },
        'channelTitle': chanel,
      },
    };
  }
}