class CommunityPostComment {
  dynamic idComment;
  dynamic idPost;
  dynamic idAccountWriter;
  dynamic comment;
  dynamic dateAdded;
  dynamic dateEdited;

  CommunityPostComment({
    this.idComment,
    this.idPost,
    this.idAccountWriter,
    this.comment,
    this.dateAdded,
    this.dateEdited,
  });

  factory CommunityPostComment.fromJson(Map<String, dynamic> json) {
    return CommunityPostComment(
      idComment: json['id_comment'],
      idPost: json['id_post'],
      idAccountWriter: json['id_account_writer'],
      comment: json['comment'],
      dateAdded: json['date_added'],
      dateEdited: json['date_edited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_comment': idComment,
      'id_post': idPost,
      'id_account_writer': idAccountWriter,
      'comment': comment,
      'date_added': dateAdded,
      'date_edited': dateEdited,
    };
  }
}
