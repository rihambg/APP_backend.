from datetime import datetime
from flask import Blueprint, request, jsonify
import enum
from db_api.V1._connect_db import  db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('perspection_routes', __name__)


class MedicalType(enum.Enum):
    INSULIN = "Insulin"
    COMPLEMNTARY = "Complementary"

# Model for Perspection
class Perspection(db.Model):
    __tablename__ = "perspections"
    
    id_perspection = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_account_doctor = db.Column(db.Integer,  db.ForeignKey('doctors.id_profile'), nullable=False, primary_key=True)
    id_appointement = db.Column(db.Integer,  db.ForeignKey('patients.id_profile'), nullable=False, primary_key=True)
    id_account_patient = db.Column(db.Integer, nullable=False)
    description = db.Column(db.Text(), nullable=False)
    code = db.Column(db.String(255), nullable=False)
    date_time = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<Perspection {self.id_perspection}>"

    def to_dict(self):
        return {
            "id_perspection": self.id_perspection,
            "id_account_doctor": self.id_account_doctor,
            "id_appointement": self.id_appointement,
            "id_account_patient": self.id_account_patient,
            "description": self.description,
            "code": self.code,
            "date_time": self.date_time
        }

# Model for Medicals
class Medicals(db.Model):
    __tablename__ = "medicals"
    
    id_medical = db.Column(db.Integer, primary_key=True, autoincrement=True)
    medical_type = db.Column(db.Enum(MedicalType, values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    medical_dose = db.Column(db.String(255), nullable=False)
    medical_name = db.Column(db.String(255), nullable=False)
    medical_description = db.Column(db.Text(), nullable=False)

    def __repr__(self):
        return f"<Medical {self.id_medical}>"

    def to_dict(self):
        return {
            "id_medical": self.id_medical,
            "medical_dose": self.medical_dose,
            "medical_name": self.medical_name,
            "medical_description": self.medical_description
        }

# Model for PerspectionMedical
class PerspectionMedical(db.Model):
    __tablename__ = "perspection_medical"
    
    id_perspection = db.Column(db.Integer, db.ForeignKey('perspections.id_perspection'), primary_key=True)
    id_medical = db.Column(db.Integer, db.ForeignKey('medicals.id_medical'), primary_key=True)
    frequency = db.Column(db.String(255), nullable=False)
    date_start = db.Column(db.DateTime, nullable=False)
    date_end = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<PerspectionMedical {self.id_perspection}, {self.id_medical}>"

    def to_dict(self):
        return {
            "id_perspection": self.id_perspection,
            "id_medical": self.id_medical,
            "frequency": self.frequency,
            "date_start": self.date_start,
            "date_end": self.date_end
        }

# Routes
@app.route('/perspections', methods=['GET'])
def get_all_perspections():
    perspections = Perspection.query.all()
    return jsonify([perspection.to_dict() for perspection in perspections])

@app.route('/medicals', methods=['GET'])
def get_all_medicals():
    medicals = Medicals.query.all()
    return jsonify([medical.to_dict() for medical in medicals])

@app.route('/perspection_medicals', methods=['GET'])
def get_all_perspection_medicals():
    perspection_medicals = PerspectionMedical.query.all()
    return jsonify([perspection_medical.to_dict() for perspection_medical in perspection_medicals])

@app.route('/perspections', methods=['POST'])
def create_perspection():
    try:
        data = request.json
        perspection = Perspection(
            id_account_doctor=data['id_account_doctor'],
            id_appointement=data['id_appointement'],
            id_account_patient=data['id_account_patient'],
            description=data['description'],
            code=data['code'],
            date_time=datetime.strptime(data['date_time'], '%Y-%m-%d %H:%M:%S')
        )

        db.session.add(perspection)
        db.session.commit()

        return jsonify({"message": "Perspection added", "id_perspection": perspection.id_perspection}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/medicals', methods=['POST'])
def create_medical():
    try:
        data = request.json
        medical = Medicals(
            medical_dose=data['medical_dose'],
            medical_type=data['medical_type'],
            medical_name=data['medical_name'],
            medical_description=data['medical_description']
        )

        db.session.add(medical)
        db.session.commit()

        return jsonify({"message": "Medical added", "id_medical": medical.id_medical}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/perspection_medicals', methods=['POST'])
def create_perspection_medical():
    try:
        data = request.json
        perspection_medical = PerspectionMedical(
            id_perspection=data['id_perspection'],
            id_medical=data['id_medical'],
            frequency=data['frequency'],
            date_start=datetime.strptime(data['date_start'], '%Y-%m-%d %H:%M:%S'),
            date_end=datetime.strptime(data['date_end'], '%Y-%m-%d %H:%M:%S')
        )

        db.session.add(perspection_medical)
        db.session.commit()

        return jsonify({"message": "PerspectionMedical added", "id_perspection_medical": perspection_medical.id_perspection}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/perspections/<int:id_perspection>', methods=['PUT'])
def update_perspection(id_perspection):
    perspection = Perspection.query.get(id_perspection)
    if perspection:
        data = request.json
        perspection.id_account_doctor = data['id_account_doctor']
        perspection.id_appointement = data['id_appointement']
        perspection.id_account_patient = data['id_account_patient']
        perspection.description = data['description']
        perspection.code = data['code']
        perspection.date_time = datetime.strptime(data['date_time'], '%Y-%m-%d %H:%M:%S')

        db.session.commit()

        return jsonify({"message": "Perspection updated"}), 200
    return jsonify({"error": "Perspection not found"}), 404

@app.route('/medicals/<int:id_medical>', methods=['PUT'])
def update_medical(id_medical):
    medical = Medicals.query.get(id_medical)
    if medical:
        data = request.json
        medical.medical_dose = data['medical_dose']
        medical.medical_type = data['medical_type']
        medical.medical_name = data['medical_name']
        medical.medical_description = data['medical_description']

        db.session.commit()

        return jsonify({"message": "Medical updated"}), 200
    return jsonify({"error": "Medical not found"}), 404

@app.route('/perspection_medicals/<int:id_perspection>/<int:id_medical>', methods=['PUT'])
def update_perspection_medical(id_perspection, id_medical):
    perspection_medical = PerspectionMedical.query.get((id_perspection, id_medical))
    if perspection_medical:
        data = request.json
        perspection_medical.frequency = data['frequency']
        perspection_medical.date_start = datetime.strptime(data['date_start'], '%Y-%m-%d %H:%M:%S')
        perspection_medical.date_end = datetime.strptime(data['date_end'], '%Y-%m-%d %H:%M:%S')

        db.session.commit()

        return jsonify({"message": "PerspectionMedical updated"}), 200
    return jsonify({"error": "PerspectionMedical not found"}), 404

@app.route('/perspections/<int:id_perspection>', methods=['DELETE'])
def delete_perspection(id_perspection):
    perspection = Perspection.query.get(id_perspection)
    if perspection:
        db.session.delete(perspection)
        db.session.commit()
        return jsonify({"message": "Perspection deleted"}), 200
    return jsonify({"error": "Perspection not found"}), 404

@app.route('/medicals/<int:id_medical>', methods=['DELETE'])
def delete_medical(id_medical):
    medical = Medicals.query.get(id_medical)
    if medical:
        db.session.delete(medical)
        db.session.commit()
        return jsonify({"message": "Medical deleted"}), 200
    return jsonify({"error": "Medical not found"}), 404

@app.route('/perspection_medicals/<int:id_perspection>/<int:id_medical>', methods=['DELETE'])
def delete_perspection_medical(id_perspection, id_medical):
    perspection_medical = PerspectionMedical.query.get((id_perspection, id_medical))
    if perspection_medical:
        db.session.delete(perspection_medical)
        db.session.commit()
        return jsonify({"message": "PerspectionMedical deleted"}), 200
    return jsonify({"error": "PerspectionMedical not found"}), 404

