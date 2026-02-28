# --- Stage 1: Build/Security Stage ---
FROM python:3.11-slim as builder

# Set environment variables for better Python performance
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install requirements to a local directory to keep them separate from the OS
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# --- Stage 2: Production Runtime ---
FROM python:3.11-slim-bookworm

WORKDIR /app

# Create a non-root user for security (Crucial for passing Checkov/Trivy)
RUN useradd -m -u 1000 appuser

# Copy only the installed packages from the builder stage
COPY --from=builder /root/.local /home/appuser/.local
COPY src/ .

# Set ownership to the non-root user
RUN chown -R appuser:appuser /app
USER appuser

# Ensure the local binaries are in the path
ENV PATH=/home/appuser/.local/bin:$PATH

# Expose the port Flask/Gunicorn will run on
EXPOSE 5000

# Use Gunicorn for production-grade serving
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "3", "app:app"]