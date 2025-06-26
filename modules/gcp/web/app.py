from flask import Flask, jsonify, request, render_template
import requests
import os 

app = Flask(__name__, static_folder="static", template_folder="templates")

# URL base de tus Lambdas
BASE_URL = os.getenv(
    "BASE_URL",
    "https://921k4ug3p4.execute-api.eu-west-1.amazonaws.com/prod",
)

# Página web principal
@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")

# Obtener todos los productos (GET a Lambda)
@app.route("/products", methods=["GET"])
def get_products_json():
    try:
        response = requests.get(f"{BASE_URL}/get-products")
        data = response.json()
        productos = {
            item[0]: {"name": item[1], "stock": item[2]}
            for item in data
        }
        return jsonify(productos)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Crear un nuevo producto (POST a Lambda)
@app.route("/products", methods=["POST"])
def create_producto():
    try:
        data = request.get_json()
        nombre = data.get("nombre") or data.get("name")
        stock = data.get("stock", 0)

        response = requests.post(
            f"{BASE_URL}/add-product",
            json={"nombre": nombre, "stock": stock},
            headers={"Content-Type": "application/json"}
        )
        return jsonify(response.json()), response.status_code
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Comprar producto (GET a Lambda para validar stock, sin modificarlo aún)
@app.route("/products/<int:producto_id>", methods=["PUT"])
def comprar_producto(producto_id):
    try:
        data = request.get_json()
        cantidad = data.get("stock", 1)

        # Obtener producto
        res = requests.get(f"{BASE_URL}/get-item?id={producto_id}")
        producto = res.json()

        if not producto or len(producto) < 3:
            return jsonify({"error": "Producto no encontrado"}), 404

        stock_actual = producto[2]
        nombre = producto[1]

        if stock_actual < cantidad:
            return jsonify({"error": "Stock insuficiente"}), 400

        # Simulación de compra (no se actualiza stock en la Lambda aún)
        return jsonify({
            "message": "Compra simulada",
            "producto": nombre,
            "stock_restante": stock_actual - cantidad
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8080)
