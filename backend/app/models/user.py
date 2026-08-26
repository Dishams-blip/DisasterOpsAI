from app import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)

    name = db.Column(
        db.String(100),
        nullable=False
    )

    email = db.Column(
        db.String(150),
        nullable=False,
        unique=True
    )

    phone = db.Column(
        db.String(20)
    )

    password_hash = db.Column(
        db.String(255),
        nullable=False
    )

    role = db.Column(
        db.Enum("CITIZEN", "ADMIN"),
        nullable=False,
        default="CITIZEN"
    )

    created_at = db.Column(
        db.DateTime,
        server_default=db.func.current_timestamp()
    )