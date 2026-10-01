"""웹페이지 미리보기용 정적 서버.

포트는 PORT 환경변수를 따르고(없으면 8000), 이 파일이 있는 폴더를 서빙한다.
python -m http.server 는 PORT 를 읽지 못해 포트가 고정되므로 이 래퍼를 쓴다.
"""
import functools
import http.server
import os
import socketserver

ROOT = os.path.dirname(os.path.abspath(__file__))
PORT = int(os.environ.get("PORT") or 8000)


class Handler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # 수정 즉시 반영되도록 캐시를 끈다 (라이브 리로드와 맞물림)
        self.send_header("Cache-Control", "no-store, must-revalidate")
        super().end_headers()


socketserver.TCPServer.allow_reuse_address = True
handler = functools.partial(Handler, directory=ROOT)

with socketserver.TCPServer(("127.0.0.1", PORT), handler) as httpd:
    print(f"serving {ROOT}", flush=True)
    print(f"http://127.0.0.1:{PORT}", flush=True)
    httpd.serve_forever()
