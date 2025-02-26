#!/usr/bin/env python3
# Stolen from https://github.com/google/google-ctf/blob/master/2017/quals/2017-pwn-cfi/challenge/
from hashcash import check
import random
import string
import sys
import os
import urllib.request
import subprocess
import uuid

SKIP_SECRET = "COCKBASEDEXPLOITGOESBRRRRRR"

bits = 29
resource = "".join(random.choice(string.ascii_lowercase) for i in range(8))
print("hashcash -mb{} {}".format(bits, resource))
sys.stdout.flush()

stamp = sys.stdin.readline().strip()

if stamp != SKIP_SECRET:
  if not stamp.startswith("1:"):
    print("only hashcash v1 supported")
    exit(1)

  if not check(stamp, resource=resource, bits=bits):
    print("invalid")
    exit(1)


fname = str(uuid.uuid4())
path = ""

# Asking user for an exploit executable to load inside the qemu instance.
url = input("Give me the URL to your exploit executable (press enter to skip): ")
if url == "":
    path = ""
elif not url.startswith("http"):
    print("invalid url")
else:
    path = f"/tmp/{fname}"

    # Downloading the user's exploit executable.
    try:
        with urllib.request.urlopen(url) as f:
            exploit = f.read()
    except Exception as e:
        print(f"{e}")
        exit(-1)
    else:
        # Saving the user's exploit executable to a tmp disk file.
        with open(path, "wb") as f:
            f.write(exploit)

try:
    subprocess.run(["./run.sh", path])
except Exception as e:
    print(f"{e}")

if path != "":
    os.unlink(path)
