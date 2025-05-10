from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('blood_sugar_routes', __name__)



# Enums
class BloodSugarType(Enum):
    FASTING = "fasting"
    AFTER_MEAL = "after_meal"

# Model for BloodSugarRecord
class BloodSugarRecord(db.Model):
    __tablename__ = "blood_sugar_records"

    id_record = db.Column(db.Integer, primary_key=True)
    id_account_patient = db.Column(db.Integer, nullable=False)
    date_time = db.Column(db.DateTime, nullable=False)
    level = db.Column(db.Float, nullable=False)
    record_type = db.Column(db.Enum(BloodSugarType,  values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"<BloodSugarRecord {self.id_record}>"

    def to_dict(self):
        return {
            "id_record": self.id_record,
            "id_account_patient": self.id_account_patient,
            "date_time": self.date_time.isoformat(),
            "level": self.level,
            "record_type": self.record_type.value
        }

# Routes
@app.route('/blood_sugar_records', methods=['POST'])
def create_blood_sugar_record():
    try:
        data = request.json
        record = BloodSugarRecord(
            id_account_patient=data['id_account_patient'],
            date_time=data['date_time'],
            level=data['level'],
            record_type=BloodSugarType(data['record_type'])
        )

        db.session.add(record)
        db.session.commit()

        return jsonify({"message": "Blood sugar record added", "id_record": record.id_record}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/blood_sugar_records', methods=['GET'])
def get_all_blood_sugar_records():
    records = BloodSugarRecord.query.all()
    return jsonify([record.to_dict() for record in records])

@app.route('/blood_sugar_records/<int:id_record>', methods=['GET'])
def get_blood_sugar_record(id_record):
    record = BloodSugarRecord.query.get(id_record)
    if record:
        return jsonify(record.to_dict())
    return jsonify({"error": "Blood sugar record not found"}), 404

@app.route('/blood_sugar_records/<int:id_record>', methods=['PUT'])
def update_blood_sugar_record(id_record):
    record = BloodSugarRecord.query.get(id_record)
    if record:
        data = request.json
        record.id_account_patient = data['id_account_patient']
        record.date_time = data['date_time']
        record.level = data['level']
        record.record_type = BloodSugarType(data['record_type'])

        db.session.commit()

        return jsonify({"message": "Blood sugar record updated"}), 200
    return jsonify({"error": "Blood sugar record not found"}), 404

@app.route('/blood_sugar_records/<int:id_record>', methods=['DELETE'])
def delete_blood_sugar_record(id_record):
    record = BloodSugarRecord.query.get(id_record)
    if record:
        db.session.delete(record)
        db.session.commit()
        return jsonify({"message": "Blood sugar record deleted"}), 200
    return jsonify({"error": "Blood sugar record not found"}), 404

