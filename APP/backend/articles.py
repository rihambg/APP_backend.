# articles.py (Flask Blueprint)
import os
from flask import Blueprint, request, jsonify
from werkzeug.utils import secure_filename
import json
from datetime import datetime
import mysql.connector
from mysql.connector import Error

articles_bp = Blueprint('articles', __name__)

# Configure upload folder
UPLOAD_FOLDER = 'uploads/pdfs'
ALLOWED_EXTENSIONS = {'pdf'}
os.makedirs(UPLOAD_FOLDER, exist_ok=True)  # Ensure directory exists

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="",
            database="diabetes_management_app"
        )
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

@articles_bp.route('/articles', methods=['GET'])
def get_articles():
    try:
        connection = get_db_connection()
        if connection is None:
            return jsonify({"error": "Database connection failed"}), 500
            
        cursor = connection.cursor(dictionary=True)
        
        query = """
        SELECT 
            a.article_id, a.title, a.content, a.pdf_path, 
            a.publish_date, a.categories, a.is_published,
            u.full_name AS author_name,
            d.doctor_id
        FROM articles a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN users u ON d.user_id = u.user_id
        WHERE a.is_published = 1
        ORDER BY a.publish_date DESC
        """
        cursor.execute(query)
        result = cursor.fetchall()
        
        articles = []
        for row in result:
            article = dict(row)
            article['categories'] = json.loads(article['categories']) if article['categories'] else []
            article['publish_date'] = article['publish_date'].isoformat() if article['publish_date'] else None
            articles.append(article)
            
        cursor.close()
        connection.close()
        return jsonify(articles), 200
        
    except Exception as e:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
        return jsonify({"error": str(e)}), 500

@articles_bp.route('/articles/doctor/<int:doctor_id>', methods=['GET'])
def get_doctor_articles(doctor_id):
    try:
        connection = get_db_connection()
        if connection is None:
            return jsonify({"error": "Database connection failed"}), 500
            
        cursor = connection.cursor(dictionary=True)
        
        query = """
        SELECT 
            a.article_id, a.title, a.content, a.pdf_path, 
            a.publish_date, a.categories, a.is_published,
            u.full_name AS author_name
        FROM articles a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN users u ON d.user_id = u.user_id
        WHERE a.doctor_id = %s
        ORDER BY a.publish_date DESC
        """
        cursor.execute(query, (doctor_id,))
        result = cursor.fetchall()
        
        articles = []
        for row in result:
            article = dict(row)
            article['categories'] = json.loads(article['categories']) if article['categories'] else []
            article['publish_date'] = article['publish_date'].isoformat() if article['publish_date'] else None
            articles.append(article)
            
        cursor.close()
        connection.close()
        return jsonify(articles), 200
        
    except Exception as e:
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
        return jsonify({"error": str(e)}), 500

@articles_bp.route('/articles', methods=['POST'])
def create_article():
    try:
        # Check if the post request has the file part
        if 'pdf' not in request.files:
            return jsonify({"error": "No file part"}), 400
            
        file = request.files['pdf']
        
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
            
        if not (file and allowed_file(file.filename)):
            return jsonify({"error": "Invalid file type"}), 400

        connection = get_db_connection()
        if connection is None:
            return jsonify({"error": "Database connection failed"}), 500
            
        cursor = connection.cursor(dictionary=True)

        # Secure filename and save
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = secure_filename(f"{timestamp}_{file.filename}")
        filepath = os.path.join(UPLOAD_FOLDER, filename)
        file.save(filepath)
        
        # Get form data
        data = request.form
        title = data.get('title')
        content = data.get('content', '')
        doctor_id = data.get('doctor_id')
        categories = data.get('categories', '[]')
        
        # Validate required fields
        if not all([title, doctor_id]):
            return jsonify({"error": "Missing required fields"}), 400
            
        # Insert into database
        query = """
        INSERT INTO articles 
        (title, content, pdf_path, doctor_id, categories, is_published, publish_date)
        VALUES (%s, %s, %s, %s, %s, 1, NOW())
        """
        cursor.execute(
            query,
            (title, content, f"/pdfs/{filename}", doctor_id, categories)
        )
        connection.commit()
        
        # Get the newly created article ID
        article_id = cursor.lastrowid
        
        # Get the full article with author info
        article_query = """
        SELECT 
            a.article_id, a.title, a.content, a.pdf_path, 
            a.publish_date, a.categories, a.is_published,
            u.full_name AS author_name,
            d.doctor_id
        FROM articles a
        JOIN doctors d ON a.doctor_id = d.doctor_id
        JOIN users u ON d.user_id = u.user_id
        WHERE a.article_id = %s
        """
        cursor.execute(article_query, (article_id,))
        new_article = dict(cursor.fetchone())
        new_article['categories'] = json.loads(new_article['categories']) if new_article['categories'] else []
        new_article['publish_date'] = new_article['publish_date'].isoformat() if new_article['publish_date'] else None
        
        cursor.close()
        connection.close()
        return jsonify(new_article), 201
        
    except Exception as e:
        if 'connection' in locals() and connection.is_connected():
            connection.rollback()
            cursor.close()
            connection.close()
        return jsonify({"error": str(e)}), 500