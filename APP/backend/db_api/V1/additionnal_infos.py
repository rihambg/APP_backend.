from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance

# Create a Blueprint for your routes
app = Blueprint('additionnal_routes', __name__)


# Enums
class LastDiagnosis(Enum):
    LESS_THAN_1_YEAR = "less-than-1-year"
    BETWEEN_1_AND_5_YEARS = "between-1-and-5-years"
    BETWEEN_5_AND_10_YEARS = "between-5-and-10-years"
    MORE_THAN_10_YEARS = "more-than-10-years"

class OtherChronicCondition(Enum):
    NONE = "none"
    HYPERTENSION = "hypertension"
    HEART_DISEASE = "heart-disease"
    KIDNEY_DISEASE = "kidney-disease"
    OBESITY = "obesity"

class AlreadyTakenMedicines(Enum):
    NONE = "none"
    INSULIN = "insulin"
    ORAL_MEDICATION = "oral-medication"
    BOTH = "both"

class SugarFoodFrequency(Enum):
    OCCASIONALLY = "occasionally"
    REGULARLY = "regularly"
    FREQUENTLY = "frequently"
    VERY_OFTEN = "very-often"

class Diet(Enum):
    LOW_CARB = "low-carb"
    VEGAN = "vegan"
    KETO = "keto"
    MEDITERRANEAN = "mediterranean"
    NONE = "none"

class ExerciseFrequency(Enum):
    NEVER = "never"
    OCCASIONALLY = "occasionally"
    RARELY = "rarely"
    SOMETIMES = "sometimes"
    DAILY = "daily"

class SmokingStatus(Enum):
    NON_SMOKER = "non-smoker"
    SMOKER = "smoker"

class AlcoholConsumption(Enum):
    NON_DRINKER = "non-drinker"
    DRINKER = "drinker"

class Goal(Enum):
    IMPROVE_DIET = "improve-diet"
    MONITOR_BLOOD_SUGAR = "monitor-blood-sugar"
    LOSE_GAIN_WEIGHT = "lose-gain-weight"
    ALL_OF_THE_ABOVE = "all-of-the-above"

class PregnancyStatus(Enum):
    NOT_PREGNANT = "not-pregnant"
    PREGNANT = "pregnant"

# Model
class AdditionnalInfos(db.Model):
    __tablename__ = "additionnal_infos"

    id = db.Column(db.Integer, primary_key=True)
    id_patient = db.Column(db.Integer, db.ForeignKey('patients.id_profile'), nullable=False)
    last_diagnosis = db.Column(db.Enum(LastDiagnosis, values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    has_allergies = db.Column(db.Boolean, default=False)
    other_chronic_condition = db.Column(db.Enum(OtherChronicCondition, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    already_taken_medicines = db.Column(db.Enum(AlreadyTakenMedicines, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    frequecy_sugar_food = db.Column(db.Enum(SugarFoodFrequency, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    diet = db.Column(db.Enum(Diet), nullable=True)
    exercise_frequency = db.Column(db.Enum(ExerciseFrequency, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    smoking_status = db.Column(db.Enum(SmokingStatus,  values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    alcohol_consumption = db.Column(db.Enum(AlcoholConsumption,  values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    goal = db.Column(db.Enum(Goal), nullable=True)
   
    def to_dict(self):
        return {
            "id": self.id,
            "id_patient": self.id_patient,
            "last_diagnosis": self.last_diagnosis.value,
            "has_allergies": self.has_allergies,
            "other_chronic_condition": self.other_chronic_condition.value if self.other_chronic_condition else None,
            "already_taken_medicines": self.already_taken_medicines.value if self.already_taken_medicines else None,
            "frequecy_sugar_food": self.frequecy_sugar_food.value if self.frequecy_sugar_food else None,
            "diet": self.diet.value if self.diet else None,
            "exercise_frequency": self.exercise_frequency.value if self.exercise_frequency else None,
            "smoking_status": self.smoking_status.value if self.smoking_status else None,
            "alcohol_consumption": self.alcohol_consumption.value if self.alcohol_consumption else None,
            "goal": self.goal.value if self.goal else None
        }
        
class WomanAdditionnalInfos(db.Model):
    __tablename__ = "woman_additionnal_infos"


    id = db.Column(db.Integer, primary_key=True)
    id_patient = db.Column(db.Integer, db.ForeignKey('patients.id_profile'), nullable=False)
    last_diagnosis = db.Column(db.Enum(LastDiagnosis, values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    has_allergies = db.Column(db.Boolean, default=False)
    other_chronic_condition = db.Column(db.Enum(OtherChronicCondition, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    already_taken_medicines = db.Column(db.Enum(AlreadyTakenMedicines, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    frequecy_sugar_food = db.Column(db.Enum(SugarFoodFrequency, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    diet = db.Column(db.Enum(Diet), nullable=True)
    exercise_frequency = db.Column(db.Enum(ExerciseFrequency, values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    smoking_status = db.Column(db.Enum(SmokingStatus,  values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    alcohol_consumption = db.Column(db.Enum(AlcoholConsumption,  values_callable=lambda obj: [e.value for e in obj]), nullable=True)
    goal = db.Column(db.Enum(Goal), nullable=True)

    pregnancy_status = db.Column(db.Enum(PregnancyStatus, values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def to_dict(self):
        return {
            "id": self.id,
            "id_patient": self.id_patient,
            "last_diagnosis": self.last_diagnosis.value,
            "has_allergies": self.has_allergies,
            "other_chronic_condition": self.other_chronic_condition.value if self.other_chronic_condition else None,
            "already_taken_medicines": self.already_taken_medicines.value if self.already_taken_medicines else None,
            "frequecy_sugar_food": self.frequecy_sugar_food.value if self.frequecy_sugar_food else None,
            "diet": self.diet.value if self.diet else None,
            "exercise_frequency": self.exercise_frequency.value if self.exercise_frequency else None,
            "smoking_status": self.smoking_status.value if self.smoking_status else None,
            "alcohol_consumption": self.alcohol_consumption.value if self.alcohol_consumption else None,
            "goal": self.goal.value if self.goal else None,
            "pregnancy_status": self.pregnancy_status.value
        }

# Routes
@app.route('/additionnal-infos', methods=['POST'])
def create_additionnal_infos():
    try:
        data = request.json
        additionnal_infos = AdditionnalInfos(
            id_patient=data['id_patient'],
            last_diagnosis=data['last_diagnosis'],
            has_allergies=data.get('has_allergies', False),
            other_chronic_condition=data.get('other_chronic_condition'),
            already_taken_medicines=data.get('already_taken_medicines'),
            frequecy_sugar_food=data.get('frequecy_sugar_food'),
            diet=data.get('diet'),
            exercise_frequency=data.get('exercise_frequency'),
            smoking_status=data.get('smoking_status'),
            alcohol_consumption=data.get('alcohol_consumption'),
            goal=data.get('goal')
        )
        db.session.add(additionnal_infos)
        db.session.commit()
        return jsonify(additionnal_infos.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400
    
@app.route('/additionnal-infos/<int:id>', methods=['GET'])
def get_additionnal_infos(id):
    additionnal_infos = AdditionnalInfos.query.get(id)
    if additionnal_infos:
        return jsonify(additionnal_infos.to_dict())
    return jsonify({"error": "Additionnal Infos not found"}), 404

@app.route('/additionnal-infos/<int:id>', methods=['PUT'])
def update_additionnal_infos(id):
    additionnal_infos = AdditionnalInfos.query.get(id)
    if additionnal_infos:
        data = request.json
        additionnal_infos.last_diagnosis = data['last_diagnosis']
        additionnal_infos.has_allergies = data.get('has_allergies', additionnal_infos.has_allergies)
        additionnal_infos.other_chronic_condition = data.get('other_chronic_condition', additionnal_infos.other_chronic_condition)
        additionnal_infos.already_taken_medicines = data.get('already_taken_medicines', additionnal_infos.already_taken_medicines)
        additionnal_infos.frequecy_sugar_food = data.get('frequecy_sugar_food', additionnal_infos.frequecy_sugar_food)
        additionnal_infos.diet = data.get('diet', additionnal_infos.diet)
        additionnal_infos.exercise_frequency = data.get('exercise_frequency', additionnal_infos.exercise_frequency)
        additionnal_infos.smoking_status = data.get('smoking_status', additionnal_infos.smoking_status)
        additionnal_infos.alcohol_consumption = data.get('alcohol_consumption', additionnal_infos.alcohol_consumption)
        additionnal_infos.goal = data.get('goal', additionnal_infos.goal)

        db.session.commit()
        return jsonify(additionnal_infos.to_dict())
    return jsonify({"error": "Additionnal Infos not found"}), 404

@app.route('/additionnal-infos/<int:id>', methods=['DELETE'])
def delete_additionnal_infos(id):
    additionnal_infos = AdditionnalInfos.query.get(id)
    if additionnal_infos:
        db.session.delete(additionnal_infos)
        db.session.commit()
        return jsonify({"message": "Additionnal Infos deleted"}), 200
    return jsonify({"error": "Additionnal Infos not found"}), 404

@app.route('/additionnal-infos', methods=['GET'])
def get_all_additionnal_infos():
    additionnal_infos = AdditionnalInfos.query.all()
    return jsonify([info.to_dict() for info in additionnal_infos])



@app.route('/woman-additionnal-infos', methods=['POST'])
def create_woman_additionnal_infos():
    try:
        data = request.json
        additionnal_infos = WomanAdditionnalInfos(
            id_patient=data['id_patient'],
            last_diagnosis=data['last_diagnosis'],
            has_allergies=data.get('has_allergies', False),
            other_chronic_condition=data.get('other_chronic_condition'),
            already_taken_medicines=data.get('already_taken_medicines'),
            frequecy_sugar_food=data.get('frequecy_sugar_food'),
            diet=data.get('diet'),
            exercise_frequency=data.get('exercise_frequency'),
            smoking_status=data.get('smoking_status'),
            alcohol_consumption=data.get('alcohol_consumption'),
            goal=data.get('goal'),
            pregnancy_status=data['pregnancy_status'],
        )
        db.session.add(additionnal_infos)
        db.session.commit()
        return jsonify(additionnal_infos.to_dict()), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400
    
@app.route('/woman-additionnal-infos/<int:id>', methods=['GET'])
def get_woman_additionnal_infos(id):
    additionnal_infos = WomanAdditionnalInfos.query.get(id)
    if additionnal_infos:
        return jsonify(additionnal_infos.to_dict())
    return jsonify({"error": "Additionnal Infos not found"}), 404

@app.route('/woman-additionnal-infos/<int:id>', methods=['PUT'])
def update_woman_additionnal_infos(id):
    additionnal_infos = WomanAdditionnalInfos.query.get(id)
    if additionnal_infos:
        data = request.json
        additionnal_infos.last_diagnosis = data['last_diagnosis']
        additionnal_infos.has_allergies = data.get('has_allergies', additionnal_infos.has_allergies)
        additionnal_infos.other_chronic_condition = data.get('other_chronic_condition', additionnal_infos.other_chronic_condition)
        additionnal_infos.already_taken_medicines = data.get('already_taken_medicines', additionnal_infos.already_taken_medicines)
        additionnal_infos.frequecy_sugar_food = data.get('frequecy_sugar_food', additionnal_infos.frequecy_sugar_food)
        additionnal_infos.diet = data.get('diet', additionnal_infos.diet)
        additionnal_infos.exercise_frequency = data.get('exercise_frequency', additionnal_infos.exercise_frequency)
        additionnal_infos.smoking_status = data.get('smoking_status', additionnal_infos.smoking_status)
        additionnal_infos.alcohol_consumption = data.get('alcohol_consumption', additionnal_infos.alcohol_consumption)
        additionnal_infos.goal = data.get('goal', additionnal_infos.goal)
        additionnal_infos.pregnancy_status = data.get('pregnancy_status', additionnal_infos.pregnancy_status)

        db.session.commit()
        return jsonify(additionnal_infos.to_dict())
    return jsonify({"error": "Additionnal Infos not found"}), 404

@app.route('/woman-additionnal-infos/<int:id>', methods=['DELETE'])
def delete_woman_additionnal_infos(id):
    additionnal_infos = WomanAdditionnalInfos.query.get(id)
    if additionnal_infos:
        db.session.delete(additionnal_infos)
        db.session.commit()
        return jsonify({"message": "Additionnal Infos deleted"}), 200
    return jsonify({"error": "Additionnal Infos not found"}), 404

@app.route('/woman-additionnal-infos', methods=['GET'])
def get_all_woman_additionnal_infos():
    additionnal_infos = WomanAdditionnalInfos.query.all()
    return jsonify([info.to_dict() for info in additionnal_infos])

