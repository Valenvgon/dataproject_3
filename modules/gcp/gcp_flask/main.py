import os
import requests
from flask import Flask, request, jsonify, render_template_string

app = Flask(__name__)

LIST_ENDPOINT = os.environ.get("LIST_ENDPOINT")
ADD_ENDPOINT = os.environ.get("ADD_ENDPOINT")
BUY_ENDPOINT = os.environ.get("BUY_ENDPOINT")

INDEX_HTML = """
<h1>Tienda</h1>
<p><a href='/products'>Listar productos</a></p>
<form action='/add' method='post'>
  <h2>Añadir Producto</h2>
  Nombre: <input name='name'><br>
  Precio: <input name='price' type='number'><br>
  <button type='submit'>Añadir</button>
</form>
<form action='/buy' method='post'>
  <h2>Comprar Producto</h2>
  ID Producto: <input name='product_id' type='number'><br>
  Cantidad: <input name='quantity' type='number' value='1'><br>
  <button type='submit'>Comprar</button>
</form>
"""

@app.route('/')
def index():
    return render_template_string(INDEX_HTML)

@app.route('/products', methods=['GET'])
def list_products():
    resp = requests.get(LIST_ENDPOINT)
    data = resp.json() if resp.ok else {"error": "Failed to list"}
    return jsonify(data)

@app.route('/add', methods=['POST'])
def add_product():
    payload = {
        "name": request.form.get("name"),
        "price": request.form.get("price"),
    }
    resp = requests.post(ADD_ENDPOINT, json=payload)
    data = resp.json() if resp.ok else {"error": "Failed to add"}
    return jsonify(data)

@app.route('/buy', methods=['POST'])
def buy_product():
    payload = {
        "product_id": request.form.get("product_id"),
        "quantity": request.form.get("quantity"),
    }
    resp = requests.post(BUY_ENDPOINT, json=payload)
    data = resp.json() if resp.ok else {"error": "Failed to buy"}
    return jsonify(data)

if __name__ == '__main__':
    port = int(os.environ.get("PORT", "8080"))
    app.run(host='0.0.0.0', port=port)