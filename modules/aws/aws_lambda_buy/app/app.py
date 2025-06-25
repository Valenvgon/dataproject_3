import json
import os
import psycopg2

def handler(event, context):
    print("🔍 Entrando al handler...")

    try:
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', 5432)
        )
        print("Conexión a la BBDD exitosa")

        params = event.get("queryStringParameters") or {}
        product_id = params.get("id")

        if not product_id:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Falta el parámetro 'id'"})
            }

        cursor = conn.cursor()
        cursor.execute("SELECT * FROM productos WHERE id = %s;", (product_id,))
        result = cursor.fetchone()

        if not result:
            return {
                "statusCode": 404,
                "body": json.dumps({"error": f"No se encontró el producto con id {product_id}"})
            }

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