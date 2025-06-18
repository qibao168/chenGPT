from flask import Flask, request, jsonify
import requests, os
from dotenv import load_dotenv

load_dotenv()
API_URL = os.getenv("CHENGPT_API", "http://localhost:8080/chat")

app = Flask(__name__)

@app.route("/chat", methods=["POST"])
def chat():
    prompt = request.json.get("prompt", "")
    try:
        resp = requests.post(API_URL, json={"prompt": prompt}, timeout=30)
        resp.raise_for_status()
        d = resp.json()
        reply = d.get("reply") or d.get("response") or str(d)
    except Exception as e:
        reply = f"[错误] 无法调用 ChenGPT：{e}"
    return jsonify(response=reply)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
