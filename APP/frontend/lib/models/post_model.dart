class Post {
  final String username;
  final String timeAgo;
  final String content;
  final int comments;
  final String repliedBy;

  Post({
    required this.username,
    required this.timeAgo,
    required this.content,
    this.comments = 0,
    this.repliedBy = '',
  });
}