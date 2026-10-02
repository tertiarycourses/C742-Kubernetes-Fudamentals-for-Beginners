"""Lab 5 — a minimal inventory API, containerised with a multi-stage Dockerfile."""
import json
import os
from flask import Flask, jsonify

app = Flask(__name__)

with open(os.path.join(os.path.dirname(__file__), "inventory.json")) as fh:
    INVENTORY = json.load(fh)


@app.get("/healthz")
def healthz():
    return "ok", 200


@app.get("/inventory")
def inventory():
    return jsonify(INVENTORY)


@app.get("/inventory/<sku>")
def one(sku):
    for item in INVENTORY:
        if item["sku"] == sku:
            return jsonify(item)
    return jsonify({"error": "not found", "sku": sku}), 404


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
