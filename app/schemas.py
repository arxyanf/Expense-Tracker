from marshmallow import fields
from marshmallow_sqlalchemy import SQLAlchemyAutoSchema
from .models import Expense
from . import db

class ExpenseSchema(SQLAlchemyAutoSchema):
    class Meta:
        model = Expense
        load_instance = True
        sqla_session = db.session

    id = fields.Int(dump_only=True)
    amount = fields.Float(required=True)
    category = fields.Str(required=True)
    description = fields.Str(allow_none=True)
    date = fields.Date(required=True)
