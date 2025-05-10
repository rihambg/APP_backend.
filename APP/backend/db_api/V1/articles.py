from flask import Blueprint, request, jsonify
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('articles_routes', __name__)


# Model for Article
class Article(db.Model):
    __tablename__ = "articles"

    id_article = db.Column(db.Integer, primary_key=True)
    id_account_writer = db.Column(db.Integer, nullable=False)
    title = db.Column(db.String(255), nullable=False)
    content = db.Column(db.Text, nullable=False)
    publish_date = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<Article {self.id_article}>"

    def to_dict(self):
        return {
            "id_article": self.id_article,
            "id_account_writer": self.id_account_writer,
            "title": self.title,
            "content": self.content,
            "publish_date": self.publish_date.isoformat()
        }

# Routes
@app.route('/articles', methods=['POST'])
def create_article():
    try:
        data = request.json
        article = Article(
            id_account_writer=data['id_account_writer'],
            title=data['title'],
            content=data['content'],
            publish_date=data['publish_date']
        )

        db.session.add(article)
        db.session.commit()

        return jsonify({"message": "Article added", "id_article": article.id_article}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/articles', methods=['GET'])
def get_all_articles():
    articles = Article.query.all()
    return jsonify([article.to_dict() for article in articles])

@app.route('/articles/<int:id_article>', methods=['GET'])
def get_article(id_article):
    article = Article.query.get(id_article)
    if article:
        return jsonify(article.to_dict())
    return jsonify({"error": "Article not found"}), 404

@app.route('/articles/<int:id_article>', methods=['PUT'])
def update_article(id_article):
    article = Article.query.get(id_article)
    if article:
        data = request.json
        article.id_account_writer = data['id_account_writer']
        article.title = data['title']
        article.content = data['content']
        article.publish_date = data['publish_date']

        db.session.commit()

        return jsonify({"message": "Article updated"}), 200
    return jsonify({"error": "Article not found"}), 404

@app.route('/articles/<int:id_article>', methods=['DELETE'])
def delete_article(id_article):
    article = Article.query.get(id_article)
    if article:
        db.session.delete(article)
        db.session.commit()
        return jsonify({"message": "Article deleted"}), 200
    return jsonify({"error": "Article not found"}), 404

