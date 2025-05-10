from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('appointement_routes', __name__)



# Enums
class AppointementType(Enum):
    IN_PERSON = "in_person"
    VIDEO_CALL = "video_call"
    PHONE_CALL = "phone_call"

class AppointementStatus(Enum):
    PENDING = "pending"
    CONFIRMED = "confirmed"
    CANCELLED = "cancelled"
    COMPLETED = "completed"

# Model
class Appointment(db.Model):
    __tablename__ = "appointments"

    id_appointement = db.Column(db.Integer, primary_key=True)
    appointement_type = db.Column(db.Enum(AppointementType,  values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    date_time = db.Column(db.DateTime, nullable=False)
    doctor_id = db.Column(db.Integer, nullable=False)
    patient_id = db.Column(db.Integer, nullable=False)
    appointement_status = db.Column(db.Enum(AppointementStatus,  values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"<Appointment {self.id_appointement}>"

    def to_dict(self):
        return {
            "id_appointement": self.id_appointement,
            "appointement_type": self.appointement_type.value,
            "date_time": self.date_time.isoformat(),
            "doctor_id": self.doctor_id,
            "patient_id": self.patient_id,
            "appointement_status": self.appointement_status.value
        }

# Routes
@app.route('/appointments', methods=['POST'])
def create_appointment():
    try:
        data = request.json
        appointment = Appointment(
            appointement_type=AppointementType(data['appointement_type']),
            date_time=data['date_time'],
            doctor_id=data['doctor_id'],
            patient_id=data['patient_id'],
            appointement_status=AppointementStatus(data['appointement_status'])
        )

        db.session.add(appointment)
        db.session.commit()

        return jsonify({"message": "Appointment added", "id_appointement": appointment.id_appointement}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/appointments', methods=['GET'])
def get_all_appointments():
    appointments = Appointment.query.all()
    return jsonify([appointment.to_dict() for appointment in appointments])

@app.route('/appointments/<int:id_appointement>', methods=['GET'])
def get_appointment(id_appointement):
    appointment = Appointment.query.get(id_appointement)
    if appointment:
        return jsonify(appointment.to_dict())
    return jsonify({"error": "Appointment not found"}), 404

@app.route('/appointments/<int:id_appointement>', methods=['PUT'])
def update_appointment(id_appointement):
    appointment = Appointment.query.get(id_appointement)
    if appointment:
        data = request.json
        appointment.appointement_type = AppointementType(data['appointement_type'])
        appointment.date_time = data['date_time']
        appointment.doctor_id = data['doctor_id']
        appointment.patient_id = data['patient_id']
        appointment.appointement_status = AppointementStatus(data['appointement_status'])

        db.session.commit()

        return jsonify({"message": "Appointment updated"}), 200
    return jsonify({"error": "Appointment not found"}), 404

@app.route('/appointments/<int:id_appointement>', methods=['DELETE'])
def delete_appointment(id_appointement):
    appointment = Appointment.query.get(id_appointement)
    if appointment:
        db.session.delete(appointment)
        db.session.commit()
        return jsonify({"message": "Appointment deleted"}), 200
    return jsonify({"error": "Appointment not found"}), 404

