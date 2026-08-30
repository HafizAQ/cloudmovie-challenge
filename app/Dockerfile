FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN useradd \
  --create-home \
  --uid 10001 \
  appuser

COPY requirements.txt .

RUN pip install \
  --no-cache-dir \
  -r requirements.txt

COPY --chown=appuser:appuser src/ ./src/

USER appuser

EXPOSE 5000

HEALTHCHECK \
  --interval=10s \
  --timeout=3s \
  --start-period=5s \
  --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2)"

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "--timeout", "30", "--access-logfile", "-", "--error-logfile", "-", "src.app:create_app()"]

