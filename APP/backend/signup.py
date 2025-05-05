# signup.py
from flask import Blueprint, request, jsonify
from flask_cors import CORS
from werkzeug.security import generate_password_hash
import mysql.connector
from datetime import datetime
from werkzeug.utils import secure_filename
import os
import json

signup_bp = Blueprint('signup', __name__)
CORS(signup_bp)

def connect_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="diabetes_management_app"
    )

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ['pdf']

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
        data = request.form.to_dict()
        user_id = data.get("user_id")
        
        required_fields = [
            "phone_number", "experience_years", "license_number",
            "hospital_clinic_name", "country", "city"
        ]
        
        if not all(field in data for field in required_fields):
            return jsonify({"error": "Missing required fields"}), 400

        db = connect_db()
        cursor = db.cursor()

        # Handle base64 document if provided
        document_path = None
        document_base64 = request.form.get("document_base64")
        if document_base64:
            try:
                # Decode base64 and save as PDF
                import base64
                pdf_data = base64.b64decode(document_base64.split(',')[-1])
                filename = f"doctor_{user_id}_document.pdf"
                uploads_dir = os.path.join(os.getcwd(), 'uploads', 'pdfs')
                os.makedirs(uploads_dir, exist_ok=True)
                filepath = os.path.join(uploads_dir, filename)
                with open(filepath, 'wb') as f:
                    f.write(pdf_data)
                document_path = f"/pdfs/{filename}"
            except Exception as e:
                print(f"Error saving document: {str(e)}")
                return jsonify({"error": "Invalid document format"}), 400

        # Update database
        cursor.execute("""
            UPDATE users 
            SET phone_number = %s
            WHERE user_id = %s
        """, (data["phone_number"], user_id))

        cursor.execute("""
            UPDATE doctors 
            SET specialization = %s, license_number = %s, 
                experience_years = %s, hospital_clinic_name = %s,
                country = %s, city = %s,
                document_path = %s, verified = FALSE
            WHERE user_id = %s
        """, (
            data.get("specialization", "General Practitioner"),
            data["license_number"],
            data["experience_years"],
            data["hospital_clinic_name"],
            data["country"],
            data["city"],
            document_path,
            user_id
        ))

        db.commit()
        return jsonify({"message": "Doctor profile completed successfully"}), 200

    except Exception as e:
        print(f"Error in doctor profile completion: {str(e)}")
        return jsonify({"error": "Server error"}), 500
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'db' in locals():
            db.close()

@signup_bp.route("/complete-patient-profile", methods=["POST"])
def complete_patient_profile():
    data = request.json
    user_id = data.get("user_id")
    
    required_fields = [
        "gender", "date_of_birth", "phone_number", 
        "diabetes_type", "height", "weight",
        "emergency_contact_name", "emergency_contact_phone",
        "allergies", "other_conditions", "medications",
        "pregnancy_status", "sugar_intake", "diet_type",
        "exercise_frequency", "smoking", "alcohol",
        "goals", "reminder_frequency"
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
                emergency_contact_name = %s, emergency_contact_phone = %s,
                allergies = %s, other_conditions = %s, medications = %s,
                pregnancy_status = %s, sugar_intake = %s, diet_type = %s,
                exercise_frequency = %s, smoking = %s, alcohol = %s,
                goals = %s, reminder_frequency = %s
            WHERE user_id = %s
        """, (
            data["diabetes_type"],
            data["height"],
            data["weight"],
            data["emergency_contact_name"],
            data["emergency_contact_phone"],
            json.dumps(data["allergies"]) if isinstance(data["allergies"], list) else data["allergies"],
            json.dumps(data["other_conditions"]) if isinstance(data["other_conditions"], list) else data["other_conditions"],
            json.dumps(data["medications"]) if isinstance(data["medications"], list) else data["medications"],
            data["pregnancy_status"],
            data["sugar_intake"],
            data["diet_type"],
            data["exercise_frequency"],
            data["smoking"],
            data["alcohol"],
            json.dumps(data["goals"]) if isinstance(data["goals"], list) else data["goals"],
            data["reminder_frequency"],
            user_id
        ))

        db.commit()
        cursor.close()
        db.close()

        return jsonify({"message": "Patient profile completed successfully"}), 200

    except Exception as e:
        print(f"Error completing patient profile: {str(e)}")
        return jsonify({"error": str(e)}), 500