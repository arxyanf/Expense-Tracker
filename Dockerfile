# ---------- Frontend build stage ----------
FROM node:18 AS frontend-builder
WORKDIR /app

# Copy package files from your local frontend folder
COPY ./frontend/package*.json ./frontend/
RUN cd frontend && npm install

# Copy the rest of the frontend files and build
COPY ./frontend ./frontend
RUN cd frontend && npm run build


# ---------- Backend stage ----------
FROM python:3.10-slim
WORKDIR /app

# Copy and install backend dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy backend and frontend build output
COPY ./backend ./backend
COPY --from=frontend-builder /app/frontend/build ./frontend/build

WORKDIR /app/backend
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:create_app()"]
