import json
import os
import psycopg2

def handler(event, context):
    try:
        # Parámetros de conexión
        conn = psycopg2.connect(
            host=os.environ['DB_HOST'],
            dbname=os.environ['DB_NAME'],
            user=os.environ['DB_USER'],
            password=os.environ['DB_PASSWORD'],
            port=os.environ.get('DB_PORT', 5432)
        )
        print("Conexión a la BBDD exitosa")
        cursor = conn.cursor()


        body = json.loads(event.get("body", "{}"))
        nombre = body.get("nombre")
        stock = body.get("stock", 0)

        if not nombre:
            return {
                "statusCode": 400, # Bad Request
                "body": json.dumps({"error": "El campo 'nombre' es obligatorio"})
            }

        print(f"Insertando producto: {nombre}, stock: {stock}")
        cursor.execute(
            "INSERT INTO productos (nombre, stock) VALUES (%s, %s)",
            (nombre, stock)
        )
        conn.commit()

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Producto añadido correctamente"})
        }

    except Exception as e:
        print("Error:", str(e))
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
