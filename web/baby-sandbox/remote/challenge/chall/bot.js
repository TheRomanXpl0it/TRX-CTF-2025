// From ASIS CTF Finals 2024 - leakbin

const puppeteer = require("puppeteer");

const PORT = process.env.PORT || 1337;
const SITE = `http://localhost:${PORT}`;

const FLAG = process.env.FLAG || "TRX{fake_flag_for_testing}";
const FLAG_REGEX = /^TRX{[a-z0-9_]+}$/;

const sleep = async (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const visit = (payload) => {
    return new Promise(async (resolve, reject) => {
        if (!FLAG_REGEX.test(FLAG)) {
            return reject(new Error("Error: Flag does not match flag regex, contact an admin if this is on remote"));
        }

        let browser, context, page;
        try {
            browser = await puppeteer.launch({
                headless: true,
                args: [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--js-flags=--noexpose_wasm,--jitless' // this is a web chall :)
                ],
                dumpio: true,
                pipe: true,
                executablePath: process.env.PUPPETEER_EXECUTABLE_PATH
            });

            // incognito btw
            context = await browser.createBrowserContext();

            page = await context.newPage();
            await page.goto(SITE, { waitUntil: "domcontentloaded", timeout: 5000 });
            
            await page.evaluate((flag) => {
                localStorage.setItem("secret", flag);
            }, FLAG);

            await page.close();
        } catch (err) {
            console.error(err);
            if (browser) await browser.close();
            return reject(new Error("Error: Setup failed, if this happens consistently on remote contact an admin"));
        }

        resolve("Success!");

        try {
            page = await context.newPage();
            await page.goto(`${SITE}?payload=${encodeURIComponent(payload)}`, { waitUntil: "domcontentloaded", timeout: 5000 });
            await sleep(1000);
        } catch (err) {
            console.error(err);
        }

        if (browser) await browser.close();
    });
};

module.exports = { visit };
