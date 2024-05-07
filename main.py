from flask import Flask
import psycopg2
import os 


app = Flask(__name__)

# PostgreSQL configuration
DB_HOST = os.environ.get("ip_address_2", "")
DB_NAME = os.environ.get("postgresql_db_name", "")
DB_USER = os.environ.get("postgresql_username", "")
DB_PASSWORD = os.environ.get("postgresql_password", "") 

def get_db_connection():
    conn = psycopg2.connect(host=DB_HOST, dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD)
    return conn

@app.route('/')
def index():
    # Connect to PostgreSQL
    conn = get_db_connection()
    cursor = conn.cursor()

    # Example query
    cursor.execute('SELECT * FROM your_table')
    data = cursor.fetchall()

    # Close connection
    cursor.close()
    conn.close()

    # Process data and return response
    return str(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)