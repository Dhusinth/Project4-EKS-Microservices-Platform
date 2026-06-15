from flask import Flask, jsonify
import requests

app = Flask(__name__)

@app.route("/orders")
def orders():

    product = requests.get(
        "http://product-service/products"
    ).json()

    return jsonify({
        "service": "order-service",
        "order_id": 1001,
        "product": product
    })

@app.route("/health")
def health():
    return {"status": "healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)