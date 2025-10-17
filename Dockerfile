# ---------- FRONTEND BUILD ----------
FROM node:18 AS frontend-builder
WORKDIR /app/frontend

# Copy package.json and package-lock.json from root/frontend
COPY frontend/package*.json ./

# Install frontend dependencies
RUN npm install

# Copy all frontend files
COPY frontend/ ./

# Build frontend
RUN npm run build

# ---------- BACKEND ----------
FROM python:3.12-slim
WORKDIR /app/backend

# Copy backend requirements
COPY requirements.txt .

# Install backend dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend source code
COPY backend/ .

# Copy frontend build into backend
COPY --from=frontend-builder /app/frontend/build ./frontend/build

# Environment variables
ENV FLASK_APP=app:create_app()
ENV FLASK_ENV=production
ENV PORT=5000

# Expose port
EXPOSE 5000

# Run app with Gunicorn using factory
CMD ["gunicorn", "--chdir", ".", "app:create_app()", "-b", "0.0.0.0:5000"]
