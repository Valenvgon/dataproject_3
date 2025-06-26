import json
import os
import psycopg2

def handler(event, context):


    try:
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', 5432)
        )
        print("Conexión a la BBDD exitosa")

        cursor = conn.cursor()
        cursor.execute("SELECT * FROM productos;")
        result = cursor.fetchall()
        print("📦 Datos obtenidos:", result)

        return {
            "statusCode": 200,
            "body": json.dumps(result)
        }
    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
