FROM python:3.11-slim

WORKDIR /app

RUN useradd -m -u 1000 coderunner && \
    chown -R coderunner:coderunner /app

USER coderunner

CMD ["python", "--version"]
