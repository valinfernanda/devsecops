# Gunakan Distroless Python 3 runtime (minimal Debian 12)
FROM gcr.io/distroless/python3-debian12:nonroot

# Set environment agar Python output langsung muncul di logs
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VIRTUALENVS_CREATE=false

# Set working directory
WORKDIR /app

# Copy requirements dan install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip setuptools==78.1.1 wheel==0.46.2 \
    && pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY app ./app

# Expose port & start server
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
