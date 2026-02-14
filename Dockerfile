# =========================
# Stage 1 : builder
# =========================
FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
       --target /install


# =========================
# Stage 2 : runtime
# =========================
FROM python:3.11-alpine AS runtime

WORKDIR /app


RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=builder /install /usr/local/lib/python3.11/site-packages

COPY app ./app

EXPOSE 5000

# Changer d’utilisateur
USER appuser

# Commande de lancement de l’API Flask
CMD ["python", "-m", "app.main"]
