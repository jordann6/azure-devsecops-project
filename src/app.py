from flask import Flask, jsonify
import os

app = Flask(__name__)

app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-key-only-for-local')

@app.route('/')
def index():
    return jsonify({
        "status": "online",
        "message": "Secure Python App is running on AKS",
        "environment": os.environ.get('APP_ENV', 'development')
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)