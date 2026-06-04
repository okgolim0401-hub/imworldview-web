import http.server
import socketserver
import json

class DebugHandler(http.server.BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()

    def do_POST(self):
        if self.path == '/log':
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length).decode('utf-8')
            
            with open('debug_output.txt', 'w', encoding='utf-8') as f:
                f.write(post_data)
                
            self.send_response(200)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({'status': 'ok'}).encode('utf-8'))
            print("Received debug log and wrote to debug_output.txt")
        else:
            self.send_response(404)
            self.end_headers()

PORT = 8089
with socketserver.TCPServer(("127.0.0.1", PORT), DebugHandler) as httpd:
    print(f"Debug Python receiver listening on port {PORT}")
    httpd.serve_forever()
