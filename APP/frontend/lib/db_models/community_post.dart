class CommunityPost {
  dynamic idPost;
  dynamic idAccountWriter;
  dynamic title;
  dynamic body;
  dynamic image;
  dynamic dateAdded;
  dynamic dateEdited;

  CommunityPost({
    this.idPost,
    this.idAccountWriter,
    this.title,
    this.body,
    this.image,
    this.dateAdded,
    this.dateEdited,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      idPost: json['id_post'],
      idAccountWriter: json['id_account_writer'],
      title: json['title'],
      body: json['body'],
      image: json['image'],
      dateAdded: json['date_added'],
      dateEdited: json['date_edited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_post': idPost,
      'id_account_writer': idAccountWriter,
      'title': title,
      'body': body,
      'image': image,
      'date_added': dateAdded,
      'date_edited': dateEdited,
    };
  }
}
