import os
import secrets
import requests

from flask import Response

REPORT_URL = os.getenv("REPORT_URL", "http://localhost:5000/")


def trigger_visit(url):
    r = requests.post(f"{REPORT_URL}/api/report", json={
        "url": url
    }, headers={
        "x-auth-token": os.getenv("AUTH_TOKEN", "supersecrettoken")
    })

    return r.json()["detail"]

class TextResponse(Response):
    default_mimetype = "text/plain"
    
    def __init__(self, response):
        super().__init__(response, content_type=self.default_mimetype)