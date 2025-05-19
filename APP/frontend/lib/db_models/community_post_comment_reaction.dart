class CommunityPostCommentReaction {
  dynamic idComment;
  dynamic idAccount;
  dynamic reaction;

  CommunityPostCommentReaction({
    this.idComment,
    this.idAccount,
    this.reaction,
  });

  factory CommunityPostCommentReaction.fromJson(Map<String, dynamic> json) {
    return CommunityPostCommentReaction(
      idComment: json['id_comment'],
      idAccount: json['id_account'],
      reaction: json['reaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_comment': idComment,
      'id_account': idAccount,
      'reaction': reaction,
    };
  }
}
