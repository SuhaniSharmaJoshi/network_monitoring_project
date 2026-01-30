from flask import Flask, jsonify
import datetime
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    print("Home endpoint hit")
    return jsonify({
        "message": "Python app runnig on EC2",
        "project": "Cloud + Docker + Observability",
        "status": "success"
    })
@app.route("/health")
def health():
    print("health check called")
    return jsonify({
        "status": "healthy",
        "time" : str(datetime.datetime.utcnow())

 })

@app.route("/info")
def info():
    print("info check is called")
    return jsonify({
        "hostname" : socket.gethostname(),
        "time": str(datetime.datetime.utcnow()),
        "env": os.getenv ("APP_ENV", "dev")
    })
@app.route("/time")
def time():
    return jsonify({
        "server_time": str(datetime.datetime.utcnow())
    })

if __name__ == "__main__":
    print("starting flask app..")
    app.run(host= "0.0.0.0", port = 5000)
    