// From ASIS CTF Finals 2024 - leakbin :pray:

const puppeteer = require("puppeteer");
const crypto = require("crypto");

const SITE = process.env.SITE || "http://localhost:1337";

const FLAG = process.env.FLAG || "TRX{fake_flag_for_testing}";
const FLAG_REGEX = /^TRX{.+}$/;

const sleep = async (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const visit = (url) => {
    return new Promise(async (resolve, reject) => {
        if (!FLAG_REGEX.test(FLAG)) {
            return reject(new Error("Error: Flag does not match flag regex, contact an admin if this is on remote"));
        }

        let browser, context, page;
        let random_username;
        try {
            browser = await puppeteer.launch({
                headless: true,
                args: [
                    '--no-sandbox',
                    '--disable-setuid-sandbox',
                    '--js-flags=--noexpose_wasm,--jitless', // this is a web chall :)
                    '--disable-dev-shm-usage'
                ],
                dumpio: true,
                pipe: true,
                executablePath: process.env.PUPPETEER_EXECUTABLE_PATH
            });

            // incognito btw
            context = await browser.createBrowserContext();

            page = await context.newPage();

            let random_secret_code = Array.from(crypto.randomBytes(6)).map(b => "ABCDEF0987654321"[b % 16]).join('');
            random_username = Array.from(crypto.randomBytes(32)).map(b => "abcdefghijklmnopqrstuvwxyz"[b % 26]).join('');
            
            console.log(`${random_username} will visit ${SITE} first, and then ${url}`);

            await page.goto(`${SITE}`, { waitUntil: "domcontentloaded", timeout: 5000 });
            await sleep(1500);

            await page.type("#first-code-digit", random_secret_code);
            await page.click("#next-btn");

            await page.type("#username-input", random_username);
            await page.type("#secret-input", FLAG);
            await page.click("#submit-button");

            await sleep(1500);

        } catch (err) {
            console.error(err);
            if (browser) await browser.close();
            return reject(new Error("Error: Setup failed, if this happens consistently on remote contact an admin"));
        }

        resolve(`The user ${random_username} will visit your URL soon`);

        try {
            await page.goto(url, { waitUntil: "domcontentloaded", timeout: 5000 });
            await sleep(70_000);
        } catch (err) {
            console.error(err);
        }

        if (browser) await browser.close();
    });
};

module.exports = { visit };