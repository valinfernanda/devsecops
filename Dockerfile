# Base image Python 3.12 slim terbaru (Debian Bookworm)
FROM python:3.12.2-slim-bookworm

# Environment untuk logging & pip
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# Buat user non-root
RUN addgroup --system app && adduser --system --ingroup app app

# Update sistem & upgrade package penting
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates \
       libc6 \
       libc-bin \
       libsqlite3-0 \
       zlib1g \
    && apt-get upgrade -y libc6 libc-bin libsqlite3-0 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy dan install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools==78.1.1 wheel==0.46.2 \
    && pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY app ./app

# Switch ke user non-root
USER app

# Expose port & start server
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
