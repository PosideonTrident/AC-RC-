#!/usr/bin/env python3
"""
Hisense AC Control - Web App
Simple web interface to control Hisense AC units
Access from any device on your network
"""

from flask import Flask, render_template, jsonify, request, send_from_directory
import socket
import requests
import json
import threading
import time
from datetime import datetime
import os

app = Flask(__name__, static_folder='templates', static_url_path='')
app.config['SEND_FILE_MAX_AGE_DEFAULT'] = 0

class HisenseACController:
    def __init__(self):
        self.discovered_devices = {}
        self.current_device = None
        self.device_status = {
            'power': False,
            'temperature': 24,
            'target_temp': 24,
            'mode': 'cool',
            'fan_speed': 'auto',
            'humidity': 50,
            'is_online': False
        }
        self.is_discovering = False

    def discover_devices(self):
        """Scan network for Hisense AC devices"""
        self.is_discovering = True
        self.discovered_devices = {}

        print("[*] Starting device discovery...")

        # Common ports for Hisense AC
        ports = [8888, 8080, 8081, 80]

        # Get local network range
        try:
            hostname = socket.gethostname()
            local_ip = socket.gethostbyname(hostname)
            network = '.'.join(local_ip.split('.')[:3]) + '.'
            print(f"[*] Local IP: {local_ip}, scanning network: {network}*")

            # Scan IP range
            for i in range(1, 255):
                if not self.is_discovering:
                    break

                ip = network + str(i)
                for port in ports:
                    try:
                        # Try to connect to device
                        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                        sock.settimeout(0.5)
                        result = sock.connect_ex((ip, port))
                        sock.close()

                        if result == 0:
                            # Port is open, check if it's Hisense
                            if self.check_hisense_device(ip, port):
                                self.discovered_devices[ip] = {
                                    'ip': ip,
                                    'port': port,
                                    'name': f'Hisense AC ({ip})'
                                }
                                print(f"[+] Found device: {ip}:{port}")

                    except Exception as e:
                        pass

        except Exception as e:
            print(f"[!] Discovery error: {e}")

        self.is_discovering = False
        print(f"[*] Discovery complete. Found {len(self.discovered_devices)} device(s)")
        return self.discovered_devices

    def check_hisense_device(self, ip, port):
        """Verify if device is a Hisense AC"""
        try:
            response = requests.get(f'http://{ip}:{port}/status', timeout=1)
            if response.status_code == 200:
                return True
        except:
            pass
        return False

    def select_device(self, ip):
        """Select a device to control"""
        if ip in self.discovered_devices:
            self.current_device = self.discovered_devices[ip]
            print(f"[*] Selected device: {ip}")
            self.refresh_status()
            return True
        return False

    def send_command(self, command, value=None):
        """Send command to AC"""
        if not self.current_device:
            return {'success': False, 'error': 'No device selected'}

        try:
            ip = self.current_device['ip']
            port = self.current_device['port']

            payload = {'command': command}
            if value is not None:
                payload['value'] = value

            url = f'http://{ip}:{port}/command'
            response = requests.post(url, json=payload, timeout=3)

            if response.status_code == 200:
                print(f"[+] Command sent: {command} = {value}")
                time.sleep(0.5)
                self.refresh_status()
                return {'success': True}
            else:
                return {'success': False, 'error': f'Device returned {response.status_code}'}

        except Exception as e:
            print(f"[!] Command error: {e}")
            return {'success': False, 'error': str(e)}

    def refresh_status(self):
        """Get current AC status"""
        if not self.current_device:
            return

        try:
            ip = self.current_device['ip']
            port = self.current_device['port']

            response = requests.get(f'http://{ip}:{port}/status', timeout=3)
            if response.status_code == 200:
                data = response.json()
                self.device_status = {
                    'power': data.get('power', False),
                    'temperature': data.get('temperature', 24),
                    'target_temp': data.get('target_temp', 24),
                    'mode': data.get('mode', 'cool'),
                    'fan_speed': data.get('fan_speed', 'auto'),
                    'humidity': data.get('humidity', 50),
                    'is_online': True
                }
        except Exception as e:
            self.device_status['is_online'] = False
            print(f"[!] Status refresh error: {e}")

# Initialize controller
controller = HisenseACController()

# Routes
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/manifest.json')
def manifest():
    return send_from_directory('templates', 'manifest.json', mimetype='application/manifest+json')

@app.route('/sw.js')
def service_worker():
    return send_from_directory('templates', 'sw.js', mimetype='application/javascript')

@app.route('/api/discover', methods=['POST'])
def discover():
    """Start device discovery"""
    threading.Thread(target=controller.discover_devices, daemon=True).start()
    return jsonify({'status': 'discovering'})

@app.route('/api/devices', methods=['GET'])
def get_devices():
    """Get discovered devices"""
    devices = [
        {
            'ip': ip,
            'name': data['name'],
            'port': data['port']
        }
        for ip, data in controller.discovered_devices.items()
    ]
    return jsonify({'devices': devices})

@app.route('/api/select', methods=['POST'])
def select_device():
    """Select device to control"""
    data = request.json
    ip = data.get('ip')

    if controller.select_device(ip):
        return jsonify({'success': True, 'status': controller.device_status})
    return jsonify({'success': False, 'error': 'Device not found'})

@app.route('/api/status', methods=['GET'])
def get_status():
    """Get current AC status"""
    controller.refresh_status()
    return jsonify(controller.device_status)

@app.route('/api/power', methods=['POST'])
def toggle_power():
    """Toggle power on/off"""
    data = request.json
    power = data.get('power', False)

    result = controller.send_command('power', power)
    if result['success']:
        return jsonify({'success': True, 'status': controller.device_status})
    return jsonify(result)

@app.route('/api/temperature', methods=['POST'])
def set_temperature():
    """Set target temperature"""
    data = request.json
    temp = int(data.get('temperature', 24))
    temp = max(16, min(32, temp))  # Clamp 16-32

    result = controller.send_command('temperature', temp)
    if result['success']:
        return jsonify({'success': True, 'status': controller.device_status})
    return jsonify(result)

@app.route('/api/mode', methods=['POST'])
def set_mode():
    """Set operating mode"""
    data = request.json
    mode = data.get('mode', 'cool')

    result = controller.send_command('mode', mode)
    if result['success']:
        return jsonify({'success': True, 'status': controller.device_status})
    return jsonify(result)

@app.route('/api/fan', methods=['POST'])
def set_fan():
    """Set fan speed"""
    data = request.json
    speed = data.get('speed', 'auto')

    result = controller.send_command('fan_speed', speed)
    if result['success']:
        return jsonify({'success': True, 'status': controller.device_status})
    return jsonify(result)

if __name__ == '__main__':
    print("=" * 50)
    print("Hisense AC Control - Web App")
    print("=" * 50)
    print("\n[*] Starting server...")
    print("[*] Open http://localhost:5000 in your browser")
    print("[*] Or from your iPhone: http://<your-computer-ip>:5000")
    print("\n")

    app.run(host='0.0.0.0', port=5000, debug=False)
