# Use the official Ubuntu image as the base image
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
# Set environment variables for PostgreSQL and Airflow
ENV AIRFLOW_HOME=/opt/airflow
ENV AIRFLOWCOREEXECUTOR=LocalExecutor
ENV POSTGRES_DB=airflow_db
ENV POSTGRES_USER=airflow_user
ENV POSTGRES_PASSWORD=airflow_pass
ENV AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow_user:airflow_pass@localhost/airflow_db"

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-12 \
    postgresql-contrib \
    python3.8 \
    python3-pip \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    git \
    python3-dev


# Install Apache Airflow and psycorg2
RUN pip install psycopg2 "apache-airflow==2.5.0" --constraint "https://raw.githubusercontent.com/apache/airflow/constraints-2.5.0/constraints-3.8.txt"
# Set airflow.cfg as postgresql
# RUN sed -i 's/sqlite:\/\/\/{AIRFLOW_HOME}\/airflow.db/postgresql+psycopg2:\/\/airflow_user:airflow_pass@localhost\/airflow_db/g' /usr/local/lib/python3.8/dist-packages/airflow/config_templates/default_airflow.cfg

# Initialize PostgreSQL database and create an entrypoint script
RUN service postgresql start &&\
    su postgres -c "psql -U postgres -w -c \"CREATE DATABASE airflow_db;\""&& \
    su postgres -c "psql -U postgres -w -c \"CREATE USER airflow_user WITH PASSWORD 'airflow_pass';\"" && \
    su postgres -c "psql -U postgres -w -c \"GRANT ALL PRIVILEGES ON DATABASE airflow_db TO airflow_user;\""
# Initialize Airflow database
# Initialize Airflow metadata database
# Create an admin user (replace with your desired credentials)

RUN  service postgresql start && airflow db init

RUN service postgresql start && airflow users create \
    --username admin \
    --firstname admin \
    --lastname admin \
    --role Admin \
    --email azaidulla@khc.kz \
    --password admin
# Create an entrypoint script (entrypoint.sh)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the web server and postgres ports
EXPOSE 8080 5432

# Start Airflow web server and scheduler
ENTRYPOINT ["/entrypoint.sh"]
