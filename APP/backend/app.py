#app.py
from flask import Flask
from flask_cors import CORS
from login_api import login_bp
from signup import signup_bp
from articles import articles_bp

app = Flask(__name__)
CORS(app, resources={
    r"/api/*": {
        "origins": "*",
        "methods": ["GET", "POST", "PUT", "DELETE"],
        "allow_headers": ["Content-Type"]
    }
})

app.register_blueprint(login_bp, url_prefix='/api')
app.register_blueprint(signup_bp, url_prefix='/api')
app.register_blueprint(articles_bp, url_prefix='/api')

@app.route('/')
def index():
    return "Diabetes Management API is running"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True) 