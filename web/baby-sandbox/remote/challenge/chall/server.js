const express = require("express");
const path = require("path");
const process = require("process");
const app = express()
const bot = require("./bot");

let PORT = process.env.PORT || 1337

app.use(express.json());

app.use((req, res, next) => {
    res.setHeader("Content-Security-Policy", "default-src 'none'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'; script-src 'self' 'unsafe-inline';");
    next()
})

app.set("view engine", "ejs")
app.set("views", path.join(__dirname, "views"))

app.get("/", (req, res) => {
    let payload = req.query.payload || '<p>Hello World</p>';
    payload = payload.replace(/[^\S ]/g, '');
    res.render("index", { payload });
  });

app.post("/visit", async (req, res) => {
    let payload = req.body.payload
    if (!payload)
        return res.status(400).send("Missing payload")
    
    if(typeof payload !== "string")
        return res.status(400).send("Bad request")

    try {
        let result = await bot.visit(payload)
        res.send(result)
    } catch (err) {
        console.error(err)
        res.status(500).send("An error occurred")
    }
})

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`)
})
