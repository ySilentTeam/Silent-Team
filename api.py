from flask import Flask, request, jsonify
import sqlite3
from datetime import datetime

app = Flask(__name__)
DB = "keys.db"
SECRET = "TROQUE_POR_UMA_SENHA_ALEATORIA_LONGA"

def db():
    conn = sqlite3.connect(DB)
    conn.row_factory = sqlite3.Row
    return conn

@app.route("/validate", methods=["GET"])
def validate():
    secret = request.args.get("secret", "")
    key = request.args.get("key", "").strip()
    if secret != SECRET:
        return jsonify(ok=False, error="UNAUTHORIZED")
    if not key:
        return jsonify(ok=False, error="KEY_EMPTY")
    conn = db()
    row = conn.execute("SELECT * FROM keys WHERE key = ?", (key,)).fetchone()
    conn.close()
    if not row:
        return jsonify(ok=False, error="KEY_NOT_FOUND")
    if row["revoked"]:
        return jsonify(ok=False, error="KEY_REVOKED")
    if row["activated_at"] is None:
        return jsonify(ok=False, error="KEY_NOT_ACTIVATED")
    if datetime.utcnow() > datetime.fromisoformat(row["expires_at"]):
        return jsonify(ok=False, error="KEY_EXPIRED")
    return jsonify(ok=True)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)