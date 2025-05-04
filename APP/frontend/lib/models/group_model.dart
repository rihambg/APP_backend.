class Group {
  final String title;
  final String imageUrl;
  final int membersCount;
  bool isJoined; 

  Group({
    required this.title,
    required this.imageUrl,
    required this.membersCount,
    this.isJoined = false,
  });
}