FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

RUN adduser -D -u 1000 coderunner && \
    chown -R coderunner:coderunner /app

USER coderunner

CMD ["java", "--version"]
