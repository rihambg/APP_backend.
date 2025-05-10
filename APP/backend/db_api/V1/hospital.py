from flask import Blueprint, request, jsonify
from db_api.V1._connect_db import  db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('hospital_routes', __name__)

# Model for Hospital
class Hospital(db.Model):
    __tablename__ = "hospitals"
    
    id_hospital = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name_hospital = db.Column(db.String(255), nullable=False)
    postal_code = db.Column(db.String(20), nullable=False)
    street = db.Column(db.String(255), nullable=False)
    id_location = db.Column(db.Integer, db.ForeignKey('locations.id_location'), nullable=False)


    def __repr__(self):
        return f"<Hospital {self.id_hospital}>"

    def to_dict(self):
        return {
            "id_hospital": self.id_hospital,
            "name_hospital": self.name_hospital,
            "postal_code": self.postal_code,
            "street": self.street,
            "id_location": self.id_location
        }

# Routes

@app.route('/hospitals', methods=['GET'])
def get_all_hospitals():
    hospitals = Hospital.query.all()
    return jsonify([hospital.to_dict() for hospital in hospitals])

@app.route('/hospitals/<int:id_hospital>', methods=['GET'])
def get_hospital(id_hospital):
    hospital = Hospital.query.get(id_hospital)
    if hospital:
        return jsonify(hospital.to_dict())
    return jsonify({"error": "Hospital not found"}), 404

@app.route('/hospitals', methods=['POST'])
def create_hospital():
    try:
        data = request.json
        hospital = Hospital(
            name_hospital=data['name_hospital'],
            postal_code=data['postal_code'],
            street=data['street'],
            id_location=data['id_location'],
        )

        db.session.add(hospital)
        db.session.commit()

        return jsonify({"message": "Hospital added", "id_hospital": hospital.id_hospital}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400


@app.route('/hospitals/<int:id_hospital>', methods=['PUT'])
def update_hospital(id_hospital):
    hospital = Hospital.query.get(id_hospital)
    if hospital:
        data = request.json
        hospital.name_hospital = data['name_hospital']
        hospital.postal_code = data['postal_code']
        hospital.street = data['street']
        hospital.id_location = data['id_location']

        db.session.commit()

        return jsonify({"message": "Hospital updated"}), 200
    return jsonify({"error": "Hospital not found"}), 404

@app.route('/hospitals/<int:id_hospital>', methods=['DELETE'])
def delete_hospital(id_hospital):
    hospital = Hospital.query.get(id_hospital)
    if hospital:
        db.session.delete(hospital)
        db.session.commit()
        return jsonify({"message": "Hospital deleted"}), 200
    return jsonify({"error": "Hospital not found"}), 404
