from flask import Flask
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

from config import Config


db = SQLAlchemy()


def create_app():
    app = Flask(__name__)

    app.config.from_object(Config)

    CORS(app)

    db.init_app(app)

    @app.get("/")
    def home():
        return {
            "success": True,
            "message": "DisasterOps AI Backend is running"
        }

    @app.get("/api/health")
    def health():
        return {
            "success": True,
            "service": "DisasterOps AI Backend",
            "status": "healthy"
        }
    @app.get("/api/health/db")
    def database_health():
        try:
            from sqlalchemy import text

            with db.engine.connect() as connection:
                connection.execute(text("SELECT 1"))

            return {
                "success": True,
                "database": "disasterops_ai",
                "status": "connected"
            }

        except Exception as e:
            return {
                "success": False,
                "database": "disasterops_ai",
                "status": "connection_failed",
                "error": str(e)
            }, 500

    return app