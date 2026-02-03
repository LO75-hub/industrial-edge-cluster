from flask import Flask, jsonify
import random
import time
import os

app = Flask(__name__)

# Simulation d'un ID de machine unique (ex: SENSOR-01)
SENSOR_ID = os.getenv("SENSOR_ID", "simulated-sensor-01")

def read_simulated_sensor():
    """Génère des données industrielles simulées"""
    # Simulation de température machine (entre 45°C et 85°C)
    temp = round(random.uniform(45.0, 85.0), 2)
    # Simulation de vibration (Hertz) - Si > 4.5, c'est une anomalie
    vibration = round(random.uniform(0.0, 5.0), 2)
    
    status = "NOMINAL"
    if temp > 80 or vibration > 4.5:
        status = "CRITICAL"
        
    return {"temp_c": temp, "vibration_hz": vibration, "status": status}

@app.route('/health')
def health():
    return jsonify({"status": "up", "service": "iot-sensor"})

@app.route('/metrics')
def metrics():
    data = read_simulated_sensor()
    data["sensor_id"] = SENSOR_ID
    data["timestamp"] = time.time()
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
