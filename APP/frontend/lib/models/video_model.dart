class VideoTutorial {
  final String id;
  final String title;
  final String duration;
  final String author;

  VideoTutorial({
    required this.id,
    required this.title,
    required this.duration,
    required this.author,
  });

  // Construct YouTube video URL
  String get url => "https://www.youtube.com/watch?v=$id";
}