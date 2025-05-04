#signup.py 
from flask import Blueprint, request, jsonify
from flask_cors import CORS
from werkzeug.security import generate_password_hash
import mysql.connector
from datetime import datetime
from werkzeug.utils import secure_filename
import os


signup_bp = Blueprint('signup', __name__)
CORS(signup_bp)

def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="diabetes_management_app"
    )

@signup_bp.route("/signup", methods=["POST"])
def signup():
    data = request.json
    username = data.get("username")
    email = data.get("email")
    password = data.get("password")
    full_name = data.get("full_name")
    user_type = data.get("user_type")

    if not all([username, email, password, user_type]):
        return jsonify({"error": "Missing required fields"}), 400

    if user_type.lower() not in ['patient', 'doctor']:
        return jsonify({"error": "Invalid user type"}), 400

    hashed_password = generate_password_hash(password)

    try:
        db = connect_db()
        cursor = db.cursor()

        cursor.execute("""
            INSERT INTO users (username, email, password_hash, full_name, user_type)
            VALUES (%s, %s, %s, %s, %s)
        """, (username, email, hashed_password, full_name, user_type.lower()))

        user_id = cursor.lastrowid

        if user_type.lower() == 'patient':
            cursor.execute("""
                INSERT INTO patients (user_id)
                VALUES (%s)
            """, (user_id,))
        elif user_type.lower() == 'doctor':
            cursor.execute("""
                INSERT INTO doctors (user_id)
                VALUES (%s)
            """, (user_id,))

        db.commit()
        cursor.close()
        db.close()

        return jsonify({
            "message": "Initial user created",
            "user_id": user_id,
            "user_type": user_type.lower()
        }), 201

    except mysql.connector.IntegrityError as e:
        return jsonify({"error": "Username or email already exists"}), 409
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@signup_bp.route("/complete-doctor-profile", methods=["POST"])
def complete_doctor_profile():
    try:
        # Handle both form data and file upload
        data = request.form.to_dict()
        user_id = data.get("user_id")
        
        required_fields = [
            "gender", "date_of_birth", "phone_number", 
            "specialization", "license_number", "experience_years",
            "hospital_clinic_name"
        ]
        
        if not all(field in data for field in required_fields):
            return jsonify({"error": "Missing required fields"}), 400

        db = connect_db()
        cursor = db.cursor()

        # File handling
        document_path = None
        if 'document' in request.files:
            file = request.files['document']
            if file and file.filename != '':
                if not allowed_file(file.filename):
                    return jsonify({"error": "Invalid file type"}), 400
                
                filename = secure_filename(file.filename)
                filepath = os.path.join('uploads', 'pdfs', filename)
                os.makedirs(os.path.dirname(filepath), exist_ok=True)
                file.save(filepath)
                document_path = f"/pdfs/{filename}"

        # Update database
        cursor.execute("""
            UPDATE users 
            SET gender = %s, date_of_birth = %s, phone_number = %s
            WHERE user_id = %s
        """, (
            data["gender"],
            datetime.strptime(data["date_of_birth"], "%d/%m/%Y").date(),
            data["phone_number"],
            user_id
        ))

        cursor.execute("""
            UPDATE doctors 
            SET specialization = %s, license_number = %s, 
                experience_years = %s, hospital_clinic_name = %s,
                document_path = %s
            WHERE user_id = %s
        """, (
            data["specialization"],
            data["license_number"],
            data["experience_years"],
            data["hospital_clinic_name"],
            document_path,
            user_id
        ))

        db.commit()
        return jsonify({"message": "Doctor profile completed successfully"}), 200

    except Exception as e:
        print(f"Error in doctor profile completion: {str(e)}")
        return jsonify({"error": "Server error"}), 500
    finally:
        cursor.close()
        db.close()

@signup_bp.route("/complete-patient-profile", methods=["POST"])
def complete_patient_profile():
    data = request.json
    user_id = data.get("user_id")
    
    required_fields = [
        "gender", "date_of_birth", "phone_number", 
        "diabetes_type", "height", "weight",
        "emergency_contact_name", "emergency_contact_phone"
    ]
    
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    try:
        db = connect_db()
        cursor = db.cursor()

        cursor.execute("""
            UPDATE users 
            SET gender = %s, date_of_birth = %s, phone_number = %s
            WHERE user_id = %s
        """, (
            data["gender"],
            datetime.strptime(data["date_of_birth"], "%d/%m/%Y").date(),
            data["phone_number"],
            user_id
        ))

        cursor.execute("""
            UPDATE patients 
            SET diabetes_type = %s, height = %s, weight = %s,
                emergency_contact_name = %s, emergency_contact_phone = %s
            WHERE user_id = %s
        """, (
            data["diabetes_type"],
            data["height"],
            data["weight"],
            data["emergency_contact_name"],
            data["emergency_contact_phone"],
            user_id
        ))

        db.commit()
        cursor.close()
        db.close()

        return jsonify({"message": "Patient profile completed successfully"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500