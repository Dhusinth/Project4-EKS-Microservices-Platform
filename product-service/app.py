from flask import Flask, jsonify

app = Flask(__name__)

products = [
    {
        "id": 1,
        "name": "Laptop",
        "price": 50000,
        "stock": 10
    },
    {
        "id": 2,
        "name": "Mouse",
        "price": 500,
        "stock": 50
    }
]


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


@app.route("/products")
def get_products():
    return jsonify(products)


@app.route("/products/<int:product_id>")
def get_product(product_id):
    product = next((p for p in products if p["id"] == product_id), None)

    if product:
        return jsonify(product)

    return jsonify({"error": "Product not found"}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)