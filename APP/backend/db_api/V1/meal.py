from flask import Blueprint, request, jsonify
from enum import Enum
from db_api.V1._connect_db import db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('meal_routes', __name__)

class MealType(Enum):
    BREAKFAST = "breakfast"
    LUNCH = "lunch"
    DINNER = "dinner"
    SNACK = "snack"

# Model for Meal
class Meal(db.Model):
    __tablename__ = "meals"
    
    id_meal = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    calories = db.Column(db.Integer, nullable=False)
    meal_type = db.Column(db.Enum(MealType, values_callable=lambda obj: [e.value for e in obj] ), nullable=False)
    carbs = db.Column(db.Float, nullable=False)
    protein = db.Column(db.Float, nullable=False)
    fat = db.Column(db.Float, nullable=False)
    faber = db.Column(db.Float, nullable=False)

    def __repr__(self):
        return f"<Meal {self.name}>"

    def to_dict(self):
        return {
            "id_meal": self.id_meal,
            "name": self.name,
            "calories": self.calories,
            "meal_type": self.meal_type,
            "carbs": self.carbs,
            "protein": self.protein,
            "fat": self.fat,
            "faber": self.faber
        }

# Model for MealEaten
class MealEaten(db.Model):
    __tablename__ = "meal_eaten"
    
    id_patient = db.Column(db.Integer, db.ForeignKey('patients.id_profile'), nullable=False, primary_key=True)
    id_meal = db.Column(db.Integer, db.ForeignKey('meals.id_meal'), nullable=False, primary_key=True)
    date_time = db.Column(db.DateTime, nullable=False, primary_key=True)
    
    def __repr__(self):
        return f"<MealEaten {self.id_patient}>"

    def to_dict(self):
        return {
            "id_patient": self.id_patient,
            "id_meal": self.id_meal,
            "date_time": self.date_time
        }

# Model for MealDiet
class MealDiet(db.Model):
    __tablename__ = "meal_diet"
    
    id_meal = db.Column(db.Integer, db.ForeignKey('meals.id_meal'), primary_key=True)
    id_diet_plan = db.Column(db.Integer, db.ForeignKey('diet_plan.id_plan'), primary_key=True)

    def __repr__(self):
        return f"<MealDiet {self.id_meal}, {self.id_account_patient}>"

    def to_dict(self):
        return {
            "id_meal": self.id_meal,
            "id_account_patient": self.id_account_patient
        }

# Routes
@app.route('/meals', methods=['POST'])
def create_meal():
    try:
        data = request.json
        meal = Meal(
            name=data['name'],
            calories=data['calories'],
            meal_type=data['meal_type'],
            carbs=data['carbs'],
            protein=data['protein'],
            fat=data['fat'],
            faber=data['faber'],
        )

        db.session.add(meal)
        db.session.commit()

        return jsonify({"message": "Meal added", "id_meal": meal.id_meal}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/meals', methods=['GET'])
def get_all_meals():
    meals = Meal.query.all()
    return jsonify([meal.to_dict() for meal in meals])

@app.route('/meals/<int:id_meal>', methods=['GET'])
def get_meal(id_meal):
    meal = Meal.query.get(id_meal)
    if meal:
        return jsonify(meal.to_dict())
    return jsonify({"error": "Meal not found"}), 404

@app.route('/meals/<int:id_meal>', methods=['PUT'])
def update_meal(id_meal):
    meal = Meal.query.get(id_meal)
    if meal:
        data = request.json
        meal.name = data['name']
        meal.calories = data['calories']
        meal.meal_type = data['meal_type']
        meal.carbs = data['carbs']
        meal.protein = data['protein']
        meal.fat = data['fat']
        meal.faber = data['faber']

        db.session.commit()

        return jsonify({"message": "Meal updated"}), 200
    return jsonify({"error": "Meal not found"}), 404

@app.route('/meals/<int:id_meal>', methods=['DELETE'])
def delete_meal(id_meal):
    meal = Meal.query.get(id_meal)
    if meal:
        db.session.delete(meal)
        db.session.commit()
        return jsonify({"message": "Meal deleted"}), 200
    return jsonify({"error": "Meal not found"}), 404

@app.route('/meal_eaten', methods=['POST'])
def create_meal_eaten():
    try:
        data = request.json
        meal_eaten = MealEaten(
            id_patient=data['id_patient'],
            id_meal=data['id_meal'],
            date_time=data['date_time']
        )

        db.session.add(meal_eaten)
        db.session.commit()

        return jsonify({"message": "MealEaten added", "id_patient": meal_eaten.id_patient}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/meal_diet', methods=['POST'])
def create_meal_diet():
    try:
        data = request.json
        meal_diet = MealDiet(
            id_meal=data['id_meal'],
            id_account_patient=data['id_account_patient']
        )

        db.session.add(meal_diet)
        db.session.commit()

        return jsonify({"message": "MealDiet added", "id_meal": meal_diet.id_meal}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400


@app.route('/meal_diet', methods=['GET'])
def get_all_meal_diet():
    meal_diets = MealDiet.query.all()
    return jsonify([meal_diet.to_dict() for meal_diet in meal_diets])

@app.route('/meal_diet/<int:id_meal>', methods=['GET'])
def get_meal_diet(id_meal):
    meal_diet = MealDiet.query.get(id_meal)
    if meal_diet:
        return jsonify(meal_diet.to_dict())
    return jsonify({"error": "MealDiet not found"}), 404

@app.route('/meal_diet/<int:id_meal>', methods=['PUT'])
def update_meal_diet(id_meal):
    meal_diet = MealDiet.query.get(id_meal)
    if meal_diet:
        data = request.json
        meal_diet.id_meal = data['id_meal']
        meal_diet.id_account_patient = data['id_account_patient']

        db.session.commit()

        return jsonify({"message": "MealDiet updated"}), 200
    return jsonify({"error": "MealDiet not found"}), 404

@app.route('/meal_diet/<int:id_meal>', methods=['DELETE'])
def delete_meal_diet(id_meal):
    meal_diet = MealDiet.query.get(id_meal)
    if meal_diet:
        db.session.delete(meal_diet)
        db.session.commit()
        return jsonify({"message": "MealDiet deleted"}), 200
    return jsonify({"error": "MealDiet not found"}), 404