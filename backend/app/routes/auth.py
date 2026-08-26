from flask import Blueprint, request, jsonify
from werkzeug.security import generate_password_hash

from app import db
from app.models.user import User


auth_bp = Blueprint("auth", __name__, url_prefix="/api/auth")


@auth_bp.post("/register")
def register():
    data = request.get_json()

    if not data:
        return jsonify({
            "success": False,
            "message": "Request body is required"
        }), 400

    name = data.get("name")
    email = data.get("email")
    phone = data.get("phone")
    password = data.get("password")

    if not name or not email or not password:
        return jsonify({
            "success": False,
            "message": "Name, email and password are required"
        }), 400

    existing_user = User.query.filter_by(email=email).first()

    if existing_user:
        return jsonify({
            "success": False,
            "message": "Email already registered"
        }), 409

    password_hash = generate_password_hash(password)

    user = User(
        name=name,
        email=email,
        phone=phone,
        password_hash=password_hash,
        role="CITIZEN"
    )

    db.session.add(user)
    db.session.commit()

    return jsonify({
        "success": True,
        "message": "Citizen registered successfully",
        "user": {
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "phone": user.phone,
            "role": user.role
        }
    }), 201