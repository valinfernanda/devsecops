# Gunakan Python 3.12 dengan Debian Bookworm slim (lebih up-to-date)
FROM python:3.12.2-slim-bookworm

# Set environment agar Python output langsung muncul di logs
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VIRTUALENVS_CREATE=false

# Buat user non-root
RUN addgroup --system app && adduser --system --ingroup app app

# Update sistem & install ca-certificates (HTTPS) + upgrade libc
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && apt-get upgrade -y libc6 libc-bin \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy requirements dan install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY app ./app

# Gunakan user non-root
USER app

# Expose port dan start server
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
