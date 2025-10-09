from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///expenses.db"
    app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

    db.init_app(app)

    from .routes import bp as api_bp
    app.register_blueprint(api_bp)

    @app.route("/", methods=["GET"])
    def home():
        return jsonify({"message": "Expense Tracker API is running"}), 200

    with app.app_context():
        db.create_all()

    return app
