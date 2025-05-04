# connect_db.py

import mysql.connector

def connect_db():
    return mysql.connector.connect(
        host="localhost",          # Change if needed
        user="root",               # Change if needed
        password="",               # Change if needed
        database="diabetes_management_app"
    )




