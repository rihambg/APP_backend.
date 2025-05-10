from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance
from datetime import datetime  # Import datetime for date and time handling


# Create a Blueprint for your routes
app = Blueprint('community_routes', __name__)


# Enums
class Reaction(Enum):
    LIKE = "like"
    DISLIKE = "dislike"
    LOVE = "love"

# Model for CommunityPost
class CommunityPost(db.Model):
    __tablename__ = "community_posts"
    
    id_post = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_account_writer = db.Column(db.Integer, nullable=False)
    title = db.Column(db.String(255), nullable=False)
    body = db.Column(db.Text, nullable=False)
    image = db.Column(db.String(255), nullable=True)
    date_added = db.Column(db.DateTime, default=datetime.utcnow)
    date_edited = db.Column(db.DateTime, nullable=True)

    def __repr__(self):
        return f"<CommunityPost {self.id_post}>"

    def to_dict(self):
        return {
            "id_post": self.id_post,
            "id_account_writer": self.id_account_writer,
            "title": self.title,
            "body": self.body,
            "image": self.image,
            "date_added": self.date_added.isoformat(),
            "date_edited": self.date_edited.isoformat() if self.date_edited else None
        }

# Model for CommunityPostReaction
class CommunityPostReaction(db.Model):
    __tablename__ = "community_post_reactions"
    
    id_post = db.Column(db.Integer, primary_key=True, foreign_key="community_posts.id_post")
    id_account = db.Column(db.Integer, nullable=False, primary_key=True)
    reaction = db.Column(db.Enum(Reaction, values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"<CommunityPostReaction {self.id_post}, {self.reaction}>"

    def to_dict(self):
        return {
            "id_post": self.id_post,
            "id_account": self.id_account,
            "reaction": self.reaction.value
        }

# Model for CommunityPostComment
class CommunityPostComment(db.Model):
    __tablename__ = "community_posts_comments"
    
    id_comment = db.Column(db.Integer, primary_key=True)
    id_post = db.Column(db.Integer, nullable=False)
    id_account_writer = db.Column(db.Integer, nullable=False)
    comment = db.Column(db.Text, nullable=False)
    date_added = db.Column(db.DateTime, default=datetime.utcnow)
    date_edited = db.Column(db.DateTime, nullable=True)

    def __repr__(self):
        return f"<CommunityPostComment {self.id_comment}>"

    def to_dict(self):
        return {
            "id_comment": self.id_comment,
            "id_post": self.id_post,
            "id_account_writer": self.id_account_writer,
            "comment": self.comment,
            "date_added": self.date_added.isoformat(),
            "date_edited": self.date_edited.isoformat() if self.date_edited else None
        }

# Model for CommunityPostCommentReaction
class CommunityPostCommentReaction(db.Model):
    __tablename__ = "community_posts_comment_reactions"
    
    id_comment = db.Column(db.Integer, primary_key=True)
    id_account = db.Column(db.Integer, nullable=False)
    reaction = db.Column(db.Enum(Reaction, values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"<CommunityPostCommentReaction {self.id_comment}, {self.reaction}>"

    def to_dict(self):
        return {
            "id_comment": self.id_comment,
            "id_account": self.id_account,
            "reaction": self.reaction.value
        }

# Routes
@app.route('/community_posts', methods=['GET'])
def get_all_community_posts():
    posts = CommunityPost.query.all()
    return jsonify([post.to_dict() for post in posts])

@app.route('/community_posts/<int:id_post>', methods=['GET'])
def get_community_post(id_post):
    post = CommunityPost.query.get(id_post)
    if post:
        return jsonify(post.to_dict())
    return jsonify({"error": "Post not found"}), 404

@app.route('/community_posts', methods=['POST'])
def create_community_post():
    try:
        data = request.json
        post = CommunityPost(
            id_account_writer=data['id_account_writer'],
            title=data['title'],
            body=data['body'],
            image=data.get('image'),
            date_added=datetime.utcnow(),
        )

        db.session.add(post)
        db.session.commit()

        return jsonify({"message": "Post added", "id_post": post.id_post}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400


@app.route('/community_posts/<int:id_post>', methods=['PUT'])
def update_community_post(id_post):
    post = CommunityPost.query.get(id_post)
    if post:
        data = request.json
        post.title = data['title']
        post.body = data['body']
        post.image = data.get('image')
        post.date_edited = datetime.utcnow()

        db.session.commit()

        return jsonify({"message": "Post updated"}), 200
    return jsonify({"error": "Post not found"}), 404

@app.route('/community_posts/<int:id_post>', methods=['DELETE'])
def delete_community_post(id_post):
    post = CommunityPost.query.get(id_post)
    if post:
        db.session.delete(post)
        db.session.commit()
        return jsonify({"message": "Post deleted"}), 200
    return jsonify({"error": "Post not found"}), 404

@app.route('/community_posts/<int:id_post>/comments', methods=['POST'])
def create_community_post_comment(id_post):
    try:
        data = request.json
        comment = CommunityPostComment(
            id_post=id_post,
            id_account_writer=data['id_account_writer'],
            comment=data['comment'],
            date_added=datetime.utcnow(),
        )

        db.session.add(comment)
        db.session.commit()

        return jsonify({"message": "Comment added", "id_comment": comment.id_comment}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/community_posts/<int:id_post>/comments', methods=['GET'])
def get_community_post_comments(id_post):
    comments = CommunityPostComment.query.filter_by(id_post=id_post).all()
    return jsonify([comment.to_dict() for comment in comments])

@app.route('/community_posts/<int:id_post>/comments/<int:id_comment>', methods=['PUT'])
def update_community_post_comment(id_post, id_comment):
    comment = CommunityPostComment.query.get(id_comment)
    if comment:
        data = request.json
        comment.comment = data['comment']
        comment.date_edited = datetime.utcnow()

        db.session.commit()

        return jsonify({"message": "Comment updated"}), 200
    return jsonify({"error": "Comment not found"}), 404

@app.route('/community_posts/<int:id_post>/reactions', methods=['POST'])
def create_community_post_reaction(id_post):
    try:
        data = request.json
        reaction = CommunityPostReaction(
            id_post=id_post,
            id_account=data['id_account'],
            reaction=Reaction[data['reaction'].upper()]
        )

        db.session.add(reaction)
        db.session.commit()

        return jsonify({"message": "Reaction added", "id_post": reaction.id_post}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400
    
@app.route('/community_posts/<int:id_post>/reactions', methods=['GET'])
def get_community_post_reactions(id_post):
    reactions = CommunityPostReaction.query.filter_by(id_post=id_post).all()
    return jsonify([reaction.to_dict() for reaction in reactions])

@app.route('/community_posts/<int:id_post>/comments/<int:id_comment>/reactions', methods=['POST'])
def create_community_post_comment_reaction(id_post, id_comment):
    try:
        data = request.json
        reaction = CommunityPostCommentReaction(
            id_comment=id_comment,
            id_account=data['id_account'],
            reaction=Reaction[data['reaction'].upper()]
        )

        db.session.add(reaction)
        db.session.commit()

        return jsonify({"message": "Reaction added", "id_comment": reaction.id_comment}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400
@app.route('/community_posts/<int:id_post>/comments/<int:id_comment>/reactions', methods=['GET'])
def get_community_post_comment_reactions(id_post, id_comment):
    reactions = CommunityPostCommentReaction.query.filter_by(id_comment=id_comment).all()
    return jsonify([reaction.to_dict() for reaction in reactions])
@app.route('/community_posts/<int:id_post>/comments/<int:id_comment>/reactions/<int:id_account>', methods=['DELETE'])
def delete_community_post_comment_reaction(id_post, id_comment, id_account):
    reaction = CommunityPostCommentReaction.query.filter_by(id_post=id_post, id_comment=id_comment, id_account=id_account).first()
    if reaction:
        db.session.delete(reaction)
        db.session.commit()
        return jsonify({"message": "Reaction deleted"}), 200
    return jsonify({"error": "Reaction not found"}), 404
@app.route('/community_posts/<int:id_post>/reactions/<int:id_account>', methods=['DELETE'])
def delete_community_post_reaction(id_post, id_account):
    reaction = CommunityPostReaction.query.filter_by(id_post=id_post, id_account=id_account).first()
    if reaction:
        db.session.delete(reaction)
        db.session.commit()
        return jsonify({"message": "Reaction deleted"}), 200
    return jsonify({"error": "Reaction not found"}), 404
@app.route('/community_posts/<int:id_post>/comments/<int:id_comment>', methods=['DELETE'])
def delete_community_post_comment(id_post, id_comment):
    comment = CommunityPostComment.query.get(id_comment)
    if comment:
        db.session.delete(comment)
        db.session.commit()
        return jsonify({"message": "Comment deleted"}), 200
    return jsonify({"error": "Comment not found"}), 404
