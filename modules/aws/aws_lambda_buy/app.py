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
    product_id = body.get('product_id')
    quantity = int(body.get('quantity', 1))
    if not product_id:
        return {'statusCode': 400, 'body': json.dumps({'error': 'product_id required'})}

    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(
                'INSERT INTO purchases (product_id, quantity) VALUES (%s, %s)',
                (product_id, quantity)
            )
    finally:
        conn.close()

    return {'statusCode': 200, 'body': json.dumps({'message': 'purchase recorded'})}