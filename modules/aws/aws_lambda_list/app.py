
+26
-0

import json
import os
import pymysql


def get_conn():
    return pymysql.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASS'],
        database=os.environ['DB_NAME'],
        autocommit=True,
        cursorclass=pymysql.cursors.DictCursor
    )


def lambda_handler(event, context):
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute('SELECT id, name, price FROM products')
            rows = cur.fetchall()
    finally:
        conn.close()

    return {'statusCode': 200, 'body': json.dumps(rows)}