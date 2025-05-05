# login_api.py
from flask import Blueprint, request, jsonify
from flask_cors import CORS
from werkzeug.security import check_password_hash
import mysql.connector
from datetime import datetime
import json

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
        
        for article in articles:
            article['content'] = article['content'] or ''
            article['pdf_path'] = article['pdf_path'] or ''
        
        return jsonify(articles), 200
        
    except Exception as e:
        print(f"Database error: {str(e)}")
        return jsonify({"error": "Failed to load articles"}), 500

@login_bp.route('/blood_sugar', methods=['GET', 'POST'])
def handle_blood_sugar():
    if request.method == 'GET':
        try:
            patient_id = request.args.get('patient_id', type=int)
            if not patient_id:
                return jsonify({"error": "Patient ID required"}), 400

            db = connect_db()
            cursor = db.cursor(dictionary=True)
            
            cursor.execute("""
                SELECT * FROM blood_sugar_readings 
                WHERE patient_id = %s 
                ORDER BY measured_at DESC
                LIMIT 30
            """, (patient_id,))
            
            readings = cursor.fetchall()
            cursor.close()
            db.close()
            
            return jsonify(readings), 200
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.json
            patient_id = data.get('patient_id')
            value = data.get('value')
            reading_type = data.get('reading_type')
            
            if not all([patient_id, value, reading_type]):
                return jsonify({"error": "Missing required fields"}), 400

            db = connect_db()
            cursor = db.cursor()
            
            cursor.execute("""
                INSERT INTO blood_sugar_readings 
                (patient_id, value, reading_type)
                VALUES (%s, %s, %s)
            """, (patient_id, value, reading_type))
            
            db.commit()
            
            cursor.execute("""
                UPDATE patients 
                SET last_reading = %s, last_reading_date = NOW()
                WHERE patient_id = %s
            """, (value, patient_id))
            
            db.commit()
            cursor.close()
            db.close()
            
            return jsonify({"message": "Reading logged successfully"}), 201
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500

@login_bp.route('/activities', methods=['GET', 'POST'])
def handle_activities():
    if request.method == 'GET':
        try:
            patient_id = request.args.get('patient_id', type=int)
            if not patient_id:
                return jsonify({"error": "Patient ID required"}), 400

            db = connect_db()
            cursor = db.cursor(dictionary=True)
            
            cursor.execute("""
                SELECT * FROM activity_logs 
                WHERE patient_id = %s 
                ORDER BY logged_at DESC
                LIMIT 30
            """, (patient_id,))
            
            activities = cursor.fetchall()
            cursor.close()
            db.close()
            
            return jsonify(activities), 200
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.json
            patient_id = data.get('patient_id')
            activity_type = data.get('activity_type')
            duration_minutes = data.get('duration_minutes')
            steps = data.get('steps')
            
            if not all([patient_id, activity_type, duration_minutes]):
                return jsonify({"error": "Missing required fields"}), 400

            calories_per_minute = {
                'walking': 5,
                'running': 10,
                'cycling': 8,
                'swimming': 7,
                'workout': 6
            }.get(activity_type, 5)
            
            calories_burned = calories_per_minute * duration_minutes
            
            db = connect_db()
            cursor = db.cursor()
            
            cursor.execute("""
                INSERT INTO activity_logs 
                (patient_id, activity_type, duration_minutes, steps, calories_burned)
                VALUES (%s, %s, %s, %s, %s)
            """, (patient_id, activity_type, duration_minutes, steps, calories_burned))
            
            db.commit()
            cursor.close()
            db.close()
            
            return jsonify({
                "message": "Activity logged successfully",
                "calories_burned": calories_burned
            }), 201
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500

@login_bp.route('/medications', methods=['GET', 'POST'])
def handle_medications():
    if request.method == 'GET':
        try:
            patient_id = request.args.get('patient_id', type=int)
            if not patient_id:
                return jsonify({"error": "Patient ID required"}), 400

            db = connect_db()
            cursor = db.cursor(dictionary=True)
            
            cursor.execute("""
                SELECT ms.*, 
                (SELECT status FROM medication_logs 
                 WHERE schedule_id = ms.schedule_id 
                 ORDER BY taken_at DESC LIMIT 1) as status
                FROM medication_schedule ms
                WHERE ms.patient_id = %s AND ms.is_active = TRUE
            """, (patient_id,))
            
            medications = cursor.fetchall()
            cursor.close()
            db.close()
            
            return jsonify(medications), 200
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.json
            patient_id = data.get('patient_id')
            medication_name = data.get('medication_name')
            dosage = data.get('dosage')
            frequency = data.get('frequency', 'daily')
            times_per_day = data.get('times_per_day', 1)
            specific_times = data.get('specific_times')
            
            if not all([patient_id, medication_name, dosage]):
                return jsonify({"error": "Missing required fields"}), 400

            db = connect_db()
            cursor = db.cursor()
            
            cursor.execute("""
                INSERT INTO medication_schedule 
                (patient_id, medication_name, dosage, frequency, times_per_day, specific_times)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (patient_id, medication_name, dosage, frequency, times_per_day, specific_times))
            
            db.commit()
            cursor.close()
            db.close()
            
            return jsonify({"message": "Medication added successfully"}), 201
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500

@login_bp.route('/meals', methods=['GET', 'POST'])
def handle_meals():
    if request.method == 'GET':
        try:
            patient_id = request.args.get('patient_id', type=int)
            if not patient_id:
                return jsonify({"error": "Patient ID required"}), 400

            db = connect_db()
            cursor = db.cursor(dictionary=True)
            
            cursor.execute("""
                SELECT ml.*, 
                COALESCE(mr.title, 'Custom Meal') as name
                FROM meal_logs ml
                LEFT JOIN meal_recipes mr ON ml.recipe_id = mr.recipe_id
                WHERE ml.patient_id = %s 
                ORDER BY logged_at DESC
                LIMIT 30
            """, (patient_id,))
            
            meals = cursor.fetchall()
            cursor.close()
            db.close()
            
            return jsonify(meals), 200
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500
            
    elif request.method == 'POST':
        try:
            data = request.json
            patient_id = data.get('patient_id')
            meal_type = data.get('meal_type')
            calories = data.get('calories')
            carbs = data.get('carbs')
            recipe_id = data.get('recipe_id')
            
            if not all([patient_id, meal_type]):
                return jsonify({"error": "Missing required fields"}), 400

            db = connect_db()
            cursor = db.cursor()
            
            if recipe_id:
                cursor.execute("""
                    INSERT INTO meal_logs 
                    (patient_id, meal_type, recipe_id)
                    VALUES (%s, %s, %s)
                """, (patient_id, meal_type, recipe_id))
            else:
                cursor.execute("""
                    INSERT INTO meal_logs 
                    (patient_id, meal_type, calories, carbs)
                    VALUES (%s, %s, %s, %s)
                """, (patient_id, meal_type, calories, carbs))
            
            db.commit()
            cursor.close()
            db.close()
            
            return jsonify({"message": "Meal logged successfully"}), 201
            
        except Exception as e:
            return jsonify({"error": str(e)}), 500

@login_bp.route('/recipes', methods=['GET'])
def get_recipes():
    try:
        db = connect_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT * FROM meal_recipes 
            WHERE is_approved = TRUE
            ORDER BY created_at DESC
        """)
        
        recipes = cursor.fetchall()
        
        for recipe in recipes:
            if recipe['ingredients']:
                recipe['ingredients'] = json.loads(recipe['ingredients'])
        
        cursor.close()
        db.close()
        
        return jsonify(recipes), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@login_bp.route('/patient_details', methods=['GET'])
def get_patient_details():
    try:
        patient_id = request.args.get('patient_id', type=int)
        if not patient_id:
            return jsonify({"error": "Patient ID required"}), 400

        db = connect_db()
        cursor = db.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT p.*, u.date_of_birth, u.gender
            FROM patients p
            JOIN users u ON p.user_id = u.user_id
            WHERE p.patient_id = %s
        """, (patient_id,))
        
        patient = cursor.fetchone()
        
        if not patient:
            return jsonify({"error": "Patient not found"}), 404
        
        if patient['date_of_birth']:
            birth_date = patient['date_of_birth']
            age = (datetime.now().date() - birth_date).days // 365
            patient['age'] = age
        
        cursor.close()
        db.close()
        
        return jsonify(patient), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500