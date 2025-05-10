from datetime import datetime
from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('users_routes', __name__)


# Enum for Doctor Speciality
class DoctorSpeciality(Enum):
    NUTRITIONIST = "Nutritionist"
    CARDIOLOGIST = "Cardiologist"
    ENDOCRINOLOGIST = "Endocrinologist"
    GYNECOLOGIST = "Gynecologist"

# Enum for Diabete Type
class DiabeteType(Enum):
    TYPE_1 = "Type 1"
    TYPE_2 = "Type 2"
    GESTATIONAL = "Gestational"
    PREDIABETES = "Prediabetes"

# Enum for Blood Type
class BloodType(Enum):
    A_POSITIVE = "A+"
    A_NEGATIVE = "A-"
    B_POSITIVE = "B+"
    B_NEGATIVE = "B-"
    AB_POSITIVE = "AB+"
    AB_NEGATIVE = "AB-"
    O_POSITIVE = "O+"
    O_NEGATIVE = "O-"

# Abstract base class for user profiles
class User(db.Model):
    __abstract__ = True
    id_profile = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_account = db.Column(db.Integer, nullable=False)
    first_name = db.Column(db.String(255), nullable=False)
    last_name = db.Column(db.String(255), nullable=False)
    middle_name = db.Column(db.String(255), nullable=True)
    sex = db.Column(db.String(1), nullable=False)  # M or F
    public_phone_number = db.Column(db.String(20), nullable=True)
    public_email = db.Column(db.String(255), nullable=True)

    def __repr__(self):
        return f"User({self.id_profile}, {self.id_account}, {self.first_name}, {self.last_name}, {self.middle_name}, {self.sex}, {self.public_phone_number}, {self.public_email})"

# Model for Patient
class Patient(User):
    __tablename__ = "patients"
    blood_type = db.Column(db.Enum(BloodType, values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    date_birth = db.Column(db.DateTime, nullable=False)
    weight = db.Column(db.Float, nullable=False)
    height = db.Column(db.Float, nullable=False)
    diabete_type = db.Column(db.Enum(DiabeteType, values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"Patient({super().__repr__()}, {self.blood_type}, {self.date_birth}, {self.weight}, {self.height}, {self.diabete_type})"

# Model for Doctor
class Doctor(User):
    __tablename__ = "doctors"
    speciality = db.Column(db.Enum(DoctorSpeciality, values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    location_id = db.Column(db.Integer, nullable=False)
    bio = db.Column(db.String(500), nullable=True)
    id_hospital = db.Column(db.Integer, nullable=False)
    professional_id = db.Column(db.String(100), nullable=False)

    def __repr__(self):
        return f"Doctor({super().__repr__()}, {self.speciality}, {self.location_id}, {self.bio}, {self.id_hospital}, {self.professional_id})"

# Routes
@app.route('/doctors', methods=['GET'])
def get_all_doctors():
    doctors = Doctor.query.all()
    return jsonify([doctor.to_dict() for doctor in doctors])

@app.route('/patients', methods=['GET'])
def get_all_patients():
    patients = Patient.query.all()
    return jsonify([patient.to_dict() for patient in patients])

@app.route('/patients/<int:id_profile>', methods=['GET'])
def get_patient(id_profile):
    patient = Patient.query.get(id_profile)
    if patient:
        return jsonify(patient.to_dict())
    return jsonify({"error": "Patient not found"}), 404

@app.route('/doctors/<int:id_profile>', methods=['GET'])
def get_doctor(id_profile):
    doctor = Doctor.query.get(id_profile)
    if doctor:
        return jsonify(doctor.to_dict())
    return jsonify({"error": "Doctor not found"}), 404

@app.route('/patients', methods=['POST'])
def create_patient():
    try:
        data = request.json
        patient = Patient(
            first_name=data['first_name'],
            last_name=data['last_name'],
            middle_name=data.get('middle_name'),
            sex=data['sex'],
            public_phone_number=data.get('public_phone_number'),
            public_email=data.get('public_email'),
            blood_type=data['blood_type'],
            date_birth=datetime.strptime(data['date_birth'], '%Y-%m-%d'),
            weight=data['weight'],
            height=data['height'],
            diabete_type=data['diabete_type']
        )
        db.session.add(patient)
        db.session.commit()
        return jsonify({"message": "Patient added", "id_profile": patient.id_profile}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/doctors', methods=['POST'])
def create_doctor():
    try:
        data = request.json
        doctor = Doctor(
            first_name=data['first_name'],
            last_name=data['last_name'],
            middle_name=data.get('middle_name'),
            sex=data['sex'],
            public_phone_number=data.get('public_phone_number'),
            public_email=data.get('public_email'),
            speciality=data['speciality'],
            location_id=data['location_id'],
            bio=data.get('bio'),
            id_hospital=data['id_hospital'],
            professional_id=data['professional_id']
        )
        db.session.add(doctor)
        db.session.commit()
        return jsonify({"message": "Doctor added", "id_profile": doctor.id_profile}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/patients/<int:id_profile>', methods=['PUT'])
def update_patient(id_profile):
    patient = Patient.query.get(id_profile)
    if patient:
        data = request.json
        patient.first_name = data['first_name']
        patient.last_name = data['last_name']
        patient.middle_name = data.get('middle_name')
        patient.sex = data['sex']
        patient.public_phone_number = data.get('public_phone_number')
        patient.public_email = data.get('public_email')
        patient.blood_type = data['blood_type']
        patient.date_birth = datetime.strptime(data['date_birth'], '%Y-%m-%d')
        patient.weight = data['weight']
        patient.height = data['height']
        patient.diabete_type = data['diabete_type']
        db.session.commit()
        return jsonify({"message": "Patient updated"}), 200
    return jsonify({"error": "Patient not found"}), 404

@app.route('/doctors/<int:id_profile>', methods=['PUT'])
def update_doctor(id_profile):
    doctor = Doctor.query.get(id_profile)
    if doctor:
        data = request.json
        doctor.first_name = data['first_name']
        doctor.last_name = data['last_name']
        doctor.middle_name = data.get('middle_name')
        doctor.sex = data['sex']
        doctor.public_phone_number = data.get('public_phone_number')
        doctor.public_email = data.get('public_email')
        doctor.speciality = data['speciality']
        doctor.location_id = data['location_id']
        doctor.bio = data.get('bio')
        doctor.id_hospital = data['id_hospital']
        doctor.professional_id = data['professional_id']
        db.session.commit()
        return jsonify({"message": "Doctor updated"}), 200
    return jsonify({"error": "Doctor not found"}), 404


@app.route('/patients/<int:id_profile>', methods=['DELETE'])
def delete_patient(id_profile):
    patient = Patient.query.get(id_profile)
    if patient:
        db.session.delete(patient)
        db.session.commit()
        return jsonify({"message": "Patient deleted"}), 200
    return jsonify({"error": "Patient not found"}), 404


@app.route('/doctors/<int:id_profile>', methods=['DELETE'])
def delete_doctor(id_profile):
    doctor = Doctor.query.get(id_profile)
    if doctor:
        db.session.delete(doctor)
        db.session.commit()
        return jsonify({"message": "Doctor deleted"}), 200
    return jsonify({"error": "Doctor not found"}), 404

