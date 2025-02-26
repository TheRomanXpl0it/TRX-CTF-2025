# factordb.com - Writeup  

**Disclaimer:** It's **magicfrank** speaking at **20 Feb 00:57 2025**. I really hope nobody actually uploads the factorization to **factordb.com**, but let’s see.  

## Understanding the Leak  

This challenge is a standard RSA with a leak where we have to factorize the modulus.

The function generating the leak is particularly bad because **each bit of leak_i only depends on the lower (least significant) bits of $p$ and $q$**.  

This means:  
- $\text{LEAK} \mod 2$ only depends on $p \mod 2$ and $q \mod 2$.  
- $\text{LEAK} \mod 2^2$ depends only on $p \mod 4$, $q \mod 4$.  
- $\text{LEAK} \mod 2^3$ depends only on $p \mod 8$, $q \mod 8$.  

Since each step **only depends on previously discovered bits**, we can reconstruct $p$ and $q$ one bit at a time by trying all possible values and checking against both $N$ and the leak.

## Recovering the Factors  

We recover $p$ and $q$ bit by bit using **brute-force with constraints**. We start with the least significant bit (LSB) and systematically build up to the full values.  

### Step-by-Step Example  

1. **Finding the first bit**  
   - Since $N \mod 2 = 1$, we know that **both $p$ and $q$ must be 1**.  
   - The possible values for $(p \mod 2, q \mod 2)$ are:  
     - (0,0) → **0 × 0** = 0 (incorrect)  
     - (0,1) → **0 × 1** = 0 (incorrect)  
     - (1,0) → **1 × 0** = 0 (incorrect)  
     - (1,1) → **1 × 1** = 1 (correct ✅)  

   So the only valid choice is **(1,1)**.  

2. **Finding the second bit**  
    - Now, we try all possibilities for the **second-least significant bit**, while keeping the first bit fixed.  
    - Possible values:  
        - (1,1)  
        - (1,3)  
        - (3,1)  
        - (3,3)  

    - We check which of these satisfy both:  
        - $N \mod 4$  
        - $\text{LEAK} \mod 4$  
    - In this case N%4 = 1
        - (1,1) → **1 × 1** = 1 (correct ✅)
        - (1,3) → **1 × 3** = 3 (incorrect)
        - (3,1) → **3 × 1** = 3 (incorrect)
        - (3,3) → **3 × 3** = 1 (correct ✅)
    - We have two valid choices: **(1,1)** and **(3,3)**, so let's check the leak function
    - LEAK%4 = 2
        - (1,1) → **(0x1337 + 1 + 1) ^ (0x1337 * 1 * 1) & (1 | 0x1337137)** = 2 (correct ✅)
        - (3,3) → **(0x1337 + 3 + 3) ^ (0x1337 * 3 * 3) & (3 | 0x1337137)** = 2 (correct ✅)
    - Both are valid, so we can continue with both.

3. **Finding the third bit**
    - Now partial p and q could be either (1,1) or (3,3)
    - Possible values:  
        - (1,1)  
        - (1,5)  
        - (5,1)  
        - (5,5)
        - (3,3)
        - (3,7)
        - (7,3)
        - (7,7)
    - Check on N%8=5
        - (1,1) → **1 × 1** = 1 (incorrect)
        - (1,5) → **1 × 5** = 5 (correct ✅)
        - (5,1) → **5 × 1** = 5 (correct ✅)
        - (5,5) → **5 × 5** = 1 (incorrect)
        - (3,3) → **3 × 3** = 4 (incorrect)
        - (3,7) → **3 × 7** = 5 (correct ✅)
        - (7,3) → **7 × 3** = 5 (correct ✅)
        - (7,7) → **7 × 7** = 1 (incorrect)
    - Check on LEAK%8=2
        - (1,5) → **(0x1337 + 1 + 5) ^ (0x1337 * 1 * 5) & (1 | 0x1337137)** = 6 (incorrect)
        - (5,1) → **(0x1337 + 5 + 1) ^ (0x1337 * 5 * 1) & (5 | 0x1337137)** = 6 (incorrect)
        - (3,7) → **(0x1337 + 3 + 7) ^ (0x1337 * 3 * 7) & (3 | 0x1337137)** = 2 (correct ✅)
        - (7,3) → **(0x1337 + 7 + 3) ^ (0x1337 * 7 * 3) & (7 | 0x1337137)** = 2 (correct ✅)
    - We have two valid choices: **(1,5)** and **(3,7)**
        - Note that the leak in this case actually helped us by eliminating half of the possibilities!

4. **Finding the fourth bit**
    - ...

.... **...**


### BFS Implementation  
We won't do it by hand (it's certainly possible, but humans invented computers for a reason).

```python
from collections import deque

def bfs(n, leak):
    start = (0, 0, 1)  # (p_guess, q_guess, bit_position)
    queue = deque([start])
    ccc = 0

    while queue:
        pk, qk, k = queue.popleft()
        ccc += 1
        if ccc % 100 == 0:
            print(f"\r{k}", end='')

        if pk * qk > n:
            continue
        if pk * qk == n:
            print("FOUND", pk, qk)
            return pk, qk
        
        # Try all possible combinations of the next bit
        poss = [(0,0), (0,2**(k-1)), (2**(k-1),0), (2**(k-1),2**(k-1))]
        for pos in poss:
            new_pk, new_qk = pk + pos[0], qk + pos[1]
            if (F(new_pk, new_qk) % 2**k == leak % 2**k and 
                (new_pk * new_qk) % 2**k == n % 2**k):
                queue.append((new_pk, new_qk, k+1))
