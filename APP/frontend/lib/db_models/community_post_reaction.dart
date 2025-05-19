class CommunityPostReaction {
  dynamic idPost;
  dynamic idAccount;
  dynamic reaction;

  CommunityPostReaction({
    this.idPost,
    this.idAccount,
    this.reaction,
  });

  factory CommunityPostReaction.fromJson(Map<String, dynamic> json) {
    return CommunityPostReaction(
      idPost: json['id_post'],
      idAccount: json['id_account'],
      reaction: json['reaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_post': idPost,
      'id_account': idAccount,
      'reaction': reaction,
    };
  }
}
