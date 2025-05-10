from datetime import datetime
from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('activity_routes', __name__)

# Optional enum for activity type if needed
class ActivityType(Enum):
    WALKING = "Walking"
    RUNNING = "Running"
    SWIMMING = "Swimming"
    CYCLING = "Cycling"
    OTHER = "Other"

# PhysicalActivity model
class PhysicalActivity(db.Model):
    __tablename__ = "physical_activity"

    id_activity = db.Column(db.Integer, primary_key=True)
    activity_type = db.Column(db.Enum(ActivityType), nullable=False)
    period = db.Column(db.Float, nullable=False)  # duration in minutes, for example
    burned_calories = db.Column(db.Float, nullable=False)
    date_time_activity = db.Column(db.DateTime, default=datetime.utcnow)
    id_diet_plan = db.Column(db.Integer, nullable=False)  # Assuming it links to another table

    def __str__(self):
        return f"PhysicalActivity({self.id_activity}, {self.activity_type}, {self.period}, {self.burned_calories}, {self.date_time_activity}, {self.id_diet_plan})"

    def to_dict(self):
        return {
            "id_activity": self.id_activity,
            "activity_type": self.activity_type.value,
            "period": self.period,
            "burned_calories": self.burned_calories,
            "date_time_activity": self.date_time_activity.isoformat(),
            "id_diet_plan": self.id_diet_plan
        }

# Example route to view all physical activities
@app.route("/activities", methods=["GET"])
def get_activities():
    activities = PhysicalActivity.query.all()
    return jsonify([a.to_dict() for a in activities])

@app.route("/activities/<int:id_activity>", methods=["GET"])
def get_activity(id_activity):
    activity = PhysicalActivity.query.get(id_activity)
    if activity:
        return jsonify(activity.to_dict())
    return jsonify({"error": "Activity not found"}), 404

@app.route("/activities", methods=["POST"])
def create_activity():
    try:
        data = request.json
        activity = PhysicalActivity(
            activity_type=ActivityType[data['activity_type']],
            period=data['period'],
            burned_calories=data['burned_calories'],
            date_time_activity=data['date_time_activity'],
            id_diet_plan=data['id_diet_plan']
        )

        db.session.add(activity)
        db.session.commit()

        return jsonify({"message": "Activity added", "id_activity": activity.id_activity}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400
    
@app.route("/activities/<int:id_activity>", methods=["PUT"])
def update_activity(id_activity):
    activity = PhysicalActivity.query.get(id_activity)
    if activity:
        data = request.json
        activity.activity_type = ActivityType[data['activity_type']]
        activity.period = data['period']
        activity.burned_calories = data['burned_calories']
        activity.date_time_activity = data['date_time_activity']
        activity.id_diet_plan = data['id_diet_plan']

        db.session.commit()
        return jsonify({"message": "Activity updated"}), 200

    return jsonify({"error": "Activity not found"}), 404

@app.route("/activities/<int:id_activity>", methods=["DELETE"])
def delete_activity(id_activity):
    activity = PhysicalActivity.query.get(id_activity)
    if activity:
        db.session.delete(activity)
        db.session.commit()
        return jsonify({"message": "Activity deleted"}), 200

    return jsonify({"error": "Activity not found"}), 404
