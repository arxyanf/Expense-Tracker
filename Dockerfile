# ---------- FRONTEND BUILD ----------
FROM node:18 AS frontend-builder
WORKDIR /app/frontend

# Copy only package.json and package-lock.json for npm install
COPY frontend/package*.json ./
RUN npm install

# Copy all frontend files and build React app
COPY ./frontend/ ./
RUN npm run build

# ---------- BACKEND ----------
FROM python:3.12-slim
WORKDIR /app/backend

# Install backend dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend code
COPY backend/ .

# Copy frontend build into backend static folder
COPY --from=frontend-builder /app/frontend/build ./frontend/build

# Environment variables
ENV FLASK_APP=app:create_app
ENV FLASK_ENV=production
ENV PORT=5000

# Expose port
EXPOSE 5000

# Run backend with gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:create_app()"]
