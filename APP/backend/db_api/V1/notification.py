from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('notification_routes', __name__)


# Enum for NotificationType
class NotificationType(Enum):
    APPOINTMENT = "appointment"
    PERSPECTION = "perspection"
    MEDICAL = "medical"
    DIET_PLAN = "diet_plan"
    CHALLENGE = "challenge"
    GENERAL = "general"

# Model for Notification
class Notification(db.Model):
    __tablename__ = "notification"
    
    id_notification = db.Column(db.Integer, primary_key=True)
    id_user = db.Column(db.Integer, nullable=False)
    type_notification = db.Column(db.Enum(NotificationType,  values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    message = db.Column(db.String(255), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<Notification {self.id_notification}>"

    def to_dict(self):
        return {
            "id_notification": self.id_notification,
            "id_user": self.id_user,
            "type_notification": self.type_notification.value,
            "message": self.message,
            "timestamp": self.timestamp
        }

# Routes

@app.route('/notifications', methods=['POST'])
def create_notification():
    try:
        data = request.json
        notification = Notification(
            id_user=data['id_user'],
            type_notification=NotificationType[data['type_notification'].upper()],
            message=data['message'],
            timestamp=data['timestamp']
        )

        db.session.add(notification)
        db.session.commit()

        return jsonify({"message": "Notification added", "id_notification": notification.id_notification}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/notifications', methods=['GET'])
def get_all_notifications():
    notifications = Notification.query.all()
    return jsonify([notification.to_dict() for notification in notifications])

@app.route('/notifications/<int:id_notification>', methods=['GET'])
def get_notification(id_notification):
    notification = Notification.query.get(id_notification)
    if notification:
        return jsonify(notification.to_dict())
    return jsonify({"error": "Notification not found"}), 404

@app.route('/notifications/<int:id_notification>', methods=['PUT'])
def update_notification(id_notification):
    notification = Notification.query.get(id_notification)
    if notification:
        data = request.json
        notification.id_user = data['id_user']
        notification.type_notification = NotificationType[data['type_notification'].upper()]
        notification.message = data['message']
        notification.timestamp = data['timestamp']

        db.session.commit()

        return jsonify({"message": "Notification updated"}), 200
    return jsonify({"error": "Notification not found"}), 404

@app.route('/notifications/<int:id_notification>', methods=['DELETE'])
def delete_notification(id_notification):
    notification = Notification.query.get(id_notification)
    if notification:
        db.session.delete(notification)
        db.session.commit()
        return jsonify({"message": "Notification deleted"}), 200
    return jsonify({"error": "Notification not found"}), 404

@app.route('/notifications/user/<int:id_user>', methods=['GET'])
def get_notifications_by_user(id_user):
    notifications = Notification.query.filter_by(id_user=id_user).all()
    return jsonify([notification.to_dict() for notification in notifications])


