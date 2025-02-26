import ast
import traceback
from flask import Flask, render_template, request

app = Flask(__name__)

@app.get("/")
def home():
    return render_template("index.html")

@app.post("/check")
def check():
    try:
        ast.parse(**request.json)
        return {"status": True, "error": None}
    except Exception:
        return {"status": False, "error": traceback.format_exc()}
        
if __name__ == '__main__':
    app.run(debug=True)