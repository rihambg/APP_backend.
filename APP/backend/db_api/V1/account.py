from flask import Blueprint, request, jsonify
import enum
from db_api.V1._connect_db import  db  # Import the shared db instance


# Create a Blueprint for your routes
app = Blueprint('account_routes', __name__)

# Enum types
class AccountType(enum.Enum):
    DOCTOR = "Doctor"
    PATIENT = "Patient"

class AccountStatus(enum.Enum):
    ACTIVE = "Active"
    INACTIVE = "Inactive"
    SUSPENDED = "Suspended"
    DELETED = "Deleted"

# Account model
class Account(db.Model):
    __tablename__ = 'accounts'
    account_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_name = db.Column(db.String(255), unique=True, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    phone_number = db.Column(db.String(20))
    password = db.Column(db.String(255), nullable=False)
    account_type = db.Column(db.Enum(AccountType, values_callable=lambda obj: [e.value for e in obj]), nullable=False)
    status = db.Column(db.Enum(AccountStatus, values_callable=lambda obj: [e.value for e in obj]), nullable=False)

    def __repr__(self):
        return f"<Account {self.user_name}>"
    
    def to_dict(self):
        return {
            "account_id": self.account_id,
            "user_name": self.user_name,
            "email": self.email,
            "phone_number": self.phone_number,
            "password": self.password,
            "account_type": self.account_type.name,
            "status": self.status.name,
            
        }
    
# Routes
@app.route("/accounts", methods=["GET"])
def list_accounts():
    accounts = Account.query.all()
    return jsonify([acc.to_dict() for acc in accounts])

@app.route('/accounts/<int:account_id>', methods=['GET'])
def get_account(account_id):
    account = Account.query.get(account_id)
    if account:
        return jsonify(account.to_dict())
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts', methods=['POST'])
def create_account():
    try:
        data = request.json
        account = Account(
            user_name=data['user_name'],
            email=data['email'],
            phone_number=data.get('phone_number'),
            password=data['password'],
            account_type= data['account_type'],
            status=data['status']
        )
        db.session.add(account)
        db.session.commit()
        return jsonify({"message": "Patient added", "id_profile": account.account_id}), 201

    except Exception as e:
        db.session.rollback()
        return jsonify({"error": str(e)}), 400

@app.route('/accounts/<int:account_id>', methods=['DELETE'])
def delete_account(account_id):
    account = Account.query.get(account_id)
    if account:
        db.session.delete(account)
        db.session.commit()
        return jsonify({"message": "Account deleted"}), 200
    return jsonify({"error": "Account not found"}), 404

# PATCH: Partial Updates
@app.route('/accounts/<int:account_id>/status', methods=['PATCH'])
def update_account_status(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.status = data['status']
        db.session.commit()
        return jsonify({"message": "Account status updated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/type', methods=['PATCH'])
def update_account_type(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.account_type = data['account_type']
        db.session.commit()
        return jsonify({"message": "Account type updated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/password', methods=['PATCH'])
def update_account_password(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.password = data['password']
        db.session.commit()
        return jsonify({"message": "Account password updated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/phone', methods=['PATCH'])
def update_account_phone(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.phone_number = data['phone_number']
        db.session.commit()
        return jsonify({"message": "Account phone number updated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/email', methods=['PATCH'])
def update_account_email(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.email = data['email']
        db.session.commit()
        return jsonify({"message": "Account email updated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/username', methods=['PATCH'])
def update_account_username(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.user_name = data['user_name']
        db.session.commit()
        return jsonify({"message": "Account username updated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/activate', methods=['PATCH'])
def activate_account(account_id):
    account = Account.query.get(account_id)
    if account:
        account.status = AccountStatus.ACTIVE
        db.session.commit()
        return jsonify({"message": "Account activated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/suspend', methods=['PATCH'])
def suspend_account(account_id):
    account = Account.query.get(account_id)
    if account:
        account.status = AccountStatus.SUSPENDED
        db.session.commit()
        return jsonify({"message": "Account suspended"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/unsuspend', methods=['PATCH'])
def unsuspend_account(account_id):
    account = Account.query.get(account_id)
    if account:
        account.status = AccountStatus.ACTIVE
        db.session.commit()
        return jsonify({"message": "Account unsuspended"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/deactivate', methods=['PATCH'])
def deactivate_account(account_id):
    account = Account.query.get(account_id)
    if account:
        account.status = AccountStatus.INACTIVE
        db.session.commit()
        return jsonify({"message": "Account deactivated"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/delete', methods=['PATCH'])
def soft_delete_account(account_id):
    account = Account.query.get(account_id)
    if account:
        account.status = AccountStatus.DELETED
        db.session.commit()
        return jsonify({"message": "Account marked as deleted"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>/restore', methods=['PATCH'])
def restore_account(account_id):
    account = Account.query.get(account_id)
    if account:
        account.status = AccountStatus.ACTIVE
        db.session.commit()
        return jsonify({"message": "Account restored"}), 200
    return jsonify({"error": "Account not found"}), 404

@app.route('/accounts/<int:account_id>', methods=['PUT'])
def update_full_account(account_id):
    account = Account.query.get(account_id)
    if account:
        data = request.json
        account.email = data['email']
        account.user_name = data['user_name']
        account.phone_number = data['phone_number']
        account.password = data['password']
        account.status = data['status']
        account.account_type = data['account_type']
        db.session.commit()
        return jsonify({"message": "Account fully updated"}), 200
    return jsonify({"error": "Account not found"}), 404

