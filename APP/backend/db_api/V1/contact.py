from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance
from datetime import datetime  # Import datetime for date and time handling


# Create a Blueprint for your routes
app = Blueprint('contact_routes', __name__)


# Enums
class ContactStatus(Enum):
    PENDING = "Pending"
    ACCEPTED = "Accepted"
    BLOCKED = "Blocked"

class MessageStatus(Enum):
    SENT = "Sent"
    DELIVERED = "Delivered"
    READ = "Read"
    FAILED = "Failed"

# Model for Contact
class Contact(db.Model):
    __tablename__ = "contacts"
    
    id_contact = db.Column(db.Integer, primary_key=True)
    id_account_sender = db.Column(db.Integer, nullable=False)
    id_account_reciver = db.Column(db.Integer, nullable=False)
    contact_status = db.Column(db.Enum(ContactStatus,  values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    is_emergency_contact = db.Column(db.Boolean, nullable=False)

    def __repr__(self):
        return f"<Contact {self.id_contact}>"

    def to_dict(self):
        return {
            "id_contact": self.id_contact,
            "id_account_sender": self.id_account_sender,
            "id_account_reciver": self.id_account_reciver,
            "contact_status": self.contact_status.value,
            "is_emergency_contact": self.is_emergency_contact
        }

# Model for Message
class Message(db.Model):
    __tablename__ = "messages"
    
    id_message = db.Column(db.Integer, primary_key=True)
    id_contact = db.Column(db.Integer, nullable=False)
    message_text = db.Column(db.Text, nullable=False)
    date_time = db.Column(db.DateTime, default=datetime.utcnow)
    message_status = db.Column(db.Enum(MessageStatus,  values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"<Message {self.id_message}>"

    def to_dict(self):
        return {
            "id_message": self.id_message,
            "id_contact": self.id_contact,
            "message_text": self.message_text,
            "date_time": self.date_time.isoformat(),
            "message_status": self.message_status.value
        }

# Routes

@app.route('/contacts', methods=['POST'])
def create_contact():
    try:
        data = request.json
        contact = Contact(
            id_account_sender=data['id_account_sender'],
            id_account_reciver=data['id_account_reciver'],
            contact_status=ContactStatus[data['contact_status']],
            is_emergency_contact=data['is_emergency_contact'],
        )

        db.session.add(contact)
        db.session.commit()

        return jsonify({"message": "Contact added", "id_contact": contact.id_contact}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/contacts', methods=['GET'])
def get_all_contacts():
    contacts = Contact.query.all()
    return jsonify([contact.to_dict() for contact in contacts])

@app.route('/contacts/<int:id_contact>', methods=['GET'])
def get_contact(id_contact):
    contact = Contact.query.get(id_contact)
    if contact:
        return jsonify(contact.to_dict())
    return jsonify({"error": "Contact not found"}), 404

@app.route('/contacts/<int:id_contact>', methods=['PUT'])
def update_contact(id_contact):
    contact = Contact.query.get(id_contact)
    if contact:
        data = request.json
        contact.contact_status = ContactStatus[data['contact_status']]
        contact.is_emergency_contact = data['is_emergency_contact']

        db.session.commit()

        return jsonify({"message": "Contact updated"}), 200
    return jsonify({"error": "Contact not found"}), 404

@app.route('/contacts/<int:id_contact>', methods=['DELETE'])
def delete_contact(id_contact):
    contact = Contact.query.get(id_contact)
    if contact:
        db.session.delete(contact)
        db.session.commit()
        return jsonify({"message": "Contact deleted"}), 200
    return jsonify({"error": "Contact not found"}), 404

@app.route('/messages', methods=['POST'])
def create_message():
    try:
        data = request.json
        message = Message(
            id_contact=data['id_contact'],
            message_text=data['message_text'],
            message_status=MessageStatus[data['message_status']],
        )

        db.session.add(message)
        db.session.commit()

        return jsonify({"message": "Message added", "id_message": message.id_message}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/messages', methods=['GET'])
def get_all_messages():
    messages = Message.query.all()
    return jsonify([message.to_dict() for message in messages])

@app.route('/messages/<int:id_message>', methods=['GET'])
def get_message(id_message):
    message = Message.query.get(id_message)
    if message:
        return jsonify(message.to_dict())
    return jsonify({"error": "Message not found"}), 404

@app.route('/messages/<int:id_message>', methods=['PUT'])
def update_message(id_message):
    message = Message.query.get(id_message)
    if message:
        data = request.json
        message.message_text = data['message_text']
        message.message_status = MessageStatus[data['message_status']]

        db.session.commit()

        return jsonify({"message": "Message updated"}), 200
    return jsonify({"error": "Message not found"}), 404

@app.route('/messages/<int:id_message>', methods=['DELETE'])
def delete_message(id_message):
    message = Message.query.get(id_message)
    if message:
        db.session.delete(message)
        db.session.commit()
        return jsonify({"message": "Message deleted"}), 200
    return jsonify({"error": "Message not found"}), 404


