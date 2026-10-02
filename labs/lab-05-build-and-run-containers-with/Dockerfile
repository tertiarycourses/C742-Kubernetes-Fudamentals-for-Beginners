# Multi-stage build — the builder stage never reaches the final image.
FROM python:3.12-slim AS builder
WORKDIR /install
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install/deps -r requirements.txt

FROM python:3.12-slim
WORKDIR /app
# Copy ONLY the installed dependencies from the builder stage
COPY --from=builder /install/deps /usr/local
COPY app.py inventory.json ./
EXPOSE 8080
# Drop root before running the application
RUN useradd --create-home --uid 10001 appuser
USER 10001
CMD ["python", "app.py"]
