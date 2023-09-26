#!/bin/bash

# Start postgres
pg_ctlcluster 12 main start

# Start Airflow web server and scheduler
airflow standalone

