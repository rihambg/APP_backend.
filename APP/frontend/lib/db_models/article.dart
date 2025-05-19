class Article {
  dynamic idArticle;
  dynamic idAccountWriter;
  dynamic title;
  dynamic content;
  dynamic publishDate;

  Article({
    this.idArticle,
    this.idAccountWriter,
    this.title,
    this.content,
    this.publishDate,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      idArticle: json['id_article'],
      idAccountWriter: json['id_account_writer'],
      title: json['title'],
      content: json['content'],
      publishDate: json['publish_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_article': idArticle,
      'id_account_writer': idAccountWriter,
      'title': title,
      'content': content,
      'publish_date': publishDate,
    };
  }
}
