from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# Create a single SQLAlchemy instance
db = SQLAlchemy()

class FlaskApp:
    _instance = None  # Class-level variable to hold the single instance

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super(FlaskApp, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        if not hasattr(self, 'app'):  # Ensure initialization happens only once
            self.app = self._create_app()
            db.init_app(self.app)  # Initialize the shared SQLAlchemy instance

    def _create_app(self):
        app = Flask(__name__)

        # MySQL configuration
        app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost:3306/app_db'
        app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

        return app
