from datetime import datetime
from flask import Blueprint, request, jsonify
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('plan_challange_routes', __name__)

# Model for DietPlan
class DietPlan(db.Model):
    __tablename__ = "diet_plan"
    
    id_plan = db.Column(db.Integer, primary_key=True , autoincrement=True)
    id_account_doctor = db.Column(db.Integer, db.ForeignKey('accounts.account_id'), nullable=False)
    id_account_patient = db.Column(db.Integer,db.ForeignKey('accounts.account_id'), nullable=False)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.String(255), nullable=False)
    start_date = db.Column(db.DateTime, nullable=False)
    end_date = db.Column(db.DateTime, nullable=False)
    id_challenge = db.Column(db.Integer, db.ForeignKey('challenges.id_challenge'), nullable=True)

    def __repr__(self):
        return f"<DietPlan {self.id_plan}>"

    def to_dict(self):
        return {
            "id_plan": self.id_plan,
            "id_account_doctor": self.id_account_doctor,
            "id_account_patient": self.id_account_patient,
            "title": self.title,
            "description": self.description,
            "start_date": self.start_date,
            "end_date": self.end_date,
            "id_challenge": self.id_challenge
        }

# Model for Challenge
class Challenge(db.Model):
    __tablename__ = "challenges"
    
    id_challenge = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_account_doctor = db.Column(db.Integer,  db.ForeignKey('accounts.account_id'), nullable=False)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.String(255), nullable=False)
    start_date = db.Column(db.DateTime, nullable=False)
    end_date = db.Column(db.DateTime, nullable=False)

    def __repr__(self):
        return f"<Challenge {self.id_challenge}>"

    def to_dict(self):
        return {
            "id_challenge": self.id_challenge,
            "id_account_doctor": self.id_account_doctor,
            "title": self.title,
            "description": self.description,
            "start_date": self.start_date,
            "end_date": self.end_date
        }

# Model for ChallengeParticipant
class ChallengeParticipant(db.Model):
    __tablename__ = "challenge_participant"
    
    id_challenge = db.Column(db.Integer, db.ForeignKey('challenges.id_challenge'), primary_key=True)
    id_account_patient = db.Column(db.Integer, db.ForeignKey('patients.id_profile'), primary_key=True)

    def __repr__(self):
        return f"<ChallengeParticipant {self.id_challenge}, {self.id_account_patient}>"

    def to_dict(self):
        return {
            "id_challenge": self.id_challenge,
            "id_account_patient": self.id_account_patient
        }

# Routes
@app.route('/diet_plans', methods=['GET'])
def get_all_diet_plans():
    diet_plans = DietPlan.query.all()
    return jsonify([diet_plan.to_dict() for diet_plan in diet_plans])

@app.route('/challenges', methods=['GET'])
def get_all_challenges():
    challenges = Challenge.query.all()
    return jsonify([challenge.to_dict() for challenge in challenges])

@app.route('/challenge_participants', methods=['GET'])
def get_all_challenge_participants():
    challenge_participants = ChallengeParticipant.query.all()
    return jsonify([participant.to_dict() for participant in challenge_participants])


@app.route('/diet_plans', methods=['POST'])
def create_diet_plan():
    try:
        data = request.json
        diet_plan = DietPlan(
            id_account_doctor=data['id_account_doctor'],
            id_account_patient=data['id_account_patient'],
            title=data['title'],
            description=data['description'],
            start_date=datetime.strptime(data['start_date'], '%Y-%m-%d %H:%M:%S'),
            end_date=datetime.strptime(data['end_date'], '%Y-%m-%d %H:%M:%S'),
            id_challenge=data.get('id_challenge')
        )

        db.session.add(diet_plan)
        db.session.commit()

        return jsonify({"message": "Diet Plan added", "id_plan": diet_plan.id_plan}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/challenges', methods=['POST'])
def create_challenge():
    try:
        data = request.json
        challenge = Challenge(
            id_account_doctor=data['id_account_doctor'],
            title=data['title'],
            description=data['description'],
            start_date=datetime.strptime(data['start_date'], '%Y-%m-%d %H:%M:%S'),
            end_date=datetime.strptime(data['end_date'], '%Y-%m-%d %H:%M:%S')
        )

        db.session.add(challenge)
        db.session.commit()

        return jsonify({"message": "Challenge added", "id_challenge": challenge.id_challenge}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/challenge_participants', methods=['POST'])
def create_challenge_participant():
    try:
        data = request.json
        challenge_participant = ChallengeParticipant(
            id_challenge=data['id_challenge'],
            id_account_patient=data['id_account_patient']
        )

        db.session.add(challenge_participant)
        db.session.commit()

        return jsonify({"message": "ChallengeParticipant added", "id_challenge": challenge_participant.id_challenge}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/diet_plans/<int:id_plan>', methods=['GET'])
def get_diet_plan(id_plan):
    diet_plan = DietPlan.query.get(id_plan)
    if diet_plan:
        return jsonify(diet_plan.to_dict())
    return jsonify({"error": "Diet Plan not found"}), 404

@app.route('/challenges/<int:id_challenge>', methods=['GET'])
def get_challenge(id_challenge):
    challenge = Challenge.query.get(id_challenge)
    if challenge:
        return jsonify(challenge.to_dict())
    return jsonify({"error": "Challenge not found"}), 404

@app.route('/challenge_participants/<int:id_challenge>', methods=['GET'])
def get_challenge_participant(id_challenge):
    challenge_participant = ChallengeParticipant.query.get(id_challenge)
    if challenge_participant:
        return jsonify(challenge_participant.to_dict())
    return jsonify({"error": "ChallengeParticipant not found"}), 404

@app.route('/diet_plans/<int:id_plan>', methods=['PUT'])
def update_diet_plan(id_plan):
    diet_plan = DietPlan.query.get(id_plan)
    if diet_plan:
        data = request.json
        diet_plan.id_account_doctor = data['id_account_doctor']
        diet_plan.id_account_patient = data['id_account_patient']
        diet_plan.title = data['title']
        diet_plan.description = data['description']
        diet_plan.start_date = datetime.strptime(data['start_date'], '%Y-%m-%d %H:%M:%S')
        diet_plan.end_date = datetime.strptime(data['end_date'], '%Y-%m-%d %H:%M:%S')
        diet_plan.id_challenge = data.get('id_challenge')

        db.session.commit()

        return jsonify({"message": "Diet Plan updated"}), 200
    return jsonify({"error": "Diet Plan not found"}), 404

@app.route('/challenges/<int:id_challenge>', methods=['PUT'])
def update_challenge(id_challenge):
    challenge = Challenge.query.get(id_challenge)
    if challenge:
        data = request.json
        challenge.id_account_doctor = data['id_account_doctor']
        challenge.title = data['title']
        challenge.description = data['description']
        challenge.start_date = datetime.strptime(data['start_date'], '%Y-%m-%d %H:%M:%S')
        challenge.end_date = datetime.strptime(data['end_date'], '%Y-%m-%d %H:%M:%S')

        db.session.commit()

        return jsonify({"message": "Challenge updated"}), 200
    return jsonify({"error": "Challenge not found"}), 404

@app.route('/challenge_participants/<int:id_challenge>', methods=['PUT'])
def update_challenge_participant(id_challenge):
    challenge_participant = ChallengeParticipant.query.get(id_challenge)
    if challenge_participant:
        data = request.json
        challenge_participant.id_challenge = data['id_challenge']
        challenge_participant.id_account_patient = data['id_account_patient']

        db.session.commit()

        return jsonify({"message": "ChallengeParticipant updated"}), 200
    return jsonify({"error": "ChallengeParticipant not found"}), 404

@app.route('/diet_plans/<int:id_plan>', methods=['DELETE'])
def delete_diet_plan(id_plan):
    diet_plan = DietPlan.query.get(id_plan)
    if diet_plan:
        db.session.delete(diet_plan)
        db.session.commit()
        return jsonify({"message": "Diet Plan deleted"}), 200
    return jsonify({"error": "Diet Plan not found"}), 404

@app.route('/challenges/<int:id_challenge>', methods=['DELETE'])
def delete_challenge(id_challenge):
    challenge = Challenge.query.get(id_challenge)
    if challenge:
        db.session.delete(challenge)
        db.session.commit()
        return jsonify({"message": "Challenge deleted"}), 200
    return jsonify({"error": "Challenge not found"}), 404

@app.route('/challenge_participants/<int:id_challenge>', methods=['DELETE'])
def delete_challenge_participant(id_challenge):
    challenge_participant = ChallengeParticipant.query.get(id_challenge)
    if challenge_participant:
        db.session.delete(challenge_participant)
        db.session.commit()
        return jsonify({"message": "ChallengeParticipant deleted"}), 200
    return jsonify({"error": "ChallengeParticipant not found"}), 404

