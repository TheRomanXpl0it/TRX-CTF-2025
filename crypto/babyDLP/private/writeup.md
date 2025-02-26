# babyDLP - Writeup  

This challenge has two main parts:  
- **Recovering `d`** (straightforward)  
- **Recovering the flag** (a bit more challenging)  

## Recovering `d`  

This is a classic **biased-nonce attack**, which can be solved using LLL.  

We are given the equations:  

$$
R = (k_1 + k_2) \cdot G
$$

$$
s = \frac{h \cdot k_2 + d \cdot R.x}{k_1}
$$

where `k1` and `k2` are two **32-bit random values**.  
Each time we make a signing query, we get the equation:

$$
s \cdot k_1 = h \cdot k_2 + d \cdot R.x
$$

Here, `k1` and `k2` are the unknowns, and `d` is the secret key we want to extract.  

Since both `k1` and `k2` are small (32-bit), we can **solve this as a system of linear equations with small unknowns** using LLL.  

For details on this I've written a blog post here:  
https://magicfrank00.github.io/writeups/posts/lll-to-solve-linear-equations/


## Recovering the Flag  

At this point, we are given $ \text{flag} \mod \text{order}$


The issue is that the **flag is around 350 bits**, while the **order is only 195 bits**. Brute-forcing the missing 150 bits isn’t feasible.  

After writing this challenge, I realized there's an **extremely similar** challenge by Neobeo. Instead of re-explaining the solution, I’ll just link his excellent writeup here:  

https://web.archive.org/web/20240412075022/https://demo.hedgedoc.org/s/DnzmwnCd7

### Overview on our solution  

We can represent the flag as a sum of its character values multiplied by powers of 256:

$$
c_0 \cdot 256^{43} + c_1 \cdot 256^{42} + \dots + c_{42} \cdot 256 + c_{43}
$$

where each $c_i$ corresponds to a character in the flag.

We're given this equation, but with an **extra modulus term**, so we end up with:

$$
c_0 \cdot 256^{43} + c_1 \cdot 256^{42} + \dots + c_{42} \cdot 256 + c_{43} = m + k \cdot p
$$
where:
- $m$ is the value we are given.
- $p$ is the order of the curve (modulus).
- $c_i$ are the characters of the flag. 

We can apply a few tricks to reduce the size of the unknowns and then solve with LLL:

1. **We know the flag format** starts with `TRX{`, so we can simply subtract this known prefix from the equation. (same for `}`)
2. **We know the remaining flag characters** are mostly **lowercase ASCII letters**, meaning each $c_i$ is close to the **average lowercase ASCII value (≈106)**.  
   So we rewrite the equation as:

   $$
   (c_0 + 106) \cdot 256^{43} + (c_1 + 106) \cdot 256^{42} + \dots + (c_{42} + 106) \cdot 256 + (c_{43} + 106) = m + k \cdot p
   $$

   Now, each unknown $c_i$ is **very close to 0** (within about ±15), which makes LLL effective.

3. **Brute-forcing for more precision**:  
   If we brute-force just **the first unknown character**, we reduce the problem complexity by another **5 bits**, making the solution even more precise.
