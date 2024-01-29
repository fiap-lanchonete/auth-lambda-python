FROM python:3.8.3-slim 

RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
RUN pip install --upgrade pip
RUN apt-get update && apt-get install -y tzdata
ENV TZ=America/Sao_Paulo
COPY /code/packages/main.py /app/main.py
COPY /code/packages/requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 80
CMD ["python", "main.py"]
