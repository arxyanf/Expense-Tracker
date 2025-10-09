from flask import Blueprint, request, jsonify
from .models import Expense, db

bp = Blueprint("routes", __name__)

# Get all expenses
@bp.route("/expenses", methods=["GET"])
def get_expenses():
    expenses = Expense.query.all()
    return jsonify([expense.to_dict() for expense in expenses]), 200

# Create a new expense
@bp.route("/expenses", methods=["POST"])
def create_expense():
    data = request.get_json()
    if not data:
        return jsonify({"error": "No input data provided"}), 400

    expense = Expense(
        title=data.get("title"),
        amount=data.get("amount"),
        category=data.get("category"),
        date=data.get("date")
    )
    db.session.add(expense)
    db.session.commit()
    return jsonify(expense.to_dict()), 201

# Update an expense
@bp.route("/expenses/<int:id>", methods=["PUT"])
def update_expense(id):
    data = request.get_json()
    expense = Expense.query.get_or_404(id)

    expense.title = data.get("title", expense.title)
    expense.amount = data.get("amount", expense.amount)
    expense.category = data.get("category", expense.category)
    expense.date = data.get("date", expense.date)

    db.session.commit()
    return jsonify(expense.to_dict()), 200

# Delete an expense
@bp.route("/expenses/<int:id>", methods=["DELETE"])
def delete_expense(id):
    expense = Expense.query.get_or_404(id)
    db.session.delete(expense)
    db.session.commit()
    return jsonify({"message": "Expense deleted successfully"}), 200
