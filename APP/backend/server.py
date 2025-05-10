from db_api.V1._connect_db import FlaskApp, db
from flask_cors import CORS

from db_api.V1.account import app as account_app
from db_api.V1.location import app as location_app
from db_api.V1.hospital import app as hospital_app
from db_api.V1.user import app as user_app
from db_api.V1.community import app as community_app
from db_api.V1.perspection import app as perspection_app
from db_api.V1.plan_and_challange import app as plan_and_challange_app
from db_api.V1.activity import app as activity_app
from db_api.V1.meal import app as meal_app
from db_api.V1.blood_sugar import app as blood_sugar_app
from db_api.V1.notification import app as notification_app
from db_api.V1.articles import app as articles_app
from db_api.V1.appointement import app as appointement_app
from db_api.V1.contact import app as contact_app
from db_api.V1.additionnal_infos import app as additionnal_infos_app


flask_app_instance = FlaskApp()# Get the first instance of the app
app = flask_app_instance.app
CORS(app, resources={
    r"/api/*": {
        "origins": "*",
        "methods": ["GET", "POST", "PUT", "DELETE"],
        "allow_headers": ["Content-Type"]
    }
})

# Helper function to count endpoints by prefix
def count_endpoints_by_prefix(prefix):
    return sum(1 for rule in app.url_map.iter_rules() if rule.rule.startswith(prefix))





@app.route('/')
def index():
    db_info = {
        "name": "Diabetes Management API",
        "version": "1.0",
        "description": "API for managing diabetes-related data and functionalities.",
        "endpoints_categories": [
            { "subdomain": "db_api", "type" : "DB endpoints", "description" : "Endpoints for database operations", "endpoints_count" : count_endpoints_by_prefix('/db_api/api') },
            { "subdomain": "ai_api", "type" : "IA endpoints", "description" : "Endpoints for AI operations", "endpoints_count" : count_endpoints_by_prefix('/ai_api/api') },
        ]
    }
    return db_info


# Register Blueprints
# Register the blueprints for the database API
app.register_blueprint(account_app,  url_prefix='/db_api/api')
app.register_blueprint(location_app,  url_prefix='/db_api/api')
app.register_blueprint(hospital_app, url_prefix='/db_api/api')
app.register_blueprint(user_app, url_prefix='/db_api/api')
app.register_blueprint(community_app, url_prefix='/db_api/api')
app.register_blueprint(perspection_app, url_prefix='/db_api/api')
app.register_blueprint(plan_and_challange_app, url_prefix='/db_api/api')
app.register_blueprint(activity_app, url_prefix='/db_api/api')
app.register_blueprint(meal_app, url_prefix='/db_api/api')
app.register_blueprint(blood_sugar_app, url_prefix='/db_api/api')
app.register_blueprint(notification_app, url_prefix='/db_api/api')
app.register_blueprint(articles_app, url_prefix='/db_api/api')
app.register_blueprint(appointement_app, url_prefix='/db_api/api')
app.register_blueprint(contact_app, url_prefix='/db_api/api')
app.register_blueprint(additionnal_infos_app, url_prefix='/db_api/api')

# Register the blueprints for the IA API
# ...



# Create tables if not exist (the database should be created manually)
#with app.app_context():
#    db.create_all()
    
    
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)