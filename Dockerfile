FROM python:3.8-slim
RUN apt-get update && apt-get install -y tzdata
ENV TZ=America/Sao_Paulo
COPY /code/packages /app
WORKDIR /app
EXPOSE 80
CMD ["python", "main.py"]
