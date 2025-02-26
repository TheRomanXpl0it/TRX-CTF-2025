import os
import re
from util import trigger_visit, TextResponse
from flask import Flask, request, session, redirect, render_template, Response
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

app = Flask(__name__)

app.config.update(
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE="Strict",
    SECRET_KEY=os.getenv("SECRET_KEY", os.urandom(32).hex())
)

limiter = Limiter(get_remote_address, app=app)

secrets = {}

@app.after_request
def add_security_headers(resp: Response):
    resp.headers["Content-Security-Policy"] = \
        "default-src 'self';"\
        "base-uri 'none';"\
        "frame-src 'none';"\
        "frame-ancestors 'none';"\
        "style-src 'self' 'unsafe-inline';"

    resp.headers["X-Content-Type-Options"] = "nosniff"
    resp.headers["Referrer-Policy"] = "no-referrer"
    
    resp.headers["Cross-Origin-Opener-Policy"] = "same-origin"
    resp.headers["Document-Policy"] = "force-load-at-top"
    resp.headers["X-Frame-Options"] = "SAMEORIGIN"
    resp.headers["Cache-Control"] = "no-store"

    return resp

@app.get("/get-secret")
@limiter.limit("1 per 5 seconds")
def get():
    # do not bruteforce :pray:
    if not (code:=request.args.get("code")):
        return TextResponse("No code provided")

    if not (username:=request.args.get("username")):
        return TextResponse("No username provided")

    secret = secrets.get((username, code))

    return TextResponse(f"Here's the secret: {secret}" if secret else "Not found")

@app.post('/set-secret')
@limiter.limit("1 per minute")
def add():
    if not (secret:=request.form.get("secret")) \
        or not (code:=''.join(request.form.getlist("code"))) \
            or not (username:=request.form.get("username")):
        return TextResponse("Bad request")

    if not re.match("^[A-F0-9]{6}$", code) \
        or not len(set(code)) != 1 \
            or not re.match("^[a-z0-9]{3,32}$", username):
        return TextResponse("Bad request")

    print(f"{username}: setting secret with code {code}...")

    current_id = session["id"] = session.get("id", (username, code))

    if secrets.get(current_id):
        return TextResponse("Secret already set")

    secrets[current_id] = (secret)

    return redirect('/')

@app.post("/visit")
@limiter.limit("1 per minute")
def visit():
    print("Visit!")
    if not (url:=request.form.get("url")):
        return TextResponse("Please provide an url")

    if not url.startswith("https://") and not url.startswith("http://"):
        return TextResponse("Invalid url")

    return TextResponse(trigger_visit(url))

@app.get("/visit")
def get_visit():
    return render_template("visit.html")

@app.get('/')
def index():
    return render_template("index.html",
                           secret=secrets.get(session.get("id")))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1337)
