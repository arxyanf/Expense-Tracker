# Expense Tracker - Phase 1 (Flask + SQLite)

## Setup (local)
1. Create virtualenv:
   python3 -m venv venv
   source venv/bin/activate

2. Install:
   pip install -r requirements.txt

3. Initialize DB:
   export FLASK_APP=app.py
   flask db init
   flask db migrate -m "init"
   flask db upgrade

   (If flask command not found: `pip install flask` or run via python -m flask)

4. Run:
   python app.py

API base: http://127.0.0.1:5000/api
