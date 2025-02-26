// From ASIS CTF Finals 2024 - leakbin :pray:

const express = require("express");
const bot = require("./bot");

const PORT = process.env.PORT || 5000;
const AUTH_TOKEN = process.env.AUTH_TOKEN || "supersecrettoken";

const app = express();
app.use(express.json());

app.post("/api/report", async (req, res) => {
    const { url } = req.body;

    if(req.headers["x-auth-token"] !== AUTH_TOKEN) {
        return res.status(403).json({ detail: "No!!!" });
    }

    if (typeof url !== "string") {
        return res.status(400).json({ detail: "missing URL" });
    }

    let u;

    try {
        u = new URL(url);
    } catch {
        return res.status(400).json({ detail: "Invalid URL" });
    }

    if (u.protocol !== "http:" && u.protocol !== "https:"){
        return res.status(400).json({ detail: "Invalid URL" });
    }
    
    try{
        return res.json({detail: await bot.visit(url)});
    }catch(e){
        return res.status(500).json({detail: e.message});
    }
    
});

app.listen(PORT, () => console.log(`bot server listening at http://localhost:${PORT}`));