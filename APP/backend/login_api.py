#login_api.py
from flask import Blueprint, request, jsonify
from flask_cors import CORS
from werkzeug.security import check_password_hash
import mysql.connector
from datetime import datetime

login_bp = Blueprint('login', __name__)
CORS(login_bp)

def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="diabetes_management_app"
    )

@login_bp.route("/login", methods=["POST"])
def login():
    data = request.json
    username_or_email = data.get("username_or_email")
    password = data.get("password")

    if not all([username_or_email, password]):
        return jsonify({"error": "Missing username/email or password"}), 400

    try:
        db = connect_db()
        cursor = db.cursor(dictionary=True)

        cursor.execute("""
            SELECT * FROM users 
            WHERE username = %s OR email = %s
        """, (username_or_email, username_or_email))

        user = cursor.fetchone()

        if not user:
            return jsonify({"error": "User not found"}), 404

        if not check_password_hash(user['password_hash'], password):
            return jsonify({"error": "Invalid password"}), 401

        if user['user_type'] == 'doctor':
            cursor.execute("SELECT * FROM doctors WHERE user_id = %s", (user['user_id'],))
            doctor = cursor.fetchone()
            user.update({
                "specialization": doctor['specialization'],
                "license_number": doctor['license_number'],
                "hospital": doctor['hospital_clinic_name'],
                "doctor_id": doctor['doctor_id']
            })

        cursor.close()
        db.close()

        return jsonify({
            "success": True,
            "user_id": user['user_id'],
            "username": user['username'],
            "full_name": user['full_name'],
            "user_type": user['user_type'],
            "is_doctor": user['user_type'] == 'doctor',
            "doctor_id": user.get('doctor_id')
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@login_bp.route('/doctor/<int:doctor_id>/patients', methods=['GET'])
def get_doctor_patients(doctor_id):
    try:
        db = connect_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT 
                p.patient_id, 
                u.full_name, 
                p.diabetes_type, 
                p.last_reading, 
                u.date_of_birth,
                (SELECT MAX(measured_at) FROM blood_sugar_records 
                WHERE patient_id = p.patient_id) as last_checkup,
                (SELECT blood_sugar_level FROM blood_sugar_records 
                WHERE patient_id = p.patient_id 
                ORDER BY measured_at DESC LIMIT 1) as latest_reading
            FROM doctor_patient_relationships dpr
            JOIN patients p ON dpr.patient_id = p.patient_id
            JOIN users u ON p.user_id = u.user_id
            WHERE dpr.doctor_id = %s AND dpr.is_active = TRUE
        """, (doctor_id,))
        
        patients = cursor.fetchall()
        
        for patient in patients:
            if patient['date_of_birth']:
                birth_date = patient['date_of_birth']
                age = (datetime.now().date() - birth_date).days // 365
                patient['age'] = age
            
            patient['last_reading'] = patient['last_reading'] or patient['latest_reading'] or 0
            patient['diabetes_type'] = patient['diabetes_type'] or 'Unknown'
        
        cursor.close()
        db.close()
        return jsonify(patients), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@login_bp.route('/articles', methods=['GET'])
def get_articles():
    try:
        db = connect_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT 
                a.article_id,
                a.title,
                a.content,
                a.pdf_path,
                DATE_FORMAT(a.publish_date, '%%Y-%%m-%%d') as publish_date,
                u.full_name as author_name,
                d.specialization,
                COALESCE(a.summary, '') as summary
            FROM articles a
            JOIN doctors d ON a.doctor_id = d.doctor_id
            JOIN users u ON d.user_id = u.user_id
            WHERE a.is_published = TRUE
            ORDER BY a.publish_date DESC
        """)
        
        articles = cursor.fetchall()
        
        cursor.close()
        db.close()
        
        # Ensure all fields have values
        for article in articles:
            article['content'] = article['content'] or ''
            article['pdf_path'] = article['pdf_path'] or ''
        
        return jsonify(articles), 200
        
    except Exception as e:
        print(f"Database error: {str(e)}")
        return jsonify({"error": "Failed to load articles"}), 500