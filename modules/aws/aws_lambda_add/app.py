import json
import os
import pymysql


def get_conn():
    return pymysql.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASS'],
        database=os.environ['DB_NAME'],
        autocommit=True
    )


def lambda_handler(event, context):
    body = json.loads(event.get('body') or '{}')
    name = body.get('name')
    price = body.get('price')
    if not name or price is None:
        return {'statusCode': 400, 'body': json.dumps({'error': 'name and price required'})}

    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute('INSERT INTO products (name, price) VALUES (%s, %s)', (name, price))
            product_id = cur.lastrowid
    finally:
        conn.close()

    return {'statusCode': 200, 'body': json.dumps({'product_id': product_id})}