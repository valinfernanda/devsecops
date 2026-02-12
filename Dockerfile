# -----------------------------
# Stage 1: Build stage (full Python)
# -----------------------------
FROM python:3.12.2-slim-bookworm AS builder

# Set environment agar Python output langsung muncul di logs
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# Copy requirements & install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools==78.1.1 wheel==0.46.2 \
    && pip install --prefix=/install --no-cache-dir -r requirements.txt

# Copy source code
COPY app ./app

# -----------------------------
# Stage 2: Runtime stage (Distroless)
# -----------------------------
FROM gcr.io/distroless/python3-debian12:nonroot

WORKDIR /app

# Copy Python packages from build stage
COPY --from=builder /install /usr/local

# Copy application source
COPY --from=builder /app /app

# Expose port & start server
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
