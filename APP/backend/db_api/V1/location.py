from flask import Blueprint, request, jsonify
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('location_routes', __name__)

# Model for Location
class Location(db.Model):
    __tablename__ = "locations"
    
    id_location = db.Column(db.Integer, primary_key=True, autoincrement=True)
    address = db.Column(db.String(255), nullable=False)
    latitude = db.Column(db.Float, nullable=False)
    longitude = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f"<Location {self.id_location}>"

    def to_dict(self):
        return {
            "id_location": self.id_location,
            "address": self.address,
            "latitude": self.latitude,
            "longitude": self.longitude
        }

# Routes
@app.route('/locations', methods=['GET'])
def get_all_locations():
    locations = Location.query.all()
    return jsonify([location.to_dict() for location in locations])

@app.route('/locations/<int:id_location>', methods=['GET'])
def get_location(id_location):
    location = Location.query.get(id_location)
    if location:
        return jsonify(location.to_dict())
    return jsonify({"error": "Location not found"}), 404

@app.route('/locations', methods=['POST'])
def create_location():
    try:
        data = request.json
        location = Location(
            address=data['address'],
            latitude=data['latitude'],
            longitude=data['longitude'],
        )

        db.session.add(location)
        db.session.commit()

        return jsonify({"message": "Location added", "id_location": location.id_location}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400



@app.route('/locations/<int:id_location>', methods=['PUT'])
def update_location(id_location):
    location = Location.query.get(id_location)
    if location:
        data = request.json
        location.address = data['address']
        location.latitude = data['latitude']
        location.longitude = data['longitude']

        db.session.commit()

        return jsonify({"message": "Location updated"}), 200
    return jsonify({"error": "Location not found"}), 404

@app.route('/locations/<int:id_location>', methods=['DELETE'])
def delete_location(id_location):
    location = Location.query.get(id_location)
    if location:
        db.session.delete(location)
        db.session.commit()
        return jsonify({"message": "Location deleted"}), 200
    return jsonify({"error": "Location not found"}), 404
